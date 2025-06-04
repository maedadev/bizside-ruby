## 3.1.1
  * ジョブ監査ログに開始時刻と終了時刻を追加

## 3.1.0
  * Ruby-2.6 のサポート廃止
  * 監査ログに実行環境を識別するための項目 env を追加

## 3.0.8
  * Added support for Psych 4

## 3.0.7
  * 監査ログ関連で状態管理が発生するような機能追加に備えてスレッドセーフティを事前に強化
  * ffi のバージョンを 1.17.0 以下に固定

## 3.0.6
  * BIZSIDE_ENV: education の考慮を追加
    educationの場合、RAILS_ENVはproductionとする。

## 3.0.5
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
