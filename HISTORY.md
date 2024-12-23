## master
  * resque-scheduler でジョブ登録に失敗したときにログ出力が行えるように

## 3.0.4
  トップレベルにモジュール Coverage を定義して Ruby 標準クラス Coverage とバッティングしていたのを修正

## 3.0.3
  * 監査ログ項目 remote_address に使用する x-forwarded-for / client-ip の値からプロキシーサーバを除外する設定 Bizside::AuditLog.trusted_proxy_cidrs を追加

## 3.0.2
  * 監査ログ項目 remote_address は x-forwarded-for / client-ip の値も参照し、アクセス元のクライアントIPを記録するように変更

## 3.0.1
  * Ruby 2.6 のサポート復活
  * Bizside::Acl::ControllerHelper
    * authorize_user! で x-requested-with ヘッダに "XMLHttpRequest" という文字列（大文字小文字区別なし）が含まれていた場合 root_path にリダイレクトではなく 403 を返却

## 3.0.0
  * Ruby 2.5 のサポート廃止
  * CarrierWave v3 のサポート
    ファイルの保存処理が after_commit から after_save になります。
    https://github.com/carrierwaveuploader/carrierwave/blob/master/CHANGELOG.md
    ```
    [BREAKING CHANGE] Change to store files on after_save hook instead of after_commit, with performing cleanup when transaction is rolled back (@fsateler #2546)
    ```
    CarrierWave v2 では after_commit でファイルを保存していたので、ActiveRecordが保存されてもその後のファイル保存中にネットワークエラーなどがあるとファイルは存在しない、といったことが発生してました。
    CarrierWave v3 では after_save でファイルを保存するので、ファイルの保存でエラーになると、ActiveRecordの保存もロールバックされます。
    
    参考：
      * v3 で after_save に戻した: https://github.com/carrierwaveuploader/carrierwave/pull/2546
      * v2 の時に after_commit になった: https://github.com/carrierwaveuploader/carrierwave/pull/2209

--------------------------------------------------------------------------------


## 2.3.9（3.0.3をバックポート）
  * 監査ログ項目 remote_address に使用する x-forwarded-for / client-ip の値からプロキシーサーバを除外する設定 Bizside::AuditLog.trusted_proxy_cidrs を追加

## 2.3.8（3.0.2をバックポート）
  * 監査ログ項目 remote_address は x-forwarded-for / client-ip の値も参照し、アクセス元のクライアントIPを記録するように変更

## 2.3.7
* Bizside::CronValidator 
  * バリデーションを強化
* Bizside::JobUtils
  * add_cron_to と add_cron で cron を設定する際 blocking: true オプションを自動で付与

## 2.3.6
* Bizside::LogAnalyzer を削除

## 2.3.5
* Minitest を利用している箇所において MiniTest => Minitest にモジュール名を変更

## 2.3.4
* Bizside::FileConverter
  * RMagick 5系に対応

## 2.3.3
* Bizside::FileUploader
  * 以下の全角記号をファイル名に使用することを許可
    ```
    『
    』
    ：
    ```

## 2.3.2
* Bizside::JobUtils
  * `delayed?` の `except` オプションの不具合修正

## 2.3.1
* Bizside::JobUtils
  * ジョブが遅延しているか判定する `delayed?` を追加

## 2.3.0
> [!Warning]
> **!! BREAKING CHANGE !!**
  * クライアントのデバイスによる View ファイルの切替において、Rails 標準の拡張子を使うように変更
    * デバイスにより View ファイル を切り替えている場合は、ファイル名を BizSide 独自形式から Rails 標準の形式に変更してください
      * BizSide 独自形式の例: `show.pc.html.erb`
      * Rails 標準の形式の例: `show.html+pc.erb`
  * config/bizside.yml の user_agent が enabled: true の場合、常に request.variant へのセットを行うように変更
    * これまでは use_variant: true の場合のみセットしていました
    * use_variant は廃止になりました。config/bizside.yml にある場合は削除してください

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
