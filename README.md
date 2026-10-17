
Script tool to migrate `calcit.cirru` into data with class records
----

Demo http://repo.calcit-lang.org/migrate-calcit-class-record/ .

### 0.30.1 迁移：用户需要注意

当前候选配对 Calcit/procs `0.30.1-alpha.4`（预发布版），模块依赖改用正式
Respo `0.16.122`、UI `0.7.41`、Reel `0.6.39`。升级后请完整刷新页面，
不要保留旧热重载回调；UI 操作通过具名载体恢复真实 Op，记录到 Reel 前会解包，
不改变业务 Op、存储 key 或三种转换输出的数据结构。

这仍是处理旧 IR / compact 数据的迁移工具：保留转换按钮、额外 root 字段、
缺失字段的 nil、显式 nil，以及缺少必需 Map 时的失败行为。它不会自动读取或覆盖
磁盘中的项目文件，也不表示生成结果已自动符合最新 Snapshot 的全部 metadata 要求。

19 处底层 Map 读取已改为公开 get/Option；已移除类型断言，改用真实 Struct 匹配和
已有 decoder，在必需 Map、事件输入和开放状态树边界检查数据。`CodeEntry.doc`、
Expr 的子节点 Map 及转换函数的 Map 返回类型明确化；旧数据元信息和异构状态
仍诚实保留 Dynamic，不新增 unsafe 或编译器迁移规则。

本地验证包含完整 strict、全部定义/公开 namespace 检查、单个附着测试覆盖三种
旧格式、JS/Vite 构建，以及独立配对 0.27.0 的转换输出对比。浏览器实际输入、
转换和输出显示通过；旧版保存的 State、Op 身份、Reel 回放和混合游标也已回放。
干净 Caps 安装与远端门禁以 PR Actions 为准，本地没有执行 Caps。

### Usages

```bash
caps --strict --ci
caps verify --toolchain
calcit calcit.cirru js
yarn vite build --base=./
```

Before changing the Snapshot, read `calcit docs agents --contract` and
`calcit docs read upgrade`, then preview the current syntax rules with
`calcit fix --preset surface-latest-v2 --format edn`.

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
The known CDN certificate-expiry problem must be resolved before claiming
public COS verification or production deployment succeeded; this migration
does not bypass TLS or authorize a production merge.

### License

MIT
