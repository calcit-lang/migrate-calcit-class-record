
Script tool to migrate `calcit.cirru` into data with class records
----

Demo http://repo.calcit-lang.org/migrate-calcit-class-record/ .

### 0.30.1 迁移：用户需要注意

当前候选配对精确正式 Calcit/procs `0.30.1`，模块依赖改用正式
Respo `0.16.126`、UI `0.8.1`、Reel `0.6.42`、js-ffi `0.2.6`，传递 Router `0.8.38`。
升级后请重启开发服务并完整刷新页面，
不要保留旧热重载回调；UI 操作通过具名载体恢复真实 Op，记录到 Reel 前会解包，
不改变业务 Op、存储 key 或三种转换输出的数据结构。

启动先恢复旧存档，再首次渲染和注册持久化。解析或 Store 解码失败会明确中断启动，
不再显示忽略提示后继续保存初始值，避免覆盖原数据。Store 解码失败仍通过 JS 引入的
`hud!` 在页面显示错误，不以控制台异常替代 HUD；遇错应先备份和修复原存档，
不要清空浏览器数据。背景见 [#15](https://github.com/calcit-lang/migrate-calcit-class-record/issues/15)。

这仍是处理旧 IR / compact 数据的迁移工具：保留转换按钮、额外 root 字段、
缺失字段的 nil、显式 nil，以及缺少必需 Map 时的失败行为。它不会自动读取或覆盖
磁盘中的项目文件，也不表示生成结果已自动符合最新 Snapshot 的全部 metadata 要求。

19 处底层 Map 读取已改为公开 get/Option；已移除类型断言，改用真实 Struct 匹配和
已有 decoder，在必需 Map、事件输入和开放状态树边界检查数据。`CodeEntry.doc`、
Expr 的子节点 Map 及转换函数的 Map 返回类型明确化；旧数据元信息和异构状态
仍诚实保留 Dynamic，不新增 unsafe 或编译器迁移规则。

此前 alpha.4 本地验证包含完整 strict、全部定义/公开 namespace 检查、单个附着测试覆盖三种
旧格式、JS/Vite 构建，以及独立配对 0.27.0 的转换输出对比。浏览器实际输入、
转换和输出显示通过；旧版保存的 State、Op 身份、Reel 回放和混合游标也已回放。
干净 Caps 安装与远端门禁以 PR Actions 为准，本地没有执行 Caps。
上述历史结果不作为本轮正式依赖图验收；本轮保留原测试与完整 strict，以全定义检查
覆盖所有项目定义，不再重复逐命名空间检查，版本只由 deps.cirru 和 toolchain 验证配对。

### Usages

```bash
caps --strict --ci
caps verify --toolchain
calcit calcit.cirru js
yarn vite build --base=./
```

Before changing the Snapshot, read `calcit docs agents --contract`, inspect the
affected definitions through official query views, and use the structured editor.
The historical `surface-latest-v2` preview is no longer a mandatory step.
Use diagnostics and the original tests to guide targeted fixes instead of adding
application-specific rewrite rules to the compiler.

本轮只迁移开发模式读取的 Option 默认值调用，以及复制日志的 String 长度读取；
三个旧格式转换函数、原附带测试、HUD、启动恢复及持久化顺序保持不变。
这不表示旧输入需求已消失，也不自动提升转换结果到最新 Snapshot metadata。

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

Frontend assets use COS Action 1.2.0's built-in public URL verification; no
additional upload checker is needed. PR previews have independent
`<repository>/pr/<number>/<run>/<attempt>/` CDN paths. Uploads queue without
cancelling an in-progress upload. The production COS prefix and server
deployment path stay unchanged. Before publishing, a superseded main run skips
both the COS upload and server deployment; isolated PR previews are unaffected.

Deployment paths, COS built-in verification, queue policy and Caps conflict
policy remain unchanged. Actions use exact formal tags (the user accepts their
movability). No extra upload verification script or concurrently is added.
此前曾有 CDN 证书过期问题；本轮必须由实际 COS 校验重新确认，不绕过 TLS，
也不因工具链升级而自动合并或部署生产。

这个独立工具的旧格式转换仍保留。索引中的版本声明不能证明旧输入已经清零，
因此本轮不退役转换按钮、不扩充编译器硬编码规则，也不把输出宣称为当前 Snapshot 编辑入口。

### License

MIT
