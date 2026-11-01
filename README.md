# migrate-calcit-class-record

将三种旧 Calcit 数据格式转换为带 class record 的数据；演示站：
http://repo.calcit-lang.org/migrate-calcit-class-record/ 。

## 使用者需要注意

本分支配对正式 Calcit / JavaScript runtime **0.32.1**，正常安装已发布
Reel **0.7.0**、UI **0.9.0**、Respo **0.17.1**、JS FFI **0.2.9**。
UI 自身固定的 Router alpha 传递依赖保留，不引用 main/hash。升级后重新安装
完整依赖图、生成 JS 并刷新，不混用旧 runtime 或热重载回调。

三个转换按钮及输出布局保持：保留额外 root 字段、缺失字段和显式 nil 的旧行为，
必需 Map 缺失仍失败。它不会读取或覆盖磁盘项目文件，也不保证输出具备当前
Snapshot 所需的全部 metadata；不要因为索引项目已升级就退役仍有用途的旧输入。

**转换会按原逻辑自动复制结果并覆盖系统剪贴板。** 页面左侧输入旧数据，按
Convert_Calcit / Convert_Compact / FileEntry 选择格式，右侧展示结果。

## 本次迁移

通过官方 formatter 更新类型标注语法，为 Respo 的 `dispatch-op` 类型槽提供
真实的开放 Enum 合同；代表值不发送，不新增业务事件包装。仅移除已经不存在的
`reel.util/generate-id!` 导入，保留原导入顺序；既有函数、schema 和附带测试不改。
这不是闭合业务 Op 的证明，也不以 Dynamic 或强转掩盖实际派发边界。

启动仍先恢复并检查存档，再渲染和注册保存。恢复失败时保留原文，并继续用
JS 引入的 `hud!` 显示页面错误，不以 raise 替代。旧保护背景见 [#15](https://github.com/calcit-lang/migrate-calcit-class-record/issues/15)。
本轮不读取真实存档、不删除数据、不操作生产；具体界面验收范围以 PR 为准。

## 开发与验证

需要 Node.js 24、Yarn 4.18.0、官方 Calcit 0.32.1 和 Caps 0.1.1：

```bash
caps --strict --ci
yarn install --immutable
caps verify --toolchain
yarn compile
yarn dev --host 127.0.0.1
```

`yarn release` 只编译和构建，不执行模块发布。CI 保留 canonical、全部定义、
完整 strict、原三格式附带测试、deprecated-call 与 dynamic-method 门禁；不放宽
断言或预算，不新增 checker / runner / concurrently。只有 `calcit.cirru` /
`deps.cirru` 是当前工程入口，`js-out/` 和 `dist/` 不入库。

修改 Snapshot 先读 `calcit docs agents --contract`，用官方 query 视图定位，
再用带 revision 的结构化事务；不再将历史 fix preset 预演作为必需步骤，
不为应用格式增加编译器硬编码改写规则。

## 前端部署

COS 只上传 `dist/`，使用 Action 1.2.0 的 `public-base-url` 内置逐文件校验，
不增加额外上传脚本。原独立 PR 前缀、生产 COS / rsync 路径、队列和过期 main
跳过条件保持。Actions 使用精确正式 tag，按维护者选择接受 tag 可移动风险。
实际远端校验必须通过；不关闭 TLS 或绕过 verify。创建 PR 不代表合并或部署生产。

## License

MIT
