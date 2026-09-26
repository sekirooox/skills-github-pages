# frozen_string_literal: true

site = ARGV.fetch(0, "_site")
home_path = File.join(site, "index.html")
abort "找不到生成的首页：#{home_path}" unless File.file?(home_path)

home = File.read(home_path, encoding: "UTF-8")
checks = {
  "首页包含个人介绍布局" => home.include?('id="home-profile"'),
  "首页包含累计访问" => home.include?('id="visitor-total-value"'),
  "首页包含世界地图" => home.include?('id="visitor-map"'),
  "首页加载地图脚本" => home.include?("/assets/vendor/jsvectormap/world.js"),
  "首页没有文章列表" => !home.match?(/id=["']post-list|class=["'][^"']*post-list/),
  "首页侧栏面板被专用样式隐藏" => home.include?("/assets/css/home.css"),
  "没有分页首页" => !File.exist?(File.join(site, "page2", "index.html")),
  "旧项目地址保留跳转" => File.file?(File.join(site, "skills-github-pages", "index.html"))
}

post_path = Dir.glob(File.join(site, "posts", "**", "index.html")).first
checks["至少生成一篇文章"] = !post_path.nil?
if post_path
  post = File.read(post_path, encoding: "UTF-8")
  checks["文章页不公开阅读次数"] = !post.include?('id="pageviews"')
  checks["文章页不加载首页地图资源"] = !post.include?("jsvectormap")
end

html_files = Dir.glob(File.join(site, "**", "*.html"))
checks["所有内容页面加载 GoatCounter"] = html_files.all? do |path|
  html = File.read(path, encoding: "UTF-8")
  html.include?('http-equiv="refresh"') || html.include?("gc.zgo.at/count.js")
end

public_files = Dir.glob(File.join(site, "**", "*.{html,js,json,css}"))
checks["公开文件不含 API Secret 名称或认证头"] = public_files.none? do |path|
  content = File.binread(path)
  content.include?("GOATCOUNTER_API_KEY") || content.include?("Authorization: Bearer")
end

failures = checks.reject { |_name, passed| passed }.keys
if failures.empty?
  puts "站点输出验证通过（#{checks.length} 项）"
else
  warn "站点输出验证失败："
  failures.each { |failure| warn "- #{failure}" }
  exit 1
end
