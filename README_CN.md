# Erlang QoL Snippets（Erlang 代码生成片段）

为 [Zed 编辑器](https://zed.dev) 提供 Erlang 代码生成模板与常用代码片段，移植自 [erlang-code-generation](https://github.com/Qualia91/erlang-code-generation) VSCode 扩展。

## 功能特性

- **11 个模块模板** —— gen_server、gen_statem、supervisor、header（`.hrl` 含 include guard）、空模块、Common Test 套件、poolboy worker、cowboy websocket handler、cowboy REST handler、lager handler、escript
- **3 个注释模板** —— 头部（header）/ 段落（section）/ 函数（function）
- **14 个日常代码片段** —— log、receive、case、try、eunit 测试、poolboy/cowboy/子进程规范等

## 环境要求

- Zed 编辑器
- 提供 Erlang 语言的扩展（如官方 [`erlang`](https://github.com/zed-extensions/erlang) 扩展，它内置 ELP 与 erlang_ls 语言服务器）。snippet 作用域为 `Erlang` 语言。

## 安装（开发模式）

在本扩展发布到 Zed 插件市场之前，以 dev extension 方式安装：

1. Zed → Extensions 面板 → **Install Dev Extension**（或在命令面板执行 `zed: install dev extension`）
2. 选择本仓库目录
3. 面板中将出现 `erlang-qol-snippets` 卡片（标记为 dev extension）

## 使用方法

### 方式一：输入前缀触发补全

打开 `.erl` / `.hrl` 文件，输入前缀并从补全菜单选择：

| 前缀 | 片段 |
| --- | --- |
| `log` | 控制台输出 |
| `rec` / `reca` | receive / 带 after 的 receive |
| `case` / `if` / `try` / `?` | case / if / try / 单行 try-catch |
| `eunit` | eunit 测试段落 |
| `pools` / `cows` / `works` / `sups` | poolboy 配置 / cowboy web supervisor / worker 子进程规范 / supervisor 子进程规范 |
| `comsec` / `funsec` / `comhdr` | 注释：段落 / 函数 / 头部 |
| `mod-genserver` | gen_server 模块模板 |
| `mod-genstatem` | gen_statem 模块模板 |
| `mod-supervisor` | supervisor 模块模板 |
| `mod-header` | header（`.hrl`）模板（含 include guard） |
| `mod-empty` | 空模块模板 |
| `mod-ct` | Common Test 套件模板 |
| `mod-poolboy-worker` | poolboy worker 模板 |
| `mod-websocket-handler` | cowboy websocket handler 模板 |
| `mod-rest-handler` | cowboy REST handler 模板 |
| `mod-lager-handler` | lager handler 模板 |
| `mod-escript` | escript 模板 |

### 方式二：快捷键触发（推荐）

Zed 扩展无法注册命令，因此模块模板通过在你自己的 keymap 中绑定 [`editor::InsertSnippet`](https://zed.dev/docs/keymaps) 动作来触发（Windows 路径为 `%APPDATA%\Zed\keymap.json`）：

```json
[
  {
    "context": "Editor && !menu && !picker",
    "bindings": {
      "ctrl-shift-p g": ["editor::InsertSnippet", { "language": "erlang", "name": "module: gen_server template" }],
      "ctrl-shift-p s": ["editor::InsertSnippet", { "language": "erlang", "name": "module: gen_statem template" }],
      "ctrl-shift-p u": ["editor::InsertSnippet", { "language": "erlang", "name": "module: supervisor template" }],
      "ctrl-shift-p h": ["editor::InsertSnippet", { "language": "erlang", "name": "module: header template" }],
      "ctrl-shift-p e": ["editor::InsertSnippet", { "language": "erlang", "name": "module: empty template" }],
      "ctrl-shift-p c": ["editor::InsertSnippet", { "language": "erlang", "name": "module: CT template" }],
      "ctrl-shift-p p": ["editor::InsertSnippet", { "language": "erlang", "name": "module: poolboy worker template" }],
      "ctrl-shift-p w": ["editor::InsertSnippet", { "language": "erlang", "name": "module: websocket handler template" }],
      "ctrl-shift-p r": ["editor::InsertSnippet", { "language": "erlang", "name": "module: cowboy rest handler template" }],
      "ctrl-shift-p l": ["editor::InsertSnippet", { "language": "erlang", "name": "module: lager handler template" }],
      "ctrl-shift-p x": ["editor::InsertSnippet", { "language": "erlang", "name": "module: escript template" }],
      "ctrl-shift-p 1": ["editor::InsertSnippet", { "language": "erlang", "name": "comment: header" }],
      "ctrl-shift-p 2": ["editor::InsertSnippet", { "language": "erlang", "name": "comment: section" }],
      "ctrl-shift-p 3": ["editor::InsertSnippet", { "language": "erlang", "name": "comment: function" }]
    }
  }
]
```

按 `ctrl-shift-p` 后再按对应字母即可插入模板。注意：组合键等待期间，单独按 `ctrl-shift-p` 打开命令面板会有约 1 秒延迟。`$1`/`$2`/`$3` tabstop 会依次引导你填写模块名、作者和字段。

## 编辑模板 / 新增片段

Zed 要求同一语言的所有 snippet 必须位于单个文件中（`snippets/erlang.json`），因此本仓库在 `snippets-src/` 下按"一个文件一个 snippet"维护源码，再用构建脚本合并。

1. 编辑 `snippets-src/<编号-名称>.json`（每个文件一个 snippet），或新增一个，例如 `27-my-snippet.json`：

   ```json
   {
     "My snippet": {
       "prefix": "my",
       "body": ["...", "\t${1:placeholder}"],
       "description": "可选描述"
     }
   }
   ```

2. 运行合并脚本（PowerShell，无依赖）：

   ```powershell
   .\build.ps1
   ```

3. 在 Zed 的 Extensions 面板点击 dev extension 卡片上的 **Rebuild**。

注意事项：

- snippet 名称必须唯一（构建脚本遇重名会报错）。
- tabstop 必须连续编号（`$1`、`$2` …… 最后用 `$0`）；相同编号的占位符是联动的（输入一次，所有位置同步填充）。
- Zed 不支持 snippet 变量（如 `$TM_FILENAME_BASE`），请改用联动 tabstop。
- body 中若含字面量 `$`，需转义为 `\\$`。
- 不要直接修改 `snippets/erlang.json` —— 它由 `build.ps1` 生成。

## 贡献人员

- 原插件 [erlang-code-generation](https://github.com/Qualia91/erlang-code-generation) 及其开发者 [Qualia91](https://github.com/Qualia91) —— 本项目是其作品的 Zed 移植版。

## 开源协议

[MIT](LICENSE) —— 部分内容衍生自 MIT 协议的 [erlang-code-generation](https://github.com/Qualia91/erlang-code-generation) VSCode 扩展（Copyright (c) 2022 BOC Dev）。

[English README](README.md)
