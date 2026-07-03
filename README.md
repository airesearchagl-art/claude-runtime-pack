# Claude Runtime Pack

Claude Codeの作業時トークン消費を抑えるための、個人用Runtime Packです。

このリポジトリは、Obsidian Vaultや個別開発リポジトリとは切り分けて管理します。目的は、上位モデルを常時実行者にせず、計画・判断・レビューに集中させ、探索・一覧化・抽出・単純チェックを低コストExecutor / subagent / 機械チェックへ委任することです。

## 基本方針

- 上位モデルは Orchestrator として使う。
- Executor / subagent は読み取り・抽出・一覧化・下書きに使う。
- 5ファイル以上の確認、frontmatter抽出、リンク候補整理、PR差分の単純要約は、原則としてsubagentまたは機械チェックへ逃がす。
- subagent出力は候補扱いにし、最終判断は上位モデルが行う。
- 上位モデル名は固定しない。Fable 5 / Opus / Sonnet高性能設定など、その時点で使える高性能モデルをOrchestratorとして扱う。
- Fable 5を使う場合も、実装・探索・一覧化まで抱え込ませない。

## 想定構成

```text
claude-runtime-pack/
  CLAUDE.md
  agents/
    vault-scout.md
    vault-auditor.md
    vault-pr-summarizer.md
  rules/
    orchestrator-executor.md
    token-economy.md
  bootstrap/
    cloud-session-bootstrap.md
    project-bootstrap-CLAUDE.md
  scripts/
    install.ps1
    install.sh
```

## ローカルPCでの使い方

### Windows

```powershell
git clone https://github.com/airesearchagl-art/claude-runtime-pack.git
cd claude-runtime-pack
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

インストール先:

```text
%USERPROFILE%\.claude\
```

同じPC上では、Claude Code CLIとClaude Desktop Codeタブの両方からこの設定を参照する想定です。

### macOS / Linux

```bash
git clone https://github.com/airesearchagl-art/claude-runtime-pack.git
cd claude-runtime-pack
bash ./scripts/install.sh
```

インストール先:

```text
~/.claude/
```

## Cloud session / Web / iPhoneでの考え方

このRuntime PackをGitHubに置くだけでは、Claude Code Cloud sessionが自動で読みに行くとは限りません。

Cloud sessionで使う場合は、次のいずれかが必要です。

1. 作業対象リポジトリ側に最小bootstrapを置く。
2. setup script等でこのRuntime Packを取得して配置する。
3. 作業開始プロンプトにRuntime Packの要点を渡す。
4. iPhoneからはRemote ControlでメインPC上のClaude Code sessionを操作する。

詳細は `bootstrap/cloud-session-bootstrap.md` を参照してください。

## 注意

- このリポジトリにはAPIキー・トークン・個人情報・秘密情報を入れない。
- `agents/` は読み取り専用・判断禁止を基本とする。
- 個別プロジェクト固有のルールは、このRuntime Packではなく各リポジトリ側に置く。
- Obsidian Vault本文にClaude Code実行時制約を書き込む用途では使わない。

## 次にやること

1. まずローカルPCにインストールする。
2. Claude Codeで `/agents` または設定ファイルを確認する。
3. obsidian-vault等の作業前に、上位モデルが作業開始前計画を出すか確認する。
4. cloud session対応は `bootstrap/` を元に、別PRで検討する。
