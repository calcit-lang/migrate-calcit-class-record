# Calcit 0.13.77 migration checkpoint

## English

- Upgraded the compiler and `@calcit/procs` to 0.13.77 and moved Respo, Reel, Respo UI, Lilac, and Memof to their latest immutable releases available through Caps.
- Replaced eleven raw Struct reads with checked field access or Reel's public compatibility reader, and compared the dispatch operation tag in its actual `Option` container. These changes remove every repository-local preprocessing warning without adding a coercion.
- Added project version 0.0.1 to `deps.cirru` and generated a per-definition quality baseline for pre-existing dynamic, nil, deprecated anonymous-enum matching, and reviewed coercion debt.
- Hardened CI with immutable action revisions, read-only permissions, strict dependency/toolchain checks, canonical Snapshot verification, quality/dynamic-dispatch gates, and push-only deployment.
- The checkpoint is blocked from PR by the remaining released Respo 0.16.90 `decorate-defcomp` warning tracked in calcit-lang/calcit#670. The warning is in the installed dependency; local check-only and JS codegen proceed through all project definitions before rejecting that single upstream warning.

## 中文

- 将 compiler 与 `@calcit/procs` 升级到 0.13.77，并通过 Caps 把 Respo、Reel、Respo UI、Lilac、Memof 对齐到当前可用的最新不可变 release。
- 将 11 处底层 Struct 读取改为可检查字段访问或 Reel 的公开兼容读取函数，并在真实的 `Option` 容器中比较 dispatch 操作 tag；本仓自身的预处理告警已全部清零，且没有新增 coercion。
- 在 `deps.cirru` 中补充现有项目版本 0.0.1，并为升级前已有的 dynamic、nil、匿名 enum deprecated 匹配及已审计 coercion 债务生成逐定义质量 baseline。
- 使用不可变 Action commit、只读权限、严格依赖/工具链、规范 Snapshot、质量/动态分派门禁和仅 main push 部署加固 CI。
- 当前 checkpoint 因已发布 Respo 0.16.90 的 `decorate-defcomp` 告警而不能提交 PR，跟踪于 calcit-lang/calcit#670。该告警来自已安装依赖；本地 check-only 与 JS codegen 已遍历所有项目定义，最终仅因这一条上游告警拒绝通过。
