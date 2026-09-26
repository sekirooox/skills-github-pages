# frozen_string_literal: true

require "json"
require "net/http"
require "set"
require "time"
require "uri"

module VisitorStats
  class Error < StandardError; end

  class Client
    DEFAULT_BASE_URL = "https://mayl.goatcounter.com"
    DEFAULT_START = "2026-09-26T00:00:00+08:00"
    PAGE_SIZE = 100
    COUNTRY_CODES = %w[
      AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ
      CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO
      FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE
      JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO
      MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW
      PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM
      TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW
    ].to_set.freeze

    def initialize(token:, base_url: DEFAULT_BASE_URL, start_time: DEFAULT_START,
                   end_time: Time.now.utc.iso8601, http_get: nil)
      raise Error, "缺少 GOATCOUNTER_API_KEY" if token.nil? || token.strip.empty?

      @token = token
      @base_url = base_url
      @start_time = parse_time(start_time, "统计开始时间")
      @end_time = parse_time(end_time, "统计结束时间")
      raise Error, "统计结束时间早于开始时间" if @end_time < @start_time

      @http_get = http_get || method(:net_http_get)
    end

    def fetch
      total = fetch_total
      countries, unknown = fetch_locations

      {
        "available" => true,
        "metric" => "goatcounter_visits",
        "period_start" => @start_time.iso8601,
        "generated_at" => @end_time.utc.iso8601,
        "total_visits" => total,
        "unknown_visits" => unknown,
        "countries" => countries
          .sort_by { |code, visits| [-visits, code] }
          .map do |code, visits|
            {
              "code" => code,
              "name" => @country_names.fetch(code, code),
              "visits" => visits,
              "share" => total.zero? ? 0.0 : (visits.to_f / total).round(6)
            }
          end
      }
    end

    private

    def fetch_total
      payload = get_json("/api/v0/stats/total", query_params)
      integer(payload["total"], "total")
    end

    def fetch_locations
      offset = 0
      visits = Hash.new(0)
      @country_names = {}
      unknown = 0

      loop do
        payload = get_json(
          "/api/v0/stats/locations",
          query_params.merge("limit" => PAGE_SIZE, "offset" => offset)
        )
        rows = payload["stats"]
        raise Error, "locations 响应缺少 stats 数组" unless rows.is_a?(Array)
        raise Error, "locations 响应中的 more 必须为布尔值" unless [true, false].include?(payload["more"])

        rows.each do |row|
          raise Error, "locations 包含无效记录" unless row.is_a?(Hash)

          count = integer(row["count"], "locations.count")
          code = row["id"].to_s.upcase
          if COUNTRY_CODES.include?(code)
            visits[code] += count
            name = row["name"].to_s.strip
            @country_names[code] = name unless name.empty?
          else
            unknown += count
          end
        end

        break unless payload["more"]
        raise Error, "locations 分页返回空页" if rows.empty?

        offset += rows.length
      end

      [visits, unknown]
    end

    def query_params
      { "start" => @start_time.iso8601, "end" => @end_time.iso8601 }
    end

    def get_json(path, params)
      uri = URI.join("#{@base_url}/", path.sub(%r{\A/}, ""))
      uri.query = URI.encode_www_form(params)
      response = @http_get.call(uri, { "Authorization" => "Bearer #{@token}" })
      status = response_status(response)

      unless status.between?(200, 299)
        label = case status
                when 401 then "API Token 无效或已失效"
                when 403 then "API Token 缺少读取站点或统计权限"
                when 429 then "GoatCounter API 请求过于频繁"
                else "GoatCounter API 返回 HTTP #{status}"
                end
        raise Error, label
      end

      body = response_body(response)
      raise Error, "GoatCounter API 响应正文无效" unless body.is_a?(String)

      payload = JSON.parse(body)
      raise Error, "GoatCounter API JSON 根节点必须是对象" unless payload.is_a?(Hash)

      payload
    rescue JSON::ParserError
      raise Error, "GoatCounter API 返回了非法 JSON"
    rescue URI::InvalidURIError => e
      raise Error, "GoatCounter API 地址无效：#{e.message}"
    rescue SystemCallError, SocketError, Timeout::Error => e
      raise Error, "无法连接 GoatCounter API：#{e.message}"
    end

    def response_status(response)
      value = response.respond_to?(:code) ? response.code : response.fetch(:status)
      value.is_a?(Integer) ? value : Integer(value, 10)
    rescue ArgumentError, TypeError, KeyError
      raise Error, "HTTP 响应缺少有效状态码"
    end

    def response_body(response)
      response.respond_to?(:body) ? response.body : response.fetch(:body)
    rescue KeyError
      raise Error, "HTTP 响应缺少正文"
    end

    def integer(value, field)
      number = value.is_a?(Integer) ? value : Integer(value, 10)
      raise Error, "#{field} 不能为负数" if number.negative?

      number
    rescue ArgumentError, TypeError
      raise Error, "#{field} 不是非负整数"
    end

    def parse_time(value, label)
      Time.iso8601(value)
    rescue ArgumentError, TypeError
      raise Error, "#{label}不是有效的 ISO-8601 时间"
    end

    def net_http_get(uri, headers)
      request = Net::HTTP::Get.new(uri, headers)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https",
                      open_timeout: 10, read_timeout: 30) do |http|
        http.request(request)
      end
    end
  end
end
