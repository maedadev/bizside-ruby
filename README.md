bizside.gem
===

bizside.gemは環境構築のための各種Rakeタスク（セットアップスクリプト）群やBizsideのシステム基盤機能を提供するgemです。

---

bizside.gem を更新する際には、下記を更新する必要があります。

* 対象ファイルの修正
* lib/bizside/version.rb のバージョンを更新
* 「bundle install」の実行(Gemfile.lockの更新)
* 「bundle exec rake test」の実行(bizside_test_app/Gemfile.lockの更新)
* HISTORY.mdに変更点を記載
* 更新バージョンのGitTag作成
