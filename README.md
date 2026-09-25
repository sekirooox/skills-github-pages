# MayL 的博客

使用官方 **Chirpy 7.6.0**，中文界面，上海时区，通过 GitHub Actions 部署。

- 站点：<https://sekirooox.github.io/skills-github-pages/>
- **[完整使用与维护手册](docs/MAINTENANCE.md)**：环境、部署、项目结构、写作、栏目扩展、评论、样式、升级与排错。
- [文章模板](templates/post.md)

## 首次发布

在仓库 **Settings → Pages → Source** 选择 **GitHub Actions**，然后提交并推送本次迁移。查看 **Build and Deploy** 工作流结果。

原 GitHub Skills 教程流程已归档到 `docs/legacy-github-skills/`，不再触发初始化。

## 本地预览

安装并启动 Docker Desktop 后：

```sh
docker compose up --build
```

或在已有 Ruby 3.4 环境中：

```sh
bundle install
bundle exec jekyll serve --livereload
```

打开 <http://localhost:4000/skills-github-pages/>。Windows 本机也可运行 `./tools/preview.ps1`；VS Code 可使用本仓库 Dev Container。

## 写文章

复制 `templates/post.md` 到 `_posts/YYYY-MM-DD-英文短名.md`，修改日期（带 `+0800`）、标题、摘要、分类、标签和正文。

保留了最初的 `MyFirstBlog`，另附三篇可删除示例：入门与置顶、Markdown 排版、数学与 Mermaid。删除示例时同步删除相互引用。

## 验证

```sh
bash tools/test.sh
```

CI 在 PR 和 main 推送时构建并检查内部链接；只有 main 推送及手动触发才发布。

## 上游与许可

基于 [Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy) 与 [Chirpy Starter](https://github.com/cotes2020/chirpy-starter)，上游许可证见 [第三方说明](THIRD-PARTY-NOTICES.md)。
