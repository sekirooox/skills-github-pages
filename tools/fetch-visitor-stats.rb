#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "json"
require "tempfile"
require_relative "lib/visitor_stats"

output_path = ARGV.fetch(0, "_data/visitor_stats_generated.json")

begin
  data = VisitorStats::Client.new(
    token: ENV["GOATCOUNTER_API_KEY"],
    start_time: ENV.fetch("VISITOR_STATS_START", VisitorStats::Client::DEFAULT_START)
  ).fetch

  directory = File.dirname(output_path)
  FileUtils.mkdir_p(directory)
  Tempfile.create(["visitor-stats", ".json"], directory) do |file|
    file.write(JSON.pretty_generate(data))
    file.write("\n")
    file.flush
    file.fsync
    FileUtils.mv(file.path, output_path)
  end
  warn "访客统计已更新：#{data.fetch('total_visits')} 次访问，#{data.fetch('countries').length} 个国家或地区"
rescue VisitorStats::Error, KeyError => e
  warn "访客统计生成失败：#{e.message}"
  exit 1
end
