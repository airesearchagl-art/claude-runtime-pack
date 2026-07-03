# Claude Runtime Pack

Claude Codeの作業時トークン消費を抑えるための、個人用Runtime Packです。

このリポジトリは、Obsidian Vaultや個別開発リポジトリとは切り分けて管理します。目的は、上位モデルを常時実行者にせず、計画・判断・レビューに集中させ、探索・一覧化・抽出・単純チェックを低コストExecutor / subagent / 機械チェックへ委任することです。

## 基本方針

- 上位モデルは **Orchestrator**（計画・判断・レビューを担う役割）として使う。
- **Executor** / subagent（低コストな実行役）は読み取り・抽出・一覧化・下書きに使う。
- 5ファイル以上の確認、frontmatter抽出、リンク候補整理、PR差分の単純要約は、原則としてsubagentまたは機械チェックへ逃がす。
- subagent出力は候補扱いにし、最終判断は上位モデルが行う。
- 上位モデル名は固定しない。Fable 5 / Opus / Sonnet高性能設定など、その時点で使える高性能モデルをOrchestratorとして扱う。
- Fable 5を使う場合も、実装・探索・一覧化まで抱え込ませない。

## 現在の構成

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
  docs/
    windows-local-setup.md
  scripts/
    install.ps1
```

## まず何をすればよいか

1. このリポジトリをWindows PCにcloneする。
2. `docs/windows-local-setup.md` を読み、手動コピーまたは `scripts/install.ps1 -DryRun` でプレビューする。
3. 内容に問題がなければ `scripts/install.ps1` を実行するか、手動で `%USERPROFILE%\.claude\` にコピーする。
4. Claude Code CLIで `/agents` 等を確認し、`vault-scout` / `vault-auditor` / `vault-pr-summarizer` が読み込まれているか確認する。
5. 実際の作業（例: obsidian-vault repo）で、上位モデルが作業開始前計画を出し、委任ルールに従って動くか確認する。

## ローカルPCでの使い方

### Windows

```powershell
git clone https://github.com/airesearchagl-art/claude-runtime-pack.git
cd claude-runtime-pack
```

配置方法は2通りあります。詳細は `docs/windows-local-setup.md` を参照してください。

- **手動コピー（推奨・まずはこちら）**: `CLAUDE.md` / `agents\` / `rules\` / `bootstrap\` を `%USERPROFILE%\.claude\` に自分でコピーする。挙動を理解しながら進めたい場合や、初回確認時におすすめです。
- **`scripts/install.ps1`（任意）**: 上記と同じ4項目だけを、バックアップ付きでコピーする補助スクリプト。まず `-DryRun` で内容を確認してから実行してください。`settings.json` 等の既存設定には一切触れません。

同じPC上では、Claude Code CLIとClaude Desktop Codeタブの両方からこの設定を参照する想定です。

### 別PC

別PCでもこのリポジトリをcloneし、そのPCの `~/.claude/` または `%USERPROFILE%\.claude\` に同じファイルを配置します。

## Cloud session / Web / iPhoneでの考え方

このRuntime PackをGitHubに置くだけでは、Claude Code Cloud sessionが自動で読みに行くとは限りません。

Cloud sessionで使う場合、現時点で候補になりうるのは次のような方針です（いずれも未検証のため断定はしません）。

1. 作業対象リポジトリ側に最小bootstrapを置く。
2. setup script等でこのRuntime Packを取得できる可能性を検討する。
3. 作業開始プロンプトにRuntime Packの要点を渡す。
4. iPhoneからはRemote Controlを使うと、メインPC上のClaude Code sessionの設定が使える可能性がある。

実際にどう動くかは今後の検証対象です。詳細は `bootstrap/cloud-session-bootstrap.md` を参照してください。

## 注意

- このリポジトリに秘密情報や個人情報を入れない。
- `agents/` は読み取り専用・判断禁止を基本とする。
- 個別プロジェクト固有のルールは、このRuntime Packではなく各リポジトリ側に置く。
- Obsidian Vault本文にClaude Code実行時制約を書き込む用途では使わない。
- Cloud session連携は今後の検証対象。現時点ではローカル同期＋bootstrap方針のたたき台です。

## 次にやること

1. このPR/変更のレビュー・merge後、メインWindows PCに手動または `scripts/install.ps1` で配置し、挙動確認する（本PR作成時点ではまだ実配置していません）。
2. Claude Codeで `/agents` または設定ファイルを確認する。
3. obsidian-vault等の作業前に、上位モデルが作業開始前計画を出すか確認する。
4. cloud session対応は `bootstrap/` を元に、別PRで検証する。
5. macOS/Linux向け `scripts/install.sh` は、Windows版の運用が安定してから後続候補として検討する。
