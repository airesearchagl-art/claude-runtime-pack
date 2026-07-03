# Cloud Session Bootstrap メモ

## 目的

このメモは、Claude CodeのCloud sessionやWebベースのセッションでこのRuntime Packを再利用する方法を整理したものです。

## 重要な制約

このRuntime Packを別のGitHubリポジトリに置くだけでは、すべてのCloud sessionが自動的にそれを読みに行くとは限りません。

Cloud sessionは通常、作業対象リポジトリのcontextを読みます。`~/.claude/CLAUDE.md` のようなローカルのユーザーレベルファイルは、まっさらなCloud環境では自動的に利用できるとは限りません。

## 候補となる方針

### Option A: 最小限のproject bootstrap

Runtime Pack全体ではなく、作業対象リポジトリに小さなproject-level Claudeファイルを追加する。

推奨内容は以下にあります。

```text
bootstrap/project-bootstrap-CLAUDE.md
```

プロジェクトがRuntime Packの原則には従うべきだが、Pack全体をvendorする必要はない場合に使う。

### Option B: setup scriptでRuntime Packを取得する

setup scriptに対応したCloud環境であれば、project側のsetup stepでこのリポジトリをcloneし、必要なファイルをコピーまたはimportすることが考えられる。これはまだ end-to-end で検証できていないため、確立した手順としてではなく、今後試すべき候補として扱う。

このリポジトリの `scripts/install.ps1` は、ローカルWindows PC上で `CLAUDE.md` / `agents/` / `rules/` / `bootstrap/` をコピーするものであり、Cloud側のsetup stepの参考として応用できる可能性はあるが、現時点ではローカルでのみ検証済み（詳細は `docs/windows-local-setup.md` を参照）。

注意点:

- リポジトリに秘密鍵やアクセストークンを置かない。
- bootstrapは最小限に保つ。
- 依存する前に、Cloud sessionがコピーしたファイルを実際に読んでいるか確認する。

### Option C: 作業開始プロンプトにRuntime Packの要点を含める

setup scriptが使えない場合は、最初の指示に短い作業開始ルールを貼り付ける。

```text
上位モデル（active high-capability model）はOrchestratorとしてのみ使う。広範に読み込まない。探索・一覧化・抽出・frontmatter確認・diff要約はsubagentまたは機械チェックへ委任する。直接読んだファイル・委任したファイル・機械チェックの内容・スキップした範囲・最終判断を報告する。
```

### Option D: Remote Control

スマートフォンやタブレットを使う場合、Remote ControlはメインPC上で動いているClaude Code sessionを操作できる。その場合、作業が実際にはそのPC上で実行されるため、メインPCのローカル `~/.claude/` の設定が使える可能性がある — これは期待される挙動ではあるが、このRuntime Packに関しては未検証。これは、スマートフォン自体のチャットアプリ（ローカルのClaude Code sessionをそもそも実行していない）とは異なる状況である。

## 今後の課題

- ローカルWindows向けの安全なsetup script（`scripts/install.ps1`）は用意できた。Cloud/CI向けの同等の仕組みはまだ未着手。
- 各プロジェクトにbootstrapファイルだけを含めるか、project固有の `.claude/` フォルダを含めるかを決める。
- Runtime Packの更新はこのリポジトリに集約し続ける。
