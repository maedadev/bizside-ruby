# Development for bizside.gem

## Steps to create New Version

* lib/bizside/version.rb のバージョンを更新
* `bundle install` を実行し、Gemfile.lock を更新する
* `bundle exec rake test` を実行し、bizside_test_app/Gemfile.lock を更新する
* HISTORY.md に変更点を記載
* 更新バージョンのGitTagを作成
