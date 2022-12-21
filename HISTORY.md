## 2.2.3
  * Bizside::AuditLog

    * スレッドセーフな実装に修正

## 2.2.2
  * mimemagic のバージョン制限を緩く（~> 0.3.10 から ~> 0.3 に変更）

## 2.2.1
  * Validator 関連
 
    * Rails 6.1 の ActiveModel::Error の変更に対応

## 2.2.0
  * Rails 6.x をサポート

## 2.1.12
  * Bizside::JobUtils

     * テスト時の Resque との挙動の差異が残っていたため修正
       * ジョブの引数にバイナリが指定できない、数値キーが文字列でなく数値のままだった等

## 2.1.11
  * Bizside::JobUtils

    * 遅延ジョブの情報取得メソッドを追加。

## 2.1.10
  * bizside/carrierwave

    * fog_public=false の時 CarrierWave+Fog でACLで private を指定する代わりにACL未指定でアップロードするパッチを適用
      * S3でのACLは無効化が推奨されており、ACLが無効化された別アカウント上のバケットに対しては、
        ACLをprivateに指定してファイルアップロードしてもエラーとなる。
      * ACL未指定時はエラーとならず、その場合 private が適用される。

## 2.1.9
  * Bizside::JobUtils

    * RAILS_ENV=test 時の挙動を本来の Resque の挙動となるべく揃えるように修正
      * Resque がサポートしている hook として before_enqueue 以外の hook も実行
        https://github.com/resque/resque/blob/master/docs/HOOKS.md#job-hooks
        * NOTE: `HOOKNAME_IDENTIFIER` の形式は未対応のまま
      * before_enqueue の戻り値の false と nil を区別
      * キューに登録された際の引数の Hash のキーを String に変換

## 2.1.8
  * Bizside::AuditLog

    監査ログに出力する際の文字数の制限を、例外メッセージにも反映([PR#39](https://github.com/maedadev/bizside-ruby/pull/41))

## 2.1.7
  * Bizside::AuditLog

    バックトレースを監査ログに出力する際に、文字数の制限を追加([PR#39](https://github.com/maedadev/bizside-ruby/pull/40))
    デフォルトでは 8192 文字分の出力に制限されます。
    Bizside::AuditLog.truncate_length の値を変更することで調整が可能です。

## 2.1.6
  * bizside/resque
    * resque の設定値として String だけでなく Hash にも対応
    * resque.yml/redis.yml は YAML.load でなく YAML.safe_load でロードするように修正

## 2.1.5
  * email_validator を廃止

    長らく https://github.com/K-and-R/email_validator のラッパーとして存在していました。
    直接上記Gemを利用して適切なオプションを利用してください。

## 2.1.4
  * Bizside::CarrierwaveStringIO#path で実在するファイルを参照しないよう、必ず存在しないパスを返すように変更
    * CarrierWave::Uploader::Base#store! で意図しないファイルが保存対象となるのを防ぐため

## 2.1.3
  * BIZSIDE_SUPPRESS_AUDIT変数を設定できない場合(Engine等)でもAuditLogを抑制可能とする([PR#36](https://github.com/maedadev/bizside-ruby/pull/36))
    * AuditLogを抑制したいURIパスをBizside::AuditLog.ignored_pathsに指定する

## 2.1.2
  * require 'bizside' で Bizside::StdoutLogger をロードするように修正([PR#33](https://github.com/maedadev/bizside-ruby/pull/33))

## 2.1.1
  * Railsのログを log/[Rails.env].log に加え、標準出力にも出力するためのミドルウェア Bizside::StdoutLogger を追加([PR#31](https://github.com/maedadev/bizside-ruby/pull/31))

## 2.1.0
  * 依存ライブラリのバージョン更新
    * faraday 1.x.xまで許可(#62048)

## 2.0.9
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

    バージョン 1系では Railsアプリ以外で bizside.gem を使用する時は config/bizside.yml は任意でした。
    バージョン 2系以降では常に config/bizside.yml が必須になります。
