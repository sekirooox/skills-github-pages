# 本次迁移验证记录

验证日期：2026-09-26（Asia/Shanghai）。

## 已通过

- 本机隔离 Ruby 3.4.11 + Chirpy 7.6.0 安装与真实生产构建。
- 配置、工作流、Docker Compose 和所有文章/栏目 Front Matter 的 YAML 解析。
- `JEKYLL_ENV=production bundle exec jekyll build --destination _site/skills-github-pages`。
- HTMLProofer：26 个 HTML 文件、46 条内部链接、5 个文件中的内部锚点检查通过；检查包括 Images、Links、Scripts，禁用外部链接探测。
- Edge 浏览器：首页四篇文章显示，欢迎文章置顶；搜索 Mermaid 返回对应文章。
- 数学公式和 Mermaid 流程图实际渲染；浅色与深色显示正常。
- 390 × 844 手机视口：文章排版与侧栏展开正常；测试后已恢复桌面视口。
- 原文章保留，生成旧日期地址到新文章地址的跳转页。
- `csdn-repo/` 未进入最终 `_site/skills-github-pages`。
- `git diff --check` 无空白错误。

## 验证中修复

- Chirpy 自带 RSS 模板，移除了额外的 jekyll-feed 插件，避免两个文件竞争输出 feed.xml。
- Chirpy 自动为文章图片增加 baseurl，示例图片改用主题原生路径写法，避免重复仓库名前缀。
- 便携 Ruby 的下载证书兼容问题通过临时本机下载桥接解决，上游 HTTPS 验证保持开启；临时镜像配置已清除，服务已停止，Gemfile/lock 仍引用官方 RubyGems。
- Windows HTMLProofer 使用本机 Git 已有的 libcurl 完成检查；此临时适配位于 `.tools/`，不提交。CI 使用 Linux 原生环境。

## 尚未执行

- Docker / Dev Container 配置已提供，但本机没有 Docker，未实际启动容器。
- 未提交、推送或运行远端 GitHub Actions；尚未修改 GitHub Pages Source。
- 未启用需要真实账户信息的评论、访问统计与第三方验证。

上线前按维护手册将 Pages Source 设置为 GitHub Actions，再提交并推送博客变更。远端 CI 通过后才算完成线上发布。
