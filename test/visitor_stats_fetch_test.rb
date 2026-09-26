# frozen_string_literal: true

require "minitest/autorun"
require "json"
require_relative "../tools/lib/visitor_stats"

class VisitorStatsFetchTest < Minitest::Test
  Response = Struct.new(:code, :body)

  def test_fetches_all_pages_and_builds_country_summary
    calls = []
    responses = [
      ok("total" => 123),
      ok("more" => true, "stats" => [
           { "id" => "CN", "name" => "China", "count" => 80 },
           { "id" => "US", "name" => "United States", "count" => 15 },
           { "id" => "??", "name" => "Unknown", "count" => 1 },
           { "id" => "ZZ", "name" => "Invalid", "count" => 1 }
         ]),
      ok("more" => false, "stats" => [
           { "id" => "cn", "name" => "China", "count" => 20 },
           { "id" => "JP", "name" => "Japan", "count" => 6 }
         ])
    ]
    http = lambda do |uri, headers|
      calls << [uri, headers]
      responses.shift
    end

    result = client(http_get: http).fetch

    assert_equal 123, result["total_visits"]
    assert_equal 2, result["unknown_visits"]
    assert_equal %w[CN US JP], result["countries"].map { |country| country["code"] }
    assert_equal 100, result["countries"].first["visits"]
    assert_in_delta 100.0 / 123, result["countries"].first["share"], 0.000001
    assert_equal "4", URI.decode_www_form(calls.last[0].query).to_h.fetch("offset")
    assert calls.all? { |_uri, headers| headers["Authorization"] == "Bearer secret-token" }
  end

  def test_zero_total_uses_zero_share
    responses = [ok("total" => 0), ok("more" => false, "stats" => [])]
    result = client(http_get: ->(_uri, _headers) { responses.shift }).fetch

    assert_equal [], result["countries"]
    assert_equal 0, result["unknown_visits"]
  end

  def test_missing_token_fails
    error = assert_raises(VisitorStats::Error) { client(token: "") }
    assert_match(/GOATCOUNTER_API_KEY/, error.message)
  end

  [401, 403, 429, 500].each do |status|
    define_method("test_http_#{status}_fails") do
      error = assert_raises(VisitorStats::Error) do
        client(http_get: ->(_uri, _headers) { Response.new(status.to_s, "{}") }).fetch
      end
      assert_match(/Token|权限|频繁|HTTP/, error.message)
      assert_match(%r{/api/v0/stats/total}, error.message)
    end
  end

  def test_invalid_json_fails
    error = assert_raises(VisitorStats::Error) do
      client(http_get: ->(_uri, _headers) { Response.new("200", "not-json") }).fetch
    end
    assert_match(/非法 JSON/, error.message)
  end

  def test_non_object_json_fails
    error = assert_raises(VisitorStats::Error) do
      client(http_get: ->(_uri, _headers) { Response.new("200", "[]") }).fetch
    end
    assert_match(/根节点必须是对象/, error.message)
  end

  def test_malformed_total_fails
    error = assert_raises(VisitorStats::Error) do
      client(http_get: ->(_uri, _headers) { ok("total" => "12.5") }).fetch
    end
    assert_match(/total/, error.message)
  end

  def test_malformed_locations_fails
    responses = [ok("total" => 1), ok("more" => false, "stats" => {})]
    error = assert_raises(VisitorStats::Error) do
      client(http_get: ->(_uri, _headers) { responses.shift }).fetch
    end
    assert_match(/stats 数组/, error.message)
  end

  def test_empty_pagination_page_fails
    responses = [ok("total" => 1), ok("more" => true, "stats" => [])]
    error = assert_raises(VisitorStats::Error) do
      client(http_get: ->(_uri, _headers) { responses.shift }).fetch
    end
    assert_match(/空页/, error.message)
  end

  private

  def client(token: "secret-token", http_get: ->(_uri, _headers) { flunk "不应发起 HTTP 请求" })
    VisitorStats::Client.new(
      token: token,
      start_time: "2026-09-26T00:00:00+08:00",
      end_time: "2026-09-26T08:00:00Z",
      http_get: http_get
    )
  end

  def ok(payload)
    Response.new("200", JSON.generate(payload))
  end
end
