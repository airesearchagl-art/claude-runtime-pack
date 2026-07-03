# Windows ローカルセットアップ

## 目的

このRuntime PackをWindows PC上のユーザーレベルClaude Code設定フォルダにインストールする。

## 配置先

```text
%USERPROFILE%\.claude\
```

## 手動セットアップ

1. このリポジトリをcloneする。
2. リポジトリのフォルダを開く。
3. 以下を `%USERPROFILE%\.claude\` にコピーする。

```text
CLAUDE.md
agents\
rules\
bootstrap\
```

コピー後、配置先は以下のようになる。

```text
%USERPROFILE%\.claude\
  CLAUDE.md
  agents\
    vault-scout.md
    vault-auditor.md
    vault-pr-summarizer.md
  rules\
    orchestrator-executor.md
    token-economy.md
  bootstrap\
    cloud-session-bootstrap.md
    project-bootstrap-CLAUDE.md
```

## 自動セットアップ（任意）: scripts/install.ps1

`scripts\install.ps1` は、上記と同じ4項目（`CLAUDE.md` / `agents\` / `rules\` / `bootstrap\`）を `%USERPROFILE%\.claude\` にコピーする。`settings.json` / `settings.local.json` / 認証情報 / 環境変数 / GitHub認証には一切触れず、何かを削除することもない。

安全のための挙動:

- コピー先にすでに項目が存在する場合は、上書きする前にタイムスタンプ付きバックアップ（例: `CLAUDE.md.backup.20260703-115208`）を作成する。
- 削除は行わない。新しい内容の横にバックアップが追加されるだけ。
- コピー先フォルダのパスが `.claude` で終わっていない場合、スクリプトは実行を拒否する。

まず必ずプレビューする。

```powershell
cd claude-runtime-pack
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -DryRun
```

これにより、source root・target root・作成/バックアップ/上書きされる予定の項目がすべて表示されるが、ディスク上の内容は一切変更されない。このスクリプトはPowerShell標準の `ShouldProcess` にも対応しているため、`-WhatIf` でも同様に動作する。

プレビュー内容に問題がなければ、実際に実行する。

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

任意のパラメータ:

```powershell
# デフォルト以外の場所にインストールする（例: 実際のプロファイルに触る前に
# 一時フォルダでテストする場合）
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -TargetRoot "D:\test\.claude" -DryRun

# カレントフォルダ以外の場所にcloneしたリポジトリからインストールする
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1 -SourceRoot "C:\path\to\claude-runtime-pack"
```

実行ポリシーにより `powershell -File` がブロックされる場合でも、`-ExecutionPolicy Bypass` はそのプロセス1回にのみ適用され、システム全体のポリシーは変更されない。

上記の手動手順は、特にそのPCで初めてセットアップする際の、最初の一歩として引き続き推奨する。何がどこに置かれるかを最も分かりやすく確認できるためである。

## CLIとDesktop

同じWindows PC上では、Claude Code CLIとClaude Desktop Codeタブの両方が、同じユーザーレベル設定フォルダを参照する想定である。

## 複数PC間の同期

別のPCでも同様にこのリポジトリをcloneし、そのPCの `%USERPROFILE%\.claude\` フォルダに同じファイルを（手動、または `scripts\install.ps1` で）配置する。

このリポジトリにAPIキーや秘密のtokenを保存しないこと。
