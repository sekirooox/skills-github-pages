# GoatCounter 访问统计与阅读次数

## 当前接入

- 博客：https://sekirooox.github.io/
- 管理后台：https://mayl.goatcounter.com/（需要登录）
- `_config.yml` 中 `analytics.goatcounter.id: mayl` 启用访问记录。
- `pageviews.provider: goatcounter` 在文章标题下方展示阅读次数。
- 后台已开启 **Allow adding visitor counts on your website**，允许公开查询汇总计数；完整后台仍然仅登录可见。
- 不需要 API 密钥，也不要把账号密码或 API 密钥写入仓库。

## 可以直接使用的功能

1. **热门文章**：后台 Pages 查看各页面的访问情况，可用路径筛选文章。
2. **趋势分析**：选择日、周、月等时间范围，观察文章发布后的访问变化。
3. **来源分析**：Top referrers 查看访客从哪些网站进入。
4. **设备分析**：Browsers、Systems、Sizes 查看浏览器、操作系统和屏幕尺寸分布。
5. **推广链接**：分享时添加参数，例如 `https://sekirooox.github.io/?utm_campaign=blog-share&utm_source=wechat`。实际访问后会自动出现在 Campaigns，不需要提前创建活动。可将来源改为 `qq`、`csdn` 等进行比较。
6. **排除自己的访问**：后台 Settings → Tracking → disable for this browser 可在当前浏览器切换忽略自己的访问。切换后按页面提示确认状态，其他设备需分别操作。
7. **导出统计**：后台 Settings → Import/Export 查看可用导出选项。当前未额外开启逐条访问记录存储。

这些功能使用后台已有的统计选项，不需要公开整个仪表盘。

## 本地预览与上线

正常运行 `tools/preview.ps1` 时，Jekyll 使用开发环境，不注入统计脚本。文章阅读次数在本地显示占位符，避免将本地地址当成线上访问。

GitHub Actions 使用 `JEKYLL_ENV=production` 构建，发布后才会加载统计脚本。修改配置后需要重新部署；本地修改 `_config.yml` 需要重启预览进程。

上线后打开一篇文章，再到后台查看 Pages。新站没有历史记录；公开阅读次数接口可能缓存最多四小时，不能通过连续刷新来判断是否接入成功。

## 阅读次数的含义与异常

公开计数采用 GoatCounter 返回的访客计数口径，不等于每一次刷新次数，也不代表精确的自然人数。会话设置会影响去重。

本项目覆盖了主题的 `_includes/pageviews/goatcounter.html`：查询失败显示 `—` 并提示暂不可用，避免主题默认失败时显示 `1` 造成误解。正常返回零时显示 `0`。

如果一直没有数据，检查部署是否完成、`mayl` 是否填写正确、浏览器拦截扩展或网络是否阻止 `gc.zgo.at` / `mayl.goatcounter.com`。如果后台有数据但页面无计数，检查公开计数开关与文章路径是否一致，再等待缓存更新。文章更换永久链接后，新旧路径会分别统计。

## 官方文档

- [公开阅读次数与缓存](https://www.goatcounter.com/help/visitor-counter)
- [推广来源参数](https://www.goatcounter.com/help/campaigns)
