# migrate-calcit-class-record

将三种旧 Calcit 数据格式转换为带 class record 的数据；演示站：
http://repo.calcit-lang.org/migrate-calcit-class-record/ 。

## 使用者需要注意

本项目配对 Calcit / JavaScript runtime **0.41.0**，使用正式 Reel **0.11.0**、UI **0.15.2**、Respo **0.19.5**、JS FFI **0.2.13**，传递 Router **0.12.2**。升级后重新严格安装依赖、生成 JS 并刷新页面。

`transform-code` 的返回值声明为 `CodeNode` union，成员为本地 Expr 和 Leaf。读取历史输入时继续保留扩展字段、缺失值和显式 nil 的原行为。UI 基础样式可能随依赖升级变化。

表达式的子节点现在也声明为 `Map Dynamic CodeNode`，递归复用同一 union，
不再把已转换的子节点退回 Dynamic。Map 的异构 key，以及历史 `by` / `at` / `text`
字段仍保持开放，不因此拒绝旧输入。此处只收紧转换后节点的类型，输出格式不变。

三个转换按钮及输出布局保持：保留额外 root 字段、缺失字段和显式 nil 的旧行为，
必需 Map 缺失仍失败。它不会读取或覆盖磁盘项目文件，也不保证输出具备当前
Snapshot 所需的全部 metadata；不要因为索引项目已升级就退役仍有用途的旧输入。

**转换会按原逻辑自动复制结果并覆盖系统剪贴板。** 页面左侧输入旧数据，按
Convert_Calcit / Convert_Compact / FileEntry 选择格式，右侧展示结果。
复制组件从初始页面就挂载，交互前传 nil，首次键入后转换也能触发原 update 复制；
不在 mount 阶段复制，避免恢复旧结果时仅因刷新就覆盖剪贴板。

## 本次迁移

组件状态游标使用 Respo 的 `CoordKey`，状态操作携带本地 `State`。存档中游标元素无效时沿用原恢复失败提示，保留原文。历史输入和输出仍保留异构字段。

输入、粘贴和转换按钮直接发送具名 `Op`，Reel 快捷键直接发送具名 `Control`。
内部派发用 `Op | reel.typed/Control` 区分应用操作和回放操作。
Respo 入口仍接收开放 Enum，以兼容旧 `:app/event` 和 Reel 控制事件，并在进入内部派发前解码。
组件树通过 `render-with!` 构建，为 Reel 列表提供 Respo 要求的 memo 帧。

启动仍先恢复并检查存档，再渲染和注册保存。存档解码返回 none 时保留原文，
先用 JS 引入的 `hud!` 显示页面错误，再由既有 `raise` 中止启动；不会继续渲染、
注册监听器或定时保存。保留 `hud!`，不以单独的 raise 替代页面错误提示。旧保护背景见 [#15](https://github.com/calcit-lang/migrate-calcit-class-record/issues/15)。
存档中的 State 经格式化/解析后不再具有本地名义来源。恢复时仅把 Struct 当作数据转为 Map，
用正式 typed decoder 检查完整字段后构造本地 State；名称不代表身份，错误仍经 HUD 报告并中止保存注册。
保留状态 cursor、其他状态键和既有 Map/Struct 存档格式，不清空原文。新增一项针对实测往返失败的附带回归。
本轮不读取真实存档、不删除数据、不操作生产；具体界面验收范围以 PR 为准。

## 开发与验证

需要 Node.js 24、Yarn 4.18.0、官方 Calcit 0.41.0 和 Caps 0.1.1：

```bash
caps --strict --ci
yarn install --immutable
caps verify --toolchain
yarn compile
yarn dev --host 127.0.0.1
```

`yarn release` 只编译和构建，不执行模块发布。CI 保留 canonical、全部定义、
完整 strict、原三种格式的附带测试、新 State 往返回归、deprecated-call 与 dynamic-method 门禁；不放宽
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
