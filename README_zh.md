# 🦌 DeerFlow - 2.0

[![Python](https://img.shields.io/badge/Python-3.12%2B-3776AB?logo=python&logoColor=white)](./backend/pyproject.toml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

<a href="https://trendshift.io/repositories/14699" target="_blank"><img src="https://trendshift.io/api/badge/repositories/14699" alt="bytedance%2Fdeer-flow | Trendshift" style="width: 250px; height: 55px;" width="250" height="55"/></a>

> 2026 年 2 月 28 日，DeerFlow 2 发布后登上 GitHub Trending 第 1 名。非常感谢社区的支持，这是大家一起做到的。

DeerFlow（**D**eep **E**xploration and **E**fficient **R**esearch **Flow**）是一个开源的 **super agent harness**。它把 **sub-agents**、**memory** 和 **sandbox** 组织在一起，再配合可扩展的 **skills**，让 agent 可以完成几乎任何事情。

https://github.com/user-attachments/assets/a8bcadc4-e040-4cf2-8fda-dd768b999c18

> [!NOTE]
> **DeerFlow 2.0 是一次彻底重写。** 它和 v1 没有共用代码。如果你要找的是最初的 Deep Research 框架，可以前往 [`1.x` 分支](https://github.com/bytedance/deer-flow/tree/main-1.x)。那里仍然欢迎贡献；当前的主要开发已经转向 2.0。

## 官网

[<img width="2880" height="1600" alt="image" src="https://github.com/user-attachments/assets/a598c49f-3b2f-41ea-a052-05e21349188a" />](https://deerflow.tech)

想了解更多，或者直接看**真实演示**，可以访问[**官网**](https://deerflow.tech)。

## 字节跳动火山引擎方舟 Coding Plan

[<img width="4808" height="2400" alt="codingplan -banner 素材" src="https://github.com/user-attachments/assets/d30dae52-84f2-4021-b32f-6d281252b9ea" />](https://www.volcengine.com/activity/codingplan?utm_campaign=deer_flow&utm_content=deer_flow&utm_medium=devrel&utm_source=OWO&utm_term=deer_flow)

- 我们推荐使用 Doubao-Seed-2.0-Code、DeepSeek v3.2 和 Kimi 2.5 运行 DeerFlow
- [现在就加入 Coding Plan](https://www.volcengine.com/activity/codingplan?utm_campaign=deer_flow&utm_content=deer_flow&utm_medium=devrel&utm_source=OWO&utm_term=deer_flow)
- [海外地区的开发者请点击这里](https://www.byteplus.com/en/activity/codingplan?utm_campaign=deer_flow&utm_content=deer_flow&utm_medium=devrel&utm_source=OWO&utm_term=deer_flow)

## InfoQuest

DeerFlow 已集成字节跳动 BytePlus 自研的智能搜索与爬取工具集 —— [InfoQuest（支持免费在线体验）](https://docs.byteplus.com/en/docs/InfoQuest/What_is_Info_Quest)。

<a href="https://docs.byteplus.com/en/docs/InfoQuest/What_is_Info_Quest" target="_blank">
  <img
    src="https://sf16-sg.tiktokcdn.com/obj/eden-sg/hubseh7bsbps/20251208-160108.png"
    alt="InfoQuest_banner"
  />
</a>

---

## 目录

- [🦌 DeerFlow - 2.0](#-deerflow---20)
  - [官网](#官网)
  - [字节跳动火山引擎方舟 Coding Plan](#字节跳动火山引擎方舟-coding-plan)
  - [InfoQuest](#infoquest)
  - [目录](#目录)
  - [一句话交给 Coding Agent 安装](#一句话交给-coding-agent-安装)
  - [快速开始](#快速开始)
    - [配置](#配置)
    - [运行应用](#运行应用)
      - [部署建议与资源规划](#部署建议与资源规划)
      - [方式一：Docker](#方式一docker)
      - [方式二：本地开发（Gateway / 后端 API）](#方式二本地开发gateway--后端-api)
      - [启动模式对照](#启动模式对照)
    - [进阶配置](#进阶配置)
      - [Sandbox 模式](#sandbox-模式)
      - [MCP Server](#mcp-server)
      - [IM 渠道](#im-渠道)
      - [LangSmith 链路追踪](#langsmith-链路追踪)
      - [Langfuse 链路追踪](#langfuse-链路追踪)
      - [同时使用两种追踪](#同时使用两种追踪)
  - [从 Deep Research 到 Super Agent Harness](#从-deep-research-到-super-agent-harness)
  - [核心特性](#核心特性)
    - [Skills 与 Tools](#skills-与-tools)
      - [Claude Code 集成](#claude-code-集成)
    - [Sub-Agents](#sub-agents)
    - [Sandbox 与文件系统](#sandbox-与文件系统)
    - [Context Engineering](#context-engineering)
    - [长期记忆](#长期记忆)
  - [推荐模型](#推荐模型)
  - [内嵌 Python Client](#内嵌-python-client)
  - [文档](#文档)
  - [⚠️ 安全使用](#️-安全使用)
  - [参与贡献](#参与贡献)
  - [许可证](#许可证)
  - [致谢](#致谢)
  - [Star History](#star-history)

## 一句话交给 Coding Agent 安装

如果你在用 Claude Code、Codex、Cursor、Windsurf 或其他 coding agent，可以直接把下面这句话发给它：

```text
如果还没 clone DeerFlow，就先 clone，然后按照 https://raw.githubusercontent.com/bytedance/deer-flow/main/Install.md 把它的本地开发环境初始化好
```

这条提示词是给 coding agent 用的。它会在需要时先 clone 仓库，优先选择 Docker，完成初始化，并在结束时告诉你下一条启动命令，以及还缺哪些配置需要你补充。

## 快速开始

### 配置

1. **克隆 DeerFlow 仓库**

   ```bash
   git clone https://github.com/bytedance/deer-flow.git
   cd deer-flow
   ```

2. **运行配置向导（推荐）**

   在项目根目录（`deer-flow/`）执行：

   ```bash
   make setup
   ```

   交互式向导会引导你选择 LLM 提供商、可选的网页搜索，以及 sandbox 模式、bash 访问、文件写入等执行与安全偏好。大约 2 分钟会生成精简的 `config.yaml`，并把密钥写入 `.env`。

   随时可运行 `make doctor` 检查配置并获取修复建议。

   > **进阶 / 手动配置**：若希望直接编辑完整模板，可执行 `make config` 从 `config.example.yaml` 复制。完整字段说明见 `config.example.yaml`（含 Codex CLI、Claude Code OAuth、OpenRouter、Responses API、vLLM 等）。

3. **为已配置的模型设置 API key**

   可任选以下一种方式：

   - **方式 A**：编辑项目根目录下的 `.env`（推荐）

     ```bash
     TAVILY_API_KEY=your-tavily-api-key
     OPENAI_API_KEY=your-openai-api-key
     INFOQUEST_API_KEY=your-infoquest-api-key
     ```

   - **方式 B**：在 shell 中导出环境变量

     ```bash
     export OPENAI_API_KEY=your-openai-api-key
     ```

   - **方式 C**：直接写在 `config.yaml` 中（不建议用于生产）

   <details>
   <summary>手动模型配置示例（展开）</summary>

   ```yaml
   models:
     - name: gpt-4o
       display_name: GPT-4o
       use: langchain_openai:ChatOpenAI
       model: gpt-4o
       api_key: $OPENAI_API_KEY

     - name: openrouter-gemini-2.5-flash
       display_name: Gemini 2.5 Flash (OpenRouter)
       use: langchain_openai:ChatOpenAI
       model: google/gemini-2.5-flash-preview
       api_key: $OPENROUTER_API_KEY
       base_url: https://openrouter.ai/api/v1

     - name: gpt-5-responses
       display_name: GPT-5 (Responses API)
       use: langchain_openai:ChatOpenAI
       model: gpt-5
       api_key: $OPENAI_API_KEY
       use_responses_api: true
       output_version: responses/v1

     - name: qwen3-32b-vllm
       display_name: Qwen3 32B (vLLM)
       use: deerflow.models.vllm_provider:VllmChatModel
       model: Qwen/Qwen3-32B
       api_key: $VLLM_API_KEY
       base_url: http://localhost:8000/v1
       supports_thinking: true
       when_thinking_enabled:
         extra_body:
           chat_template_kwargs:
             enable_thinking: true
   ```

   OpenRouter 等 OpenAI 兼容网关请使用 `langchain_openai:ChatOpenAI` + `base_url`。走 OpenAI `/v1/responses` 时设置 `use_responses_api: true` 与 `output_version: responses/v1`。

   vLLM 0.19.0 请使用 `deerflow.models.vllm_provider:VllmChatModel`；Qwen 类推理模型通过 `extra_body.chat_template_kwargs.enable_thinking` 开关推理，并保留 vLLM 非标准 `reasoning` 字段以支持多轮 tool call。

   CLI -backed 提供商示例：

   ```yaml
   models:
     - name: gpt-5.4
       display_name: GPT-5.4 (Codex CLI)
       use: deerflow.models.openai_codex_provider:CodexChatModel
       model: gpt-5.4
       supports_thinking: true

     - name: claude-sonnet-4.6
       display_name: Claude Sonnet 4.6 (Claude Code OAuth)
       use: deerflow.models.claude_provider:ClaudeChatModel
       model: claude-sonnet-4-6
       max_tokens: 4096
       supports_thinking: true
   ```

   - Codex CLI 读取 `~/.codex/auth.json`
   - Claude Code 支持 `CLAUDE_CODE_OAUTH_TOKEN`、`ANTHROPIC_AUTH_TOKEN`、`CLAUDE_CODE_CREDENTIALS_PATH` 或 `~/.claude/.credentials.json`
   - macOS 上如需导出 Claude Code OAuth：`eval "$(python3 scripts/export_claude_code_oauth.py --print-export)"`

   </details>

### 运行应用

> **架构说明**：Agent 运行时嵌入在 **Gateway**（默认 `8001`）中。对外 HTTP 集成请使用 `http://<host>:8001/api`；OpenAPI 文档见 `/docs`。若部署了 Nginx 并将 `/api/langgraph/*` 重写到 Gateway，则对外基址可能是 `http://<host>:2026/api/langgraph`（与直连 Gateway 的 `/api/*` 等价）。

#### 部署建议与资源规划

| 部署场景 | 起步配置 | 推荐配置 | 说明 |
|---------|-----------|------------|-------|
| 本地 Gateway / `backend make dev` | 4 vCPU、8 GB 内存、20 GB SSD | 8 vCPU、16 GB 内存 | 适合单开发者或轻量会话，模型走外部 API。`2 核 / 4 GB` 通常不够。 |
| Docker 开发 / `make docker-start` | 4 vCPU、8 GB 内存、25 GB SSD | 8 vCPU、16 GB 内存 | 镜像构建与 sandbox 容器更吃资源。 |
| 长期运行 / `make up` | 8 vCPU、16 GB 内存、40 GB SSD | 16 vCPU、32 GB 内存 | 适合共享环境、多 agent 任务或更重 sandbox。 |

- 上表仅覆盖 DeerFlow 本身；本机部署大模型请单独预留资源。
- 持续运行服务更推荐 Linux + Docker。
- CPU/内存长期打满时，先降并发，再升配。

#### 方式一：Docker

**开发模式**（热更新、挂载源码）：

```bash
make docker-init    # 拉取 sandbox 镜像（首次或更新时）
make docker-start   # 按 config.yaml 判断 sandbox 模式并启动
```

若 `config.yaml` 使用 provisioner 模式（`sandbox.use: deerflow.community.aio_sandbox:AioSandboxProvider` 且配置了 `provisioner_url`），`make docker-start` 会一并启动 `provisioner`。

**生产模式**：

```bash
make up     # 构建并启动生产容器
make down   # 停止并移除
```

`deploy.sh` 也支持分步构建与启动：

```bash
./scripts/deploy.sh              # 构建 + 启动
./scripts/deploy.sh build        # 仅构建镜像
./scripts/deploy.sh start        # 启动已构建镜像
./scripts/deploy.sh down         # 停止
```

> [!NOTE]
> 本仓库的 `docker-compose*.yaml` 仅包含 **gateway**（及可选 **provisioner**），Gateway 直接映射 `8001`。IM 渠道在 Compose 内跑在 gateway 容器中时，`channels.langgraph_url` / `gateway_url` 勿指向 `localhost`，应使用 `http://gateway:8001/api` 与 `http://gateway:8001`。

更完整的 Docker 说明见 [CONTRIBUTING.md](CONTRIBUTING.md)。

#### 方式二：本地开发（Gateway / 后端 API）

前提：完成上文配置。`config.yaml` 默认在项目根目录；可用 `DEER_FLOW_PROJECT_ROOT`、`DEER_FLOW_CONFIG_PATH` 覆盖。运行期数据默认在 `.deer-flow`（`DEER_FLOW_HOME`）；skills 默认在 `skills/`（`DEER_FLOW_SKILLS_PATH`）。

Windows 请在 **Git Bash** 中操作；`cmd.exe` / PowerShell 不支持根目录 bash 脚本。

1. **安装后端依赖**

   ```bash
   cd backend && uv sync
   ```

2. **（可选）预拉 sandbox 镜像**（项目根目录）

   ```bash
   make setup-sandbox
   ```

3. **（可选）加载示例 memory 数据**（便于本地验证 Memory 功能）

   ```bash
   python scripts/load_memory_sample.py
   ```

   见 [backend/docs/MEMORY_SETTINGS_REVIEW.md](backend/docs/MEMORY_SETTINGS_REVIEW.md)。

4. **启动 Gateway**

   ```bash
   cd backend && make dev
   ```

5. **访问**

   | 用途 | 地址 |
   |------|------|
   | 健康检查 | http://localhost:8001/health |
   | OpenAPI / Swagger | http://localhost:8001/docs |
   | 首次创建管理员 | http://localhost:8001/setup |
   | LangGraph 兼容 API 基址 | http://localhost:8001/api |

> 根目录 `make install` / `make dev` 与 `cd backend && make dev` 等价，均只安装/启动 **Gateway**（`http://localhost:8001`）。Windows 上请用 **Git Bash** 执行根目录 bash 脚本目标。

#### 启动模式对照

| | **本地 Gateway** | **Docker 开发** | **Docker 生产** |
|---|---|---|---|
| **开发** | `cd backend && make dev` | `make docker-start` | — |
| **生产** | `cd backend && make gateway` | — | `make up` / `deploy.sh` |
| **停止** | Ctrl+C 或结束 uvicorn 进程 | `make docker-stop` | `make down` |

Gateway 对外提供 LangGraph 兼容路径；经 Nginx 部署时，公网 `/api/langgraph/*` 会重写为 Gateway 的 `/api/*`。

### 进阶配置

#### Sandbox 模式

DeerFlow 支持多种 sandbox 执行方式：

- **本地执行**（在宿主机上运行，默认不开启宿主机 bash，安全性较弱）
- **Docker 执行**（隔离容器，`AioSandboxProvider`）
- **Docker + Kubernetes**（通过 provisioner 在 Pod 中运行）

Docker 开发时启动行为遵循 `config.yaml` 中的 sandbox 模式；Local / Docker 模式下不会启动 `provisioner`。

详见 [Sandbox 配置指南](backend/docs/CONFIGURATION.md#sandbox)。

#### MCP Server

DeerFlow 支持可配置的 MCP Server 与 skills。HTTP/SSE MCP Server 支持 OAuth（`client_credentials`、`refresh_token`）。

详见 [MCP Server 指南](backend/docs/MCP_SERVER.md)。

#### IM 渠道

DeerFlow 支持从即时通讯应用接收任务；配置完成后自动启动，均无需公网 IP。

| 渠道 | 传输方式 | 上手难度 |
|---------|-----------|------------|
| Telegram | Bot API（long-polling） | 简单 |
| Slack | Socket Mode | 中等 |
| Feishu / Lark | WebSocket | 中等 |
| 微信 | 腾讯 iLink（long-polling） | 中等 |
| 企业微信智能机器人 | WebSocket | 中等 |
| 钉钉 | Stream Push（WebSocket） | 中等 |

**`config.yaml` 配置示例：**

```yaml
channels:
  langgraph_url: http://localhost:8001/api
  gateway_url: http://localhost:8001

  session:
    assistant_id: lead_agent
    config:
      recursion_limit: 100
    context:
      thinking_enabled: true
      is_plan_mode: false
      subagent_enabled: false

  feishu:
    enabled: true
    app_id: $FEISHU_APP_ID
    app_secret: $FEISHU_APP_SECRET

  wecom:
    enabled: true
    bot_id: $WECOM_BOT_ID
    bot_secret: $WECOM_BOT_SECRET

  slack:
    enabled: true
    bot_token: $SLACK_BOT_TOKEN
    app_token: $SLACK_APP_TOKEN
    allowed_users: []

  telegram:
    enabled: true
    bot_token: $TELEGRAM_BOT_TOKEN
    allowed_users: []

  wechat:
    enabled: true
    # bot_token: $WECHAT_BOT_TOKEN
    # qrcode_login_enabled: true   # 首次无 token 时可扫码绑定

  dingtalk:
    enabled: true
    client_id: $DINGTALK_CLIENT_ID
    client_secret: $DINGTALK_CLIENT_SECRET
    allowed_users: []
```

说明：

- `assistant_id: lead_agent` 使用默认 assistant。
- 自定义 agent 名仍会走 `lead_agent`，并注入 `agent_name` 以应用对应 SOUL 与配置。

在 `.env` 中配置各渠道密钥（`TELEGRAM_BOT_TOKEN`、`SLACK_BOT_TOKEN`、`FEISHU_APP_ID`、`WECOM_BOT_ID`、`DINGTALK_CLIENT_ID`、`WECHAT_BOT_TOKEN` 等）。各渠道详细步骤与英文版 README 一致，此处从略；企业微信需 `wecom-aibot-python-sdk`。

**微信补充**：启用 `wechat` 后，可在 `.env` 设置 `WECHAT_BOT_TOKEN`，或 `qrcode_login_enabled: true` 首次扫码；token 会持久化到 `state_dir`，Docker 部署请挂载持久卷以保留登录态。

**命令**

| 命令 | 说明 |
|---------|-------------|
| `/new` | 新对话 |
| `/status` | 当前 thread |
| `/models` | 可用模型 |
| `/memory` | 查看 memory |
| `/help` | 帮助 |

无前缀消息按普通聊天处理。

#### LangSmith 链路追踪

在 `.env` 中配置：

```bash
LANGSMITH_TRACING=true
LANGSMITH_ENDPOINT=https://api.smith.langchain.com
LANGSMITH_API_KEY=lsv2_pt_xxxxxxxxxxxxxxxx
LANGSMITH_PROJECT=xxx
```

#### Langfuse 链路追踪

DeerFlow 同时支持 [Langfuse](https://langfuse.com) 观测 LangChain 兼容运行：

```bash
LANGFUSE_TRACING=true
LANGFUSE_PUBLIC_KEY=pk-lf-xxxxxxxxxxxxxxxx
LANGFUSE_SECRET_KEY=sk-lf-xxxxxxxxxxxxxxxx
LANGFUSE_BASE_URL=https://cloud.langfuse.com
```

自托管实例请将 `LANGFUSE_BASE_URL` 改为你的部署地址。

#### 同时使用两种追踪

若 LangSmith 与 Langfuse 同时启用，会挂载两套 callback，向两侧上报相同模型活动。若某提供商已启用但缺少凭证或 callback 初始化失败，会在创建模型时 **快速失败**，错误信息会标明具体提供商。

Docker 部署默认关闭追踪；在 `.env` 中设置 `LANGSMITH_TRACING=true` 与对应 API key 即可开启。

## 从 Deep Research 到 Super Agent Harness

DeerFlow 最初是 Deep Research 框架；社区把它用于数据流水线、演示文稿、仪表盘、内容自动化等场景，早已超出「只做研究」。

因此我们将其定位为 **harness**——让 agent 真正完成任务的运行时基础设施，并在 2.0 中从头重写：基于 LangGraph / LangChain，自带文件系统、memory、skills、sandbox 与 sub-agent 规划能力，开箱即用也可深度扩展。

## 核心特性

### Skills 与 Tools

Skills 是能力扩展的核心：标准 Skill 为结构化 Markdown 模块。DeerFlow 内置研究、报告、幻灯片、网页、图像/视频等 skills；支持自定义、替换与组合。Skills **按需渐进加载**，避免撑爆上下文。

通过 Gateway 安装 `.skill` 压缩包时，接受 `version`、`author`、`compatibility` 等 frontmatter。

Tools 含网页搜索、抓取、文件操作、bash（视 sandbox 配置）；可通过 MCP 与 Python 扩展。

Gateway 生成后续建议时会归一化纯文本与 block/list 富文本，再解析 JSON，避免不同 provider 包装导致建议丢失。

```text
/mnt/skills/public
├── research/SKILL.md
├── report-generation/SKILL.md
└── ...

/mnt/skills/custom
└── your-custom-skill/SKILL.md
```

#### Claude Code 集成

通过 `claude-to-deerflow` skill 可在 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 中操作运行中的 DeerFlow 实例。

```bash
npx skills add https://github.com/bytedance/deer-flow --skill claude-to-deerflow
```

确认 Gateway 已启动（默认 `http://localhost:8001`），在 Claude Code 中使用 `/claude-to-deerflow`。

**环境变量**（可选）：

```bash
DEERFLOW_GATEWAY_URL=http://localhost:8001
DEERFLOW_LANGGRAPH_URL=http://localhost:8001/api
```

完整说明见 [`skills/public/claude-to-deerflow/SKILL.md`](skills/public/claude-to-deerflow/SKILL.md)。

### Sub-Agents

Lead agent 可动态拉起 sub-agents，各自独立上下文与工具，尽量并行执行后汇总。启用 token 统计时，已完成 sub-agent 的用量会归因到派发步骤。适合数分钟到数小时的多路研究、报告或站点生成任务。

### Sandbox 与文件系统

每个任务在隔离环境中拥有 skills、workspace、uploads、outputs 视图。`AioSandboxProvider` 在容器内执行 shell；`LocalSandboxProvider` 将文件工具映射到每 thread 宿主机目录，**默认禁用宿主机 bash**（非安全边界），仅可信本地环境可重新开启。

```text
/mnt/user-data/
├── uploads/
├── workspace/
└── outputs/
```

### Context Engineering

- **Sub-Agent 上下文隔离**：sub-agent 不见主 agent 及其他 sub-agent 上下文。
- **摘要压缩**：总结已完成子任务，中间结果落盘，压缩非即时信息。
- **Tool-Call 恢复**：工具调用环被打断时，剥离异常 metadata 并为悬空 tool call 注入占位结果，避免 OpenAI 兼容模型因 `tool_call_id` 序列错误而失败。

### 长期记忆

跨 session 积累偏好与事实；memory 存于本地。更新时会跳过重复 fact，避免偏好无限堆积。

## 推荐模型

兼容 OpenAI API 的模型均可接入。更推荐具备以下能力的模型：

- 长上下文（100k+ tokens）
- 强推理与规划
- 多模态输入
- 稳定的 tool use

## 内嵌 Python Client

无需启动 HTTP 服务时，可使用 `DeerFlowClient` 进程内调用，返回结构与 Gateway API 一致。HTTP Gateway 还提供 `DELETE /api/threads/{thread_id}`，在删除 LangGraph thread 后清理本地 thread 数据。

```python
from deerflow.client import DeerFlowClient

client = DeerFlowClient()
response = client.chat("分析这篇论文", thread_id="my-thread")

for event in client.stream("你好"):
    if event.type == "messages-tuple" and event.data.get("type") == "ai":
        print(event.data["content"])

models = client.list_models()
skills = client.list_skills()
client.update_skill("web-search", enabled=True)
client.upload_files("thread-1", ["./report.pdf"])
```

dict 返回值在 CI 中与 Gateway Pydantic 模型对齐（`TestGatewayConformance`）。详见 `backend/packages/harness/deerflow/client.py`。

## 文档

- [贡献指南](CONTRIBUTING.md)
- [配置指南](backend/docs/CONFIGURATION.md)
- [API 参考](backend/docs/API.md)
- [架构概览](backend/CLAUDE.md)
- [后端说明](backend/README.md)

## ⚠️ 安全使用

DeerFlow 具备系统命令执行、资源操作等高权限能力，**默认面向本机可信环境（127.0.0.1）**。暴露到公网或多终端可达网络且未加固时，存在未授权调用、合规与法律风险。

**建议**：本地可信网络部署；跨网访问时使用 IP 白名单、反向代理强认证、VLAN 隔离，并关注安全更新。

对外提供 API 时，请自行实现服务间鉴权（API Key / JWT 等）；内置 Cookie + CSRF 主要面向浏览器与会话场景。

## 参与贡献

欢迎贡献，见 [CONTRIBUTING.md](CONTRIBUTING.md)。

回归测试覆盖 Docker sandbox 模式识别、provisioner kubeconfig 路径等。Gateway 对 `text/html`、`image/svg+xml` 等活跃 Web 内容类型强制以附件下载，降低生成产物的 XSS 风险。

## 许可证

[MIT License](./LICENSE)

## 致谢

感谢开源社区，尤其 [LangChain](https://github.com/langchain-ai/langchain) 与 [LangGraph](https://github.com/langchain-ai/langgraph)。

### 核心贡献者

- **[Daniel Walnut](https://github.com/hetaoBackend/)**
- **[Henry Li](https://github.com/magiccube/)**

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=bytedance/deer-flow&type=Date)](https://star-history.com/#bytedance/deer-flow&Date)
