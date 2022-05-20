## main
  * yes_confirmed? のオプション(fail_on_error)のバグを修正([PR#22](https://github.com/maedadev/bizside-ruby/pull/22))
    * 定義済の変数を参照するように修正
  * StringUtils.create_random_alpha_string の生成する文字の上限を廃止([PR#21](https://github.com/maedadev/bizside-ruby/pull/21))
    * 半角英小文字のみの場合は26文字、半角英大文字・小文字の場合は52文字を超える文字を生成出来るように修正
  * 依存ライブラリのバージョン更新([PR#20](https://github.com/maedadev/bizside-ruby/pull/20))
    * development_dependency
      * cucumber-rails
        * 2.x を使う
        * cucumber のバージョンに合わせる

## 2.0.8
  * 依存ライブラリのバージョン更新([PR#18](https://github.com/maedadev/bizside-ruby/pull/18))
    * runtime_dependency
      * rake
        * 13.x を許可
    * development_dependency
      * sqlite3
        * 1.4.x を許可
      * capybara
        * 3.35.x を許可
      * cucumber
        * 7.x を使う
  * CI アップデート([PR#17](https://github.com/maedadev/bizside-ruby/pull/17))
  * リファクタリング([PR#19](https://github.com/maedadev/bizside-ruby/pull/1))

## 2.0.7
  * job_audit.log 出力に server_address を追加

## 2.0.6
  * JobUtils#enqueue_at_with_queue を追加
  * JobUtils#enqueue_at_with_queue_silently を追加
  * JobUtils#remove_delayed_in_queue を追加

## 2.0.5
  * Carrierwaveでアップロード時にファイル名の長さチェックができるように拡張（PR#13）

    長い（Linuxの場合255バイトより長い）ファイル名の場合、ファイルをキャッシュするタイミングで Errno::ENAMETOOLONG が発生していました。
    Bizside::FileUploader の挙動を設定で制御できるようになりました。

    * Bizside.config.file_uploader.ignore_long_filename_error が true の場合
      Errno::ENAMETOOLONG の発生を抑制します。
      モデルに original_filename というプロパティがある場合は、当該プロパティにファイル名を設定します。
      以下のようなモデルのバリデーションを定義することで、エラーを通知することが可能です。

      ```
      # 4バイト文字が Linux 上の 255バイト制限に収まる長さ
      validates :original_filename, length: {maximum: 255 / 4}
      ```

    * Bizside.config.file_uploader.ignore_long_filename_error が false の場合
      これまでどおり Errno::ENAMETOOLONG が発生します。

    デフォルトでは ignore_long_filename_error は false で、互換性を維持しています。
    アプリ側でファイル名の適切なバリデーションを行う場合は ignore_long_filename_error を true にしてください。
    いずれの場合もファイルのキャッシュは実施されていないため、正常系の処理を続けることはできません。

  * Bizside::Config にメソッド呼び出し形式で値を設定できない不具合の修正(#57892)

## 2.0.4
  * Bizside::FileConverter による rmagick のロードは必要になったタイミングで require するように

## 2.0.3
  * ENV[COVERAGE]の値に関わらずカバレージ計測をしてしまう不具合の修正(#57337)

## 2.0.2
  * Bizside::FileUploader#downloaded_file が返すパスにファイルが存在しない場合にハンドリングする(#57053)

## 2.0.1
  * bizside/file_uploader のバグフィックス

## 2.0.0
  * OSSとして公開(https://github.com/maedadev/bizside-ruby)
