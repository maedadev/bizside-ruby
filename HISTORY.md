## 2.0.5（未リリース）
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

## 2.0.4
  * Bizside::FileConverter による rmagick のロードは必要になったタイミングで require するように

## 2.0.3
  * ENV[COVERAGE]の値に関わらずカバレージ計測をしてしまう不具合の修正(#57337)

## 2.0.2
  * Bizside::FileUploader#downloaded_file が返すパスにファイルが存在しない場合にハンドリングする(#57053)

## 2.0.1
  * bizside/file_uploader のバグフィックス
  * OSSとして公開(https://github.com/maedadev/bizside-ruby)

## 1.5.8
  * リファクタリング（#56459）
  * Rails に依存しないクラスの読み込みを lib/bizside/railtie.rb から lib/bizside.rb に移動 （#56732）
  * Gemfile.lock はリポジトリから除外 （#56809）
  * Bizside.gem内のクラス、モジュールについて、トップレベルに定義するかどうかを制御する設定値を追加(#56716)
    Bizside.config.within_bizside_namespace が true の場合はトップレベルに定義しない

## 1.5.7
  * bizside.gemのRails依存部分について、Railsを使用していない場合もエラーにならないように修正 (#56456)

## 1.5.6
  * Bizside::Api::Client クラスを削除し、bizside_client.gem への依存を解消（#56458）

    Bizside::Api::Client クラスは bizside_client に移植されました。
    引き続き利用する場合は bizside_client.gem(>= 0.5.16) をインストールして下さい。

## 1.5.5
  * Bizside::Uploader::ExtensionWhitelist から許可する拡張子のリストを動的に取得する機能を削除 (#56457)

    config/bizside.yml で以下の設定値を両方trueに設定しているアプリケーションに対して影響があります。

    * file_uploader.extension_whitelist_enabled
    * file_uploader.api_enabled

    許可する拡張子のリストを動的に取得する機能は bizside_best_practices に移植されました。
    引き続き1.5.4以前の機能を利用するには bizside_best_practices(>= 1.4.32) をインストールした上で、
    Bizside::FileUploader を継承しているアップローダクラスにて
    BizsideBestPractices::Uploader::ExtensionWhitelist をインクルードしてください。

## 1.5.4
  * devise.gem を利用する bizside_authenticatable 機能を削除（#56455）

    config/bizside.yml で devise.bizside_authenticatable: true と指定しているアプリケーションに影響があります。

    この機能は devise_bizside_authenticatable.gem として切り出されました。
    引き続きこの機能を利用するには devise_bizside_authenticatable をインストールしてください。

## 1.5.3
  * IntelliJ IDEA/RubyMine の仕様変更に対応  
    参考: https://blog.jetbrains.com/ruby/2021/04/improved-minitest-support-action-required/

## 1.5.2
  * JobUtils#failure_jobs を追加
  * JobUtils#failure_count を追加
  * JobUtils#queue_size を修正

## 1.5.0
  * Resque v2 系を解禁
  * 監査ログの require_uri を出力する際、BIZSIDE_REQUEST_URIを優先する（#55760）

## 1.4.5
  * rake bs:test で利用するCucumber関係のコードを bizside_tools.gem に移行

    bizside_tools.gem の v0.4.9 以降を使用し、 features/support/env.rb の記述を以下のように変更してください。

    * 1.4.4 以前
      ```
      require 'bizside/cucumber'
      ```
    * 1.4.5 以降
      ```
      require 'bizside_tools/cucumber'
      ```

## 1.4.4
  * Nginxの場合に、監査ログに server_address が出力されていなかったのを修正

    Nginxの場合は環境変数 HOSTNAME の値を出力します。
    これにより、K8SでPODがスケールしていても、どのPODの出力したログなのかが分かります。

## 1.4.1
  * bizside/formatter/custom_formatter
    フィーチャのHTML出力が時折すべて表示されない場合があったのを修正

## 1.4.0
  * capistrano 関係のソースを削除

    bizside_tools.gem の v0.3.26 以降を使用し、 config/deploy.rb の記述を以下のように変更してください。

    * EC2インスタンスの場合
      ```
      require 'bizside_tools/capistrano'
      ```
    * K8Sの場合
      ```
      require 'bizside_tools/capistrano/k8s'
      ```

## 1.3.7
  * capistrano 関係のソースを bizside_tools.gem に移行予定のため、Deprecatedログを出力するように修正

## 1.3.6
  * bizside/file_archiver を bizside_tools.gem に移動

## 1.3.5
  * Ruby-2.3 のサポートを廃止
  * Rails3, Rails4 のサポートを廃止
  * carrierwave 2系を対象に、1系のサポートを廃止
    * メソッド名 extension_whitelist を extension_allowlist に変更してください。
      ```
      #(content_type|extension)_whitelist, #(content_type|extension)_blacklist are deprecated.
      Use #(content_type|extension)_allowlist and #(content_type|extension)_denylist instead (@grantbdev #2442, 4c3cac75)
      ```
      carrierwave としては deprecated 扱いですが、bizside.gem では extension_allowlist がオーバーライドされることを期待しています。

    * ファイル保存のタイミングが after_save から after_commit に変更されています。

      トランザクションをコミットせずにロールバックを行う単体テストの場合、ファイルの保存を確認できなくなります。
      トランザクションのコミットを行うフィーチャテストでテストケースを作成するなど、対応が必要になるかもしれません。

  * devise 4系をサポート対象に

## 1.2.18（1.5.4をバックポート）
  * devise 関係のコードを devise_bizside_authenticatable.gem に移行（#56455）

## 1.2.17（1.5.3をバックポート）
  * IntelliJ IDEA/RubyMine の仕様変更に対応  
    参考: https://blog.jetbrains.com/ruby/2021/04/improved-minitest-support-action-required/

## 1.2.16（1.5.2をバックポート）
  * JobUtils#failure_jobs を追加
  * JobUtils#failure_count を追加
  * JobUtils#queue_size を修正

## 1.2.14（1.4.1をバックポート）
  * bizside/formatter/custom_formatter

    フィーチャのHTML出力が時折すべて表示されない場合があったのを修正

## 1.2.13
  * bizside:k8s:watch_migration_job が後続のデプロイタスクの実行をせずに exit していた

## 1.2.11
  * bizside:k8s:cleanup_migration_job 時に --kubeconfig を指定するように修正（#51817）

## 1.2.10
  * `require 'mimemagic'` の追加（#51957）

## 1.2.9
  * mimemagic の依存バージョンの調整

## 1.2.8
  * 監査ログ生成時の company と user の値を決定するための detect_company / detect_user メソッドを用意

## 1.2.7
  * JobUtils#queue_from_class() を追加
  * JobUtils#queue_size() を追加
  * JobUtils#unique_in_queue?() を追加

## 1.2.5
  * bizside::task_helper

    環境変数 ADD_ON_NAME が指定されていれば bizside.yml がなくても add_on_name メソッドを使用できるように（#47270）

    環境変数 PREFIX が指定されていれば bizside.yml がなくても prefix メソッドを使用できるように（#47270）

## 1.2.4
  * cleanup_migration_job にて、add-on-name のアンダースコアをハイフンに寄せるように修正
  * watch_migration_job にて add-on-name のハイフンとアンダースコアの区別をしないように変更

## 1.2.0
  * ShibUtils::ATTRIBUTE_PREFIX = 'AJP_' を廃止
  * ShibUtils.get_bizside_user がチェックするキーの変更
    v1.1 までは、以下の３つのキーからログインユーザのメールアドレスの取得を試みていました。
    * AJP_mail
    * HTTP_X_BIZSIDE_USER
    * X-BIZSIDE-USER

    v1.2 からは、以下の３つのキーを使用します。
    * mail
    * HTTP_X_BIZSIDE_USER
    * X-BIZSIDE-USER

## 1.1.37
  * StringUtils.replace_char_like_hyphen_to メソッド追加

## 1.1.36
  * bizside:k8s:watch_migration_job は itamae.yml db がある場合のみに修正（#45521）

## 1.1.35
  * capistrano タスク bizside:k8s:cleanup_old_docker_image を作成

## 1.1.19
  * file_archiver の正規表現を修正

## 1.1.17
  * bin/bs コマンドを削除

  * Resque 用の Redis の設定ファイルのファイル名候補を追加

    これまでは以下の優先順位で config 配下のファイルの存在を確認し、設定ファイルとしてロードしていました。
    ```
      resque.yml => resque.json
    ```
    以下のように、ファイル名の候補を２つ追加しました。
    ```
      resque.yml => redis.yml => resque.json => redis.json
    ```

## 1.1.16
  * bizside:k8s:watch_migration_job
    * timeout を5分に延長
    * timeout に外部パラメータ BS_WATCH_MIG_MAX_RETRY をサポート
    * job ステータスを表示

## 1.1.12
  * task_helper#ask でpasswordオプションが指定されている場合はデフォルト値があっても表示されないようにしました。

## 1.1.10
  * task_helper#database_yml を廃止

    bizside_tools.gem でのみ使用していると思われるため、bizside_tools.gem に別途メソッドを定義します。
    bizside_tools.gem v0.2.10 以降を利用してください。

  * デプロイ時の ADD_ON_NAME のハイフンとアンダースコアを等価的に扱えるように修正

## 1.1.8
  * JobUtilsのバグ修正（first_atの渡し方を修正）
    * cronを配列で渡せるように修正（例：["* * * * *", :first_in => '1s']）

      https://github.com/jmettraux/rufus-scheduler#first_at-first_in-first-first_time

## 1.1.7
  * k8s 向けの capistrano タスク bizside:k8s:watch_migration_job を作成

## 1.1.6
  * 以下のRakeタスクを bizside_tools.gem に移植
    * rake bs:log:archive
    * rake bs:log:backup
    * rake bs:rsync:backup
    * rake bs:rsync:backup:cron
    * rake bs:rsync:migrate
    * rake bs:rsync:restore
    * rake bs:test

## 1.1.5
  * 以下の古い Rake タスクを削除
    * rake bs:csv:diff
    * rake bs:jenkins:install
    * rake bs:sessions:clear
  * 以下のRakeタスクを bizside_tools.gem に移植
    * rake bs
    * rake bs:resque:assets
    * rake bs:create_databases
    * rake bs:db:dump
    * rake bs:db:load
    * rake bs:itamae
    * rake bs:jenkins:slave:install
    * rake bs:ldap:dump
    * rake bs:ldap:load
    * rake bs:log:fetch
    * rake bs:log:aws_analyze
    * rake bs:shib:metadata:load
    * rake bs:shib:sp:keygen
    * rake bs:shib:sp:metadata

## 1.1.1
  * 環境変数 BIZSIDE_ENV の導入（#40632）

    itamae.yml において、RAILS_ENV の代わりに BIZSIDE_ENV を指定できます。
    RAILS_ENV に production, development, test を指定できるのに対して、BIZSIDE_ENV では追加で staging も指定できます。
    BIZSIDE_ENV に staging を指定した場合、RAILS_ENV としては production と解釈されます。

## 1.1.0
  * 以下のRakeタスクを bizside_tools.gem に移植
    * rake bs:docker:build
    * rake bs:docker:pull
    * rake bs:docker:push
    * rake bs:docker:rm
    * rake bs:docker:rmi

  * 以下のRakeタスクを削除
    * rake bs:jod:install
    * rake bs:mongod:install
    * rake bs:passenger:maintenance

# バージョン v1.1 について

bizside.gem に含まれている運用関係のコードベース（Rakeタスクなど）は、bizside_tools.gem に移行します。
bizside.gem v1.1 以降を利用する場合は、別途 bizside_tools.gem も利用してください。

## 1.0.72
  * k8s 向けの capistrano タスク bizside:k8s:cleanup_migration_job を作成
  * k8s 向けの capistrano タスク bizside:k8s:itamae を作成
  * k8s 向けの capistrano タスク bizside:k8s:kustomize を作成

    環境変数 EKS_CLUSTER_NAME でデプロイ対象のEKSクラスターの指定が必須です。

    itamae.yml の app.env や job.env などに記載しておくことで、cap deploy 時にロードされます。
    k8s ではロールごとに個別のデプロイではなくすべてのロールを一括でデプロイします。
    したがって、app.env の記載も job.env や db.env の記載もすべて統合されます。
    そのため、通常は
    ```
      default: &default
        rails_env: production
        rails_root: /home/railsdev/rails_apps/notable/current
        env:
          eks_cluster_name: ts-bizside-direct
      app:
        <<: *default
      db:
        <<: *default
    ```
    のように、共通化して記載してください。

  * k8s 向けの capistrano タスク bizside:k8s:release_tag を作成
  * rake bs:k8s:manifest:update を bizside_tools.gem に移行（#42439）

## 1.0.67
  * rake bs:itamae

    ActiveSupport::JSON 非依存に

## 1.0.59
  * Bizside.version_info

    /var/[ADD_ON_NAME]/shared/RELEASE_TAG が存在する場合は、git describe からの算出ではなく、当該ファイルに記載されたバージョンを利用する（#42416）

## 1.0.58
  * rake bs:k8s:manifest:update

    k8sのマニフェストファイルを指定したタグで更新(#42392)

## 1.0.56
  * k8s 向けに capistrano を利用するためのBizSide基盤共通ファイルを作成

    k8s にデプロイするアプリの場合、
    ```
    require 'bizside/capistrano'
    ```
    の代わりに
    ```
    require 'bizside/capistrano/k8s'
    ```
    を利用してください。

## 1.0.51
  * rake bs:itamae

    環境変数 BACKEND をサポート

    app.sp_vhosts に IdP に関する設定項目を記載できるようになりました。

    ```
    sp_vhosts:
      - sp_host: app-maeda.bizside.local
        idp_host: ayu.bizside.local
        idp_entity_id: http://ayu.bizside.local/adfs/services/trust
        idp_metadata: /var/bizside/ayu.bizside.local-metadata.xml
    ```

## 1.0.46
  * rake bs:itamae

    itamae.yml をロード時に環境変数 CONFIG_DIR を指定できるように

## 1.0.45
  * SPメタデータ用の証明書を生成するRakeタスク rake bs:shib:sp:keygen を作成
  * SPメタデータを生成するRakeタスク rake bs:shib:sp:metadata を作成

## 1.0.44
  * cap deploy 時に development と test 用の gem をインストールしない（#41310）

## 1.0.43
  * cap deploy 時の bundle install は、並列（-j 2）にする（#41312）

## 1.0.42
  * bizside::resque

    ジョブを意図的に KILL した場合に監査ログの出力がエラーになっていたのを修正
    エラー時の監査ログへのバックトレースの出力を5行から10行に変更

## 1.0.41
  * rake bs:ldap:dump

    ダンプ先ディレクトリ名にホスト名を追加

## 1.0.40
  * rake bs:docker:build
    Dockerfile のデフォルトに IMAGE_NAME からの命名規則を適用

## 1.0.39
  * rake bs:shib:metadata:load
    IDP_HOST の入力をキャッシュするようにしました。
    それにともない、インタラクティブモードにおける文言変更しています。
      IDPホスト => IDP_HOST

## 1.0.38
  * rake bs:jenkins:slave:install
    コンテナによるテスト実行を前提とし、ノード上にテスト用のデータベースを作成しない

## 1.0.37
  * rake bs:itamae
    IDP_HOST と SP_HOST の入力をキャッシュするようにしました。
    それにともない、インタラクティブモードにおける文言変更しています。
      IDPホスト => IDP_HOST
      SPホスト => SP_HOST
  * aws.yml ロード時にERBとして解釈

## 1.0.36
  * 機能修正
    * rake bs:create_databases のアドオン名チェックにおいて、ハイフンとアンダーバーを等価に扱うように修正

## 1.0.35
  * 機能修正
    * cap deploy 時の passenger-config コマンドの検索ロジックを修正
      従来の PATH を前提とせずに、/opt/passenger/current/bin/passenger-config が存在すれば当該コマンドを、
      存在しなければ従来どおり PATH を検索するように変更しています。
    * resqueジョブにおいてstop.txtでの一時停止中、その旨をログ出力するように修正 (#40824)

## 1.0.33
  * 機能修正
    * rake bs:itamae
      以下の仕様が漏れていたのを修正
      HTTPD_LISTEN_80 はデフォルト false
      HTTPD_LISTEN_443 はデフォルト true

## 1.0.32
  * 機能修正
    audit.logにエラー情報を出力するように修正
      適用にはconfig/application.rbに以下を記述してください

        config.middleware.insert_after ActionDispatch::DebugExceptions, Bizside::ShowExceptions

      また、Bizside::AuditLog.build_loginfo() のインターフェースに変更があります。

        class ManAuditLog < ::Bizside::AuditLog

          def build_loginfo(env, start, stop, status)
            info = super
            ...
            ...
            info
          end
        end

      のように引数が４つの状態でオーバライドしている場合は、引数が５つになるように

        def build_loginfo(env, start, stop, status, exception)

      と、インターフェースを修正してください。

## 1.0.31
  * 機能修正
    rake bs:docker:pull / rake bs:docker:push
      バイナリの存在チェック
      aws configure の設定有無のチェック
    のチェック方法を修正（#40635）

## 1.0.30
  * 機能修正
    Gengou.to_wareki を ActiveSupport非依存に（#40176）

## 1.0.29
  * 機能修正
    rake bs:itamae
    RAILS_ENV=production の場合でも、config/itamae.yml があれば利用し、
    shared/itamae.yml を利用する capistrano だけではなく、Dockerコンテナも想定

## 1.0.27
  * 機能修正
    * rake bs:docker:pull / rake bs:docker:push
      task内でのdocker-credential-ecr-loginの設定廃止
        バイナリの存在チェック
        aws configure の設定有無のチェック
      を追加（#40383）
    * rake bs:test
      capybara/cucumber をロードするのは、capybaraを利用している時に限定
  * 機能削除
    * capistrano
      sprockets v2 => v3 へのバージョンアップの考慮を廃止

## 1.0.20
* 機能削除
  * rake bs:redmine:*, rake bs:jenkins:issue_ticket
    redmine に関連する rakeタスクを bizside_tools に移動
    各アプリではこのバージョン以降、 Gemfile に bizside_tools を記載してください(bizside_tools.gemのREADMEにも詳細を記載してあります)

## 1.0.19
* 機能修正
  * Amazon ECR にログイン無しで接続できる設定を
      rake bs:docker:pull
      rake bs:docker:push
    に追加（設定がされていない初回コマンド実行時のみ）
  * 上記に伴い以下を廃止
      rake bs:docker:login
      rake bs:docker:logout
    ※このバージョン以降は docker login の手順は不要

## 1.0.18
* 機能追加
  * Bizside::ImplicitFTPS を導入（#40184）
    Ruby-2.5 において、Net::FTP が FTPS に対応しているが、implicit モードには対応していないので、implicit のためのパッチ

## 1.0.17
* 機能修正
  * rake bs:docker:build
    環境変数 ECR_REPO の問い合わせを廃止
    rake bs:docker:pull / rake bs:docker:push 時に ECR_REPO を問い合わせるように変更されています。

## 1.0.15
* 機能修正
  * rake bs:docker:login
    「WARNING! Using --password via the CLI is insecure. Use --password-stdin.」
    の警告が出ないよう修正

## 1.0.14
* 機能追加
  * user_agentにmacの判定を追加

## 1.0.13
* 機能修正
  * rake bs:docker:login
    環境変数 AWS_PROFILE をインタラクティブに
  * rake bs:docker:push
    PUSH先のレジストリ名で自動でタグ付け
  * Dockerコンテナ内で rake bs:test が実行できるように ChromeDriver のオプション
      --no-sandbox
      --disable-dev-shm-usage
    を追加（#39682）

## 1.0.12
* 機能削除
  * rake bs:gs:install を廃止
  * rake bs:itamae
    * ROLE=test を bizside.gem としてもサポート
    * ROLE=XXX で指定したロール用のレシピファイルとは異なるレシピを環境変数 RECIPE で指定できるように修正

## 1.0.9
* 機能修正
  * rake bs:docker:build
    環境変数 ECR_REPO をインタラクティブに
  * rake bs:docker:push
    環境変数 ECR_REPO をインタラクティブに
  * rake bs:docker:pull
    環境変数 ECR_REPO をインタラクティブに

## 1.0.8
* 機能修正
  * rake bs:docker:login
    環境変数 AWS_PROFILE を明示的に指定しない場合は、プロファイル default を使用（#39304）
    v1.0 以前から rake bs:docker:login を使用していた場合は、明示的にプロファイル ecr を指定する必要があります。
    （Jenkinsのみが対象のため、影響は限定的と判断しています）
  * rake bs:docker:pull
    環境変数 ECR_REPO が指定されている場合、hanaita.yml より優先して使用（#39325）

## 1.0.6
* 機能追加
  * JobUtils#enqueue_in_with_queue を追加
    キューと遅延時間を指定してジョブを登録できます。

## 1.0.4
* 機能修正
  * 設定に ROLE=app のエントリがないアプリのデプロイをおこなう場合は、それ以外の ROLE でアセットプリコンパイルをおこなう

## 1.0.1
* 機能修正
  * rake bs:test
    DatabaseCleaner.strategy が :transaction の時はオプションを指定しない

## 1.0.0
* 機能修正
  Carrierwave 用の設定ファイル storage.yml は完全に aws.yml に移行しました。
  v0.19 系においては、aws.yml と storage.yml が混在している場合に警告していました。
  v1.0 系においては、
    aws.yml => BizSideにおける carrierwave の設定ファイル
    storage.yml => Rails-5 の ActiveStorage の設定ファイル
  であることを前提とし、警告は行わないようにしました。

## 0.19.4
* 機能追加
  * rake bs:itamae
    ROLE=app 時に環境変数 RESOLVER に対応（#38037）

## 0.19.3
* 機能追加
  * Resqueの設定ファイルの書式として YAML だけでなく JSON もサポート

## 0.19.2
* 機能修正
  * rais 5 対応
  * rake bs:test 実行後のDBのクリアから ar_internal_metadata テーブルを除外

## 0.19.1
  * ジョブエラーをジョブ監査ログとしてログ監視（#36249）

## 0.18.5
* 機能修正
  * ask_env においてオプション cache: true が有効な場合、デフォルト値よりキャッシュ値を優先

## 0.18.4
* 機能追加
  * Rakeタスク実行時に使用する ask_env においてオプション cache: true を指定可能になりました。
    ask_env のオプションに
    ```
    ask_env('NFS_SERVER', required: true, cache: true)
    ```
    のように、cache: true を指定することで、ユーザ入力を tmp/cache/env に保存します。
    次回からはキャッシュが存在する場合は、ユーザ入力が省略されます。
    キャッシュをクリアするには `rake tmp:clear` または `rake tmp:cache:clear` を実行してください。

## 0.18.1
* 機能追加
  監査ログにリファラを追記するように（#37547）

## 0.17.38
* 機能修正
  rake bs:docker で ECR リポジトリを使用しない場合に、指定されたバージョンを使用できるように

## 0.17.36
* 機能修正
  rake bs:test の出力するHTMLの微調整

## 0.17.35
* 機能修正
  * itamae_conf で読み込む *.yml を ERB 前提とします。

## 0.17.34
* 機能修正
  * 設定ファイルの configfile に指定したファイルが存在しないとき開発環境の構築ができないため処理を中断してメッセージを表示するように変更 (#35671)

## 0.17.32
* 機能修正
  * rake bs:test のエラーになっていない箇所は赤くしない(#35642)

## 0.17.31
* 機能修正
  * rake bs:test 時にChrome-75以降をヘッドレスで利用できるようにW3Cモードをオフに

## 0.17.30
* 機能追加
  * bs:docker:build でオプション「BUILD_ARGS」を指定できるように対応（#36305）
    BUILD_ARGSは「,」区切りで複数の値を指定できます。

## 0.17.29
* 機能修正
  * cap deploy:setup の add_on_name とGitリポジトリ名のズレに対する考慮漏れに対応（#36271）

## 0.17.28
* 機能追加
  * itamae.yml 内の ERB 表記を解釈できるように
    以下のように、itamae.yml をERBテンプレートとして扱えるようになりました。
    ```
    default: &default
      rails_env: development
      env:
        nfs_server: <%= `minikube ip | cut -d . -f 1-3`.strip %>.1
      hosts:
        - localhost
    ```

## 0.17.27
* 機能追加
  * DockerイメージをビルドするRakeタスクを追加（#35747）
    以下のRakeタスクを用意しました。
    ```
    $ rake bs | grep docker
    rake bs:docker:build                   # Dockerイメージをビルドします。
    rake bs:docker:login                   # ECRにログインします。
    rake bs:docker:logout                  # ECRからログアウトします。
    rake bs:docker:pull                    # DockerイメージをECRからPULLします。
    rake bs:docker:push                    # DockerイメージをECRにPUSHします。
    rake bs:docker:rm                      # 停止しているコンテナを削除します。
    rake bs:docker:rmi                     # 無名のイメージを削除します。
    ```

## 0.17.24
* 機能修正
  * Redmine連携機能をgemに切り出す。(#35243, #35617)
    * Bizside::Redmine::Client を使用する場合は require 'bizside/redmine' としてredmineモジュールを読み込む必要があります。

## 0.17.23
* 機能追加
  * rake bs:itamae
    アプリごとに任意の環境変数を指定できるようになりました。
    itamae.yml にて
    ```
    app:
      env:
        custom_env_key: custom_env_value
    ```
    のように env のエントリーとして任意の項目を設定することでレシピから
    ```
    ENV['CUSTOME_ENV_KEY']
    ```
    として取得できます。

## 0.17.22
* 機能修正
  * #34874で対応したスクリーンショットがあるステップの色付けを罫線の色変更のみに修正(#34874)

## 0.17.21
* 機能修正
  * スクリーンショットがあるステップを色付けて表示し、ひと目で分かるように修正(#34874)

## 0.17.20
* 機能追加
  * cucumber の対象となるフィーチャディレクトリが features-xxxx だった場合に、rake bs:test 時に「テスト対象のホスト」を任意項目にする。(#34224, #34791)

## 0.17.19
* 機能追加
  * Bizside::Redmine::Client#trackers() を追加（#34454）

## 0.17.18
* 機能追加
  * Bizside::UserAgent の Rails5 対応(#34073)

## 0.17.16
  * features-api 内のフィーチャのテストの場合は、アプリを起動は yes とし、インタラクティブに聞かないようにする。(#34186)

## 0.17.15
* 機能修正
  * 新元号(令和)に対応するよう修正(#34003)
  * 和暦に関して、年単位、年月単位、年月日単位で指定できるよう修正(#34003)

## 0.17.14
  * Rails-5系のActiveStorageで扱うstorage.yml とファイル名が被るため、Rails-5系移行前に以下を対応(#33758)
  * Bizsideが扱っている storage.yml を aws.yml というファイル名でも扱えるようにしました。
  * storage.ymlを使用している場合、YAMLロード時に非推奨の警告が出るようにしました。
  * 次期メジャーバージョンアップ(1.0.0)までに、各アプリで storage.yml を aws.yml へリネームしてください。

## 0.17.13
  * itamae.yml に新規パラメータ app_server_processes を追加(#33542)

## 0.17.11
  * Bizside::Redmine::Client#projects にて、ページング用のクエリストリング page, per をサポート

## 0.17.10
  * ストレージにfogを選択したUploaderにおいてダウンロードしたファイルをキャッシュする方式を追加(#32580)

## 0.17.9
  * デプロイ時に ROLE と HOSTS を指定した場合に、ROLE=job にも関わらず Passenger に関する処理を実行しようとしてエラーになっていた（#32890）
  * デプロイ時に ROLE と HOSTS を指定した場合に、ROLE=app にも関わらず Resque に関する処理を実行しようとしてエラーになっていた（#32890）

## 0.17.7
  * Bizside::Redmine::Client にDMSF関連を追加(#32435)
  * rake bs:redmine:dmsf_upload を追加(#32435)

## 0.17.5
  * JobUtils#add_cron_to(queue, name, job_type, cron, *args) を追加
    JobUtils#add_cron(name, job_type, cron, *args) にキューの指定をサポートしたバージョン

## 0.17.4
  * simplecov-rcovへのパッチ
    ruby-2.5 で 発生する文字コード関連の問題へのパッチ。不要になったら除去。
    https://github.com/fguillen/simplecov-rcov/issues/20

## 0.17.3
  * log backup
    ruby-2.5 で NoMethodError: undefined method `make_tmpname' for Dir::Tmpname:Module( #31974 )

## 0.17.2
  * cap deploy
    Resque を使用していない場合でも、rake bs:resque:assets を実行しようとしてエラーになっていた（#31898）

## 0.17.1
  * Ruby-2.2 のサポートを終了
  * Rails-5 のサポートを開始

## 0.16.15
* 機能修正
  * 新元号(令和)に対応するよう修正(#34003)
  * 和暦に関して、年単位、年月単位、年月日単位で指定できるよう修正(#34003)
  ※ v0.17.15 の内容を適用

## 0.16.14
  * cap deploy
    Resque を使用していない場合でも、rake bs:resque:assets を実行しようとしてエラーになっていた（#31898）
    ※ v0.17.2 の内容を適用

## 0.16.13
  * rake bs:itamae ROLE=app
    itamae.yml の新しい設定 app_server_type（環境変数 APP_SERVER_TYPE）に対応。

## 0.16.11
  * rake bs:jenksin:slave:install
    MySQL-5.7 を使用している環境に対応

## 0.16.10
  * rake bs:test
    環境変数 EXPAND=true の指定を廃止

## 0.16.9
  * rake bs:create_databases
    MySQLの管理者パスワードなしでも実行できるように（#31581）

## 0.16.8
  * BizSide::Uploader::Exif でstripする前にorientationを修正するように修正

## 0.16.7
  * rake bs:create_databases 時にポートの指定を無視していたのを修正（#30678）

## 0.16.6
* 機能修正
  * rake bs:create_databases の依存として environment をロード（#30324）

## 0.16.5
* 機能追加
  * JobUtils#enqueue_in を追加（#30335）

## 0.16.4
* 機能追加
  * 監査ログに社員番号（employee_code）を追加（#29716）

## 0.16.3
* 機能修正
  * rake bs:test の出力を修正
    ステップ内のテーブルごとにメッセージを出力さずに、ステップ終了時にすべてのメッセージを出力するように修正

## 0.16.2
* 機能追加
  * Rakeタスク実行時のヘルパーメソッド ask_env を追加。

## 0.16.1
* 機能修正
  * Resque を利用する際に、Redisの名前空間の分離方法を変更（#29110）
    今までは
      Resque.redis.namespace = "resque:#{Bizside.config.add_on_name}"
    と、Rails.env による名前空間の分離がありませんでした。
    このバージョンアップによって、
      Resque.redis.namespace = "resque:#{Bizside.config.add_on_name}:#{Rails.env}"
    と、Rails.env によって名前空間が分離されます。
    これにより、production development test で同じ redis を利用することが可能になります。

    名前空間が変わるため、本番リリースの際には、予めキューにジョブが残っていないことを確認してください。
    リリース後は、リリース前のキューを参照できなくなります。

    また、スケジューリングされているジョブの設定も失われます。
    BizSideマスタ同期のポーリングジョブなど、再度スケジューリングしなおしてください。

## 0.15.31
* 機能修正
  * rake bs:test 時にChrome-75以降をヘッドレスで利用できるようにW3Cモードをオフに

## 0.15.30
* 機能修正
  * cap deploy:setup 時に環境依存ファイルが何もないアプリの場合にエラーになっていたのを修正

## 0.15.28
* 機能修正
  * rake bs:test のドライバを headless_chrome にした場合に、Selenium を明示的にロードするように修正（#29200）

## 0.15.27
* 機能追加
  * ROLE=app に対して sp-*.pem を /etc/bizside/ にアップロード
    環境依存ファイルとして、~/deploy/config/[add_on_name]/shibboleth ディレクトリに
      sp-cert.pem
      sp-key.pem
    を準備しておくことで、各APPサーバに当該鍵ペアをアップロードします。
    ShibbolethSPのセットアップでは、鍵ペアを使用します。
    APPサーバが復数台にスケールする際には、同じ鍵ペアを利用する必要があるので、環境依存ファイルとして管理します。

## 0.15.24
* 機能修正
  * itamae_conf で database.yml をロード
  * bizside_itamae_load_config での itamae.yml の参照元から
    ~/deploy/config/ADD_ON_NAME/itamae.yml を外し config/itamae.yml を追加。
  * itamae_conf の参照元に config/itamae.yml を追加。ただし、shared/itamae.yml
    が存在しない時のみ。database.yml も同様。

## 0.15.16
* 機能修正
  * hanaita_conf は itamae_conf を使用するように修正(#28812)

## 0.15.0
* 機能追加
  * APP/config/deploy.rb の
      after 'deploy:finalize_update' do
        %w{ database.yml ... }.each do |file|
          upload "#{config_dir}/#{file}", "#{latest_release}/config/#{file}"
        end
      end
    は
      set :shared_files, %w{database.yml itamae.yml secrets.yml ...}
    に変わります。

    各アプリにおいては、config/itamae.yml を用意し、を開発環境向けの設定を記載しておきます。
    config/itamae.yml は本番環境では環境依存ファイルの１つとして扱うので、必ず shared_files に
    設定してください。

## 0.14.6
* 機能修正
  * ファイルアップロード時に MiniMagick での処理エラーの際のメッセージがなかったので追加（#28783）

## 0.14.5
* 機能修正
  * rake bs:test
    @spが動かなくなっていたので修正

## 0.14.4
* 機能修正
  * rake bs:test
    ヘッドレスモードでは disable-gpu フラグをオン

## 0.14.3
* 機能修正
  * itamae_conf で add_on_name が未定義の場合、スルーする(#28707)

## 0.14.2
* 機能修正
  * itamae_conf で ROLE が未指定の場合、エラーとせずスルーする(#28704)

## 0.14.1
* 機能廃止
  * rake bs:test
    webkit のサポートを終了
    環境変数 DRIVER=webkit を指定することができなくなります。

## 0.14.0
* 機能修正
  * rake bs:test
    デフォルトで使用するドライバを poltergeist から headless_chrome に変更（#28587）
    テストが必要な環境ではレシピ
      bizside::selenium
    を使用して、selenium の必要なドライバをインストールしてください。

## 0.13.38
* 機能修正
  * v0.13.23 で ContentTypeValidator の下位互換が失われていたので修正（#30239）

## 0.13.37
* 機能修正
  * rake bs:jenkins:slave:install
    Jenkinsマスターノードのホストとポートは hanaita.yml をデフォルト値として参照する

## 0.13.36
* 機能追加
  * JobUtils#peek を追加

## 0.13.35
* 機能追加
  * itamae.yml + /etc/bizside/hanaita.yml を参照する itamae_conf を導入。

## 0.13.33
* 機能修正
  * rake bs:jenkins:slave:install
    ユーザ名とパスワードについて、各アプリのconfig/database.ymlを参照するように修正

## 0.13.32
* 機能修正
  * rake bs:jenkins:slave:install
    Jenkins-2系に対応

## 0.13.27
* 機能修正
  * S3からファイルを downloaded_file 経由でアクセスする部分の修正（#28518）
    空白や括弧を含むファイル名の場合に正常に取得できていませんでした。

## 0.13.26
* 機能修正
  * rake bs:shib:metadata:load（#28498）
     拡張子が xml の場合は、SPメタデータを FilesystemMetadataProvider でロード。
     拡張子が yml の場合は、HTTPMetadataProvider など、YAMLファイルから設定をロード。

## 0.13.25
* 機能修正
  * rake bs:resque:assets
    resqueのインストール先からアセットをコピーするよう修正

## 0.13.24
* 機能修正
  * rake bs:test
    frozen_string_literal に対応

## 0.13.23
* 機能修正
  carrierwaveのcontent_typeのバリデータを修正（#28354）

## 0.13.18
* 機能修正
  itamae.yml にサーバに割り当てられているパブリックIPを指定する public_ip を追加（#28101）

## 0.13.15
* 機能修正
  * carrierwave のファイル名のバリデーションエラーのメッセージ errors.messages.filename_error を
      名に使用できない文字が含まれています。
    から
      %{filename} に使用できない文字が含まれています。
    に変更。

## 0.13.13
* 機能修正
  * rake bs:create_databases の際パスワードが見えないように修正(#28008)
  * Bizside.config.prefix に末尾にスラッシュを付与するかどうかの引数を追加

## 0.13.6
* 機能修正
  capybara のバージョン依存を修正
  s.add_development_dependency 'capybara', '~> 3.0', '< 3.2'

## 0.13.5
* 機能追加
  * ファイルキャッシュの仕組みを追加(#27596)

## 0.13.4
* 機能修正
  itamae.yml にウェブアプリのマウントポイントを指定する prefix を追加（#27602）
  ROLE=app 時の設定項目として、prefix を指定できるようになりました。
  この prefix は bizside.yml の prefix と同じ役割です。
  itamae.yml の prefix（環境変数 PREFIX） と bizside.yml の prefix の両方指定がある場合
  itamae.yml の prefix が優先されます。
  bizside.yml の prefix 指定は、今後、廃止予定です。

## 0.13.2
* 機能修正
  * capistrano のデプロイフローの修正（#27549）
    cap deploy:cold 時に、古いリソースの削除（deploy:cleanup）より先に、
    メンテナンス画面の解除（bizside:maintenance:stop）を実行するようになりました。
    これにより、サービスの再開が以前より早くなります。

## 0.13.0
* 機能修正
  * Ruby-2.0 のサポートを廃止
  * rake bs:test
    webkit のサポートを廃止。代わりに headless_chrome のサポートを追加。

## 0.12.16
* 機能修正
  * Uploader::ContentTypeValidator#validate_content_type! を CarrierWave メソッド recreate_versions! に対応

## 0.12.15
* 機能追加
  * rake bs:log:backup で rake bs:log:split を使用してファイルを分割できるように
    * config/bizside.yml に下記の記載をすることで指定した行数でログを分割します
    ```
      log:
        backup:
          split_line: 300000
    ```
  * storage.yml の設定へのアクセス方法を Bizside.storage_config => Bizside.config.storage に変更

## 0.12.8
* 機能修正
  * IpAddressValidator
    * IPv4のみ正当とし、IPv6は不正とするよう変更しました。
    * CIDR表記用にcidrオプションを追加しました。

## 0.12.5
* 機能修正
  * 監査ログが暗黙に User モデルの存在を前提としていたのを修正
    User モデルから会社を特定しようとするロジックを削除しました。
    連携アプリで BIZSIDE_COMPANY の設定を省略している場合は、連携アプリ側で設定する必要があります。

## 0.12.3
* 機能修正
  * 板前レシピ bizside::server::install でインストールされるWebサーバのデフォルトをnginxに変更(#25559)
    itamae.yml で Webサーバ（WEB_SERVER_TYPE）を指定しておらず、httpd を前提としている場合は、
    httpd を明示的に指定する必要があります。

## 0.12.2
* 機能追加
  * Bizside::FileUploader#downloaded_file メソッドを追加（#25411）
    Carrierwave で Fog を使用している場合に、事前にファイルをストレージからダウンロードし、
    ダウンロードしたファイルの一時的なパスを返します。

## 0.12.1
* 機能修正
  * fog-softlayer のサポートを終了
  * fog-aws のサポートを開始

--------------------------------------------

## 0.11.16
* 機能追加
  * hanaita_conf の簡易指定（#24836）

## 0.11.15
* 機能追加
  * JobUtils#set_job_silently_at を追加（#24883）

## 0.11.14
* 機能修正
  * JobUtils#add_job_silently がsilentlyでなかったため修正（#25001）

## 0.11.13
* 機能修正、追加(#24964)
  * メール送信のデフォルトの処理をまとめたモジュール Bizside::Mailer を追加
  * Bizside::Configurations::Mail#default_url_options を修正
  * cucumber v2.4.0でのBizside::Formatter::CustomFormatterの動作を修正

## 0.11.11
* 機能修正
  * cap deploy でrake assets:precompileのキャッシュを共有するように修正（#24269）
    バージョンアップした際のデプロイではcap deploy:setupが必要になります

## 0.11.10
* 機能修正
  * rake bs:test でドキュメントがうまく出力できなくなっていたのを修正（#24311）

## 0.11.9
* 機能追加
  * StringUtilsにメソッドを追加(#24279)

## 0.11.8
* 機能追加
  * JobUtilsに繰り返しのスケジューラ用メソッドを追加(#24302)

## 0.11.7
* 機能修正
  * cap deploy:start 時の God の再起動方法を修正（#24113）

## 0.11.6
  * rake bs:itamae ROLE=app
     環境変数 BEHIND_LOAD_BALANCER_WITHIN は production モードの時だけの設定に変更

## 0.11.5
  * Rakeを 10系 から 12系 にバージョンアップ
  * rake bs:test の Cucumber v3 対応
    失敗したシナリオを環境変数 RETRY で指定した回数だけリトライできるようになりました。

## 0.10.28
* 機能追加
  * rake bs:ldap:(dump|load) を追加(#23620)

## 0.10.27
  * rake bs:itamae ROLE=app
    Nginx用の環境変数 BEHIND_LOAD_BALANCER_WITHIN に対応（#23951）

## 0.10.23
* 機能修正
  fog-aws が暗黙で mime-types　に依存していたので gemspec を修正（#22960）

## 0.10.22
* 機能修正
  * Bizside::Configurations::Mail#default_url_options を修正（#23173）
    Rails4.1以下でメール送信を利用しているアプリは、v0.9.8以下もしくはv0.10.22以上を利用してください。

## 0.10.21
* 機能追加
  * rake bs:db:load を追加(#22823)

## 0.10.19
* 機能修正
  * bizside.yml で prefix の指定がない場合、Bizside.config.prefix の値が / （ドキュメントルート）になるように修正

## 0.10.18
* 機能修正
  * BizsideSessionsController修正（#22847）
    Bizside::ShibUtils.get_env_value の廃止対応

## 0.10.17
* 機能修正
  * Resque への依存を廃止（#23241）
    resque-1.26.x の使用を継続する場合は、各アプリの Gemfile にてバージョンを固定してください。

## 0.10.16
* 機能修正
  * rake bs:create_databases 時にdatabase.ymlのhostを見るように修正

## 0.10.15
* 機能修正
  * cap deploy:start 時の God の再起動方法を修正

## 0.10.13
* 機能追加
  * AWSにssoできるようにする(#22356)

## 0.10.12
* 機能追加
  * Nginx+Passengerの構成で監査ログに user が出力されていなかった(#22913)

## 0.10.11
* 機能修正
  * carrierwave v1.0.0以上に対応
    CarrierWave::SanitizedFile.sanitize_regexp の上書きを禁止
　　以降は Bizside::FileUploaderクラスのメソッド invalid_filename_regexp を使用してください。

## 0.10.10
* 機能修正
  * Devise::Strategies::BizsideAuthenticatable の　Bizside::ShibUtils.shib_enabled? を廃止

## 0.10.9
* 機能修正
  * Capタスク bizside:resque:start の CentOS-7 対応

## 0.10.6
* 機能修正
  * cap deploy:stop/start/restart 時に tmp/stop.txt を配置・削除する処理を
    Passengerに関係なく、BizSideのデプロイ共通処理として常に実行するように修正。
    これにより、Railsアプリなどに関係なく、メンテナンス画面の表示ができるようになります。

## 0.10.4
* 機能修正
  * cap deploy:restart において、warning が出力されていたのを修正
    bundle exec passenger-config restart-app を sudo で実行するように修正

## 0.10.3
* 機能修正
  * Bizside::FileArchiver::Fogで保存先名称を決定する際の条件を追加(#22599)

## 0.10.2
* 機能修正
  * JenkinsからエラーをRedmineに登録する時、コンソールログも出力する様に変更(#17217)

## 0.10.1
* 機能修正
  * Bizside::ShibUtils.shib_enabled?, get_env_value の廃止（#22154）
    Nginx + ShibbolethSP + Passenger 環境では ShibbolethSP に関する情報が
    環境変数から取得できなくなるため、本メソッドが行っている判定ができなくなります。
    ログインユーザのメールアドレスは
      Bizside::ShibUtils.get_bizside_user(request)
    を使用して取得してください。

## 0.9.10
* 機能修正
  * Passenger への依存を廃止
    Passenger は itamae-plugin-recipe-bizside.gem でバージョン管理します。

## 0.9.9
* 機能修正
  * JobUtils.add_cronの機能修正(#22119)
  * Bizside::Configurations::Mail#default_url_options を修正（#22061）

## 0.9.7
* 機能追加
  * BizsideAPIをBizsideClientに移行（#21617）

## 0.9.6
* 機能追加
  * Bizside::Api::Client に ClosyoClient をプラグインとして追加（#21110）

## 0.9.5
* 機能修正
  * 部門一覧APIにパラメータexist_atを追加(#20833)
  * 部門所属ユーザ一覧APIにパラメータexist_atを追加(#20833)

## 0.9.4
* 機能追加
  * Bizside::Api::Client に SeriClient をプラグインとして追加（#20825）

## 0.9.3
* 機能修正
  * rake bs:shib:idp:install でインストールする Java のバージョンを 1.8 にアップグレード（#20500）

## 0.9.2
* 機能追加
  * user_agentにchromeの判定を追加

## 0.9.1
* 機能修正
  * rake bs:jenkins:install で、JenkinsユーザにSudo権限を与えるように修正
  * rake bs:log:backup の CentOS-7 対応
  * Passenger のバージョンアップ 5.0.30 => 5.1.5
    環境構築が必要です。

## 0.9.0
* CentOS-7 対応を開始

## 0.8.114
* 機能修正
  * rake bs:log:backup において、S3にアーカイブする際のGZip圧縮を廃止
    圧縮されていると、Spark上での分散処理ができないため。
  * 以下のAPIから主務・兼務のレスポンスを削除(#19085)
    * ユーザ一覧
    * ユーザ追加
    * ユーザ更新
    * アカウント無効化
    * アカウント有効化
    * ユーザ退職
    * ユーザ再雇用
    * ユーザ引継ぎ

## 0.8.113
* 機能修正
  * CronValidatorの機能修正(#19994)

## 0.8.112
* 機能修正
  * Rails4.2.9へのバージョンアップに向け、nokogiriのバージョン管理を行うように修正(#19949)

## 0.8.110
* 機能修正
  * rake bs:resque:assets の修正（#19808）
    public ディレクトリまたはシンボリックリンクが既に存在するかチェックするように修正

## 0.8.109
* 機能修正
  * 以下のAPIに、内部会社コードのリクエストとレスポンスを追加(#19764)
    * 部門追加
    * 部門更新

## 0.8.108
* 機能修正
  * 以下のAPIに、表示用部門コード(accounting_unit_code)のリクエストを追加(#19382)
    * 部門追加
    * 部門更新

## 0.8.107
* 機能修正
  * 以下のAPIに、v3として主務・兼務のリクエストを追加(#19085)
    * ユーザ追加
    * ユーザ更新
    * アカウント無効化
    * アカウント有効化
    * ユーザ退職
    * ユーザ再雇用
    * ユーザ引継ぎ
  * 以下のAPIに、v3として主務・兼務のレスポンスを追加(#19085)
    * ユーザ一覧
    * ユーザ追加
    * ユーザ更新
    * アカウント無効化
    * アカウント有効化
    * ユーザ退職
    * ユーザ再雇用
    * ユーザ引継ぎ
  * 部門APIの部門管理者の数（admin_count）を廃止(#19385)
  * 部門APIのレスポンス、部門種別を修正
  * 部門追加APIの項目修正(#19554)

## 0.8.106
* 機能修正
  * 部門追加APIを修正（#19101, #19102）
  * 部門更新APIを修正（#19101, #19102）
  * ユーザ追加APIを修正（#19084）
  * ユーザ更新APIを修正（#19084）

## 0.8.99
* 機能追加
  * エンドポイント取得APIをキャッシュするように修正（#18405）

## 0.8.98
* 機能追加
  * 部門追加APIキー確認APIを追加（#18723）
  * 部門更新APIキー確認APIを追加（#18724）

## 0.8.97
* 機能修正
  * bundler のバージョンを 1.14.6 にバージョンアップ
    ruby-2.2環境で、rails の依存解決がうまくいかなくなりました。（rails-4.2 を望む状況で rails-3.2 になってしまう）
    bundler のバージョンアップで解決しました。

## 0.8.96
* 機能修正
  * Bizside::Api::Client に LandeskProxy をプラグインとして追加（#18283）

## 0.8.95
* 機能修正
  * rake test in bizside directory が bizside_test_app/Gemfile Bundler environment を利用(#18184)

## 0.8.94
* 機能修正
  * メルマガ関連のAPIクライアントをmailza_clientに移行(#18342)

## 0.8.92
* 機能追加
  *  rake bs:log:backup で直接アーカイブまで行う(#17890)
     /etc/bizside/hanaita.yml に log.archive エントリを追加しない限りは
     従来通りの動作となります。
  * アプリケーションログから500エラー専用ページ作成 (#16729)
  * carrierwave ファイルアップロード bizside-gem Stand Alone でのrake taskを考慮 (#17859)
  * sercure_log対策、PASSWORD & REDMINE_API_KEY を Jenkins build parameterに含めず、環境変数として利用 (#17889)

## 0.8.89
* 機能追加
  *  Softlayer にアップしているログのダウンロード＆AWS ES への監査ログ登録(#17488)

## 0.8.88
* 機能修正
  * BizSideAPI部門マスタで、作業所を取得できるように修正（#17535）
    デフォルトでは作業所は取得できません。
    with_site_office => true を指定した場合に取得できます。

## 0.8.87
* 機能修正
  * itamaeの環境共通設定を deploy.pri:~/deploy/config/hanaita/hanaita.yml
    ([デプロイ先ホスト]:/etc/biziside/hanaita.yml)で管理
    itamae.yml の下記項目を hanaita.yml に移動:
    * log_upload_enabled      -> log.upload.enabled
    * log_host                ->           .host
    * log_host_type           ->           .host_type
    * aws_region              ->           .aws.region
    * aws_access_key_id       ->               .access_key_id
    * aws_secret_access_key   ->               .secret_access_key

## 0.8.86
* 機能修正
  * bizside gem 0.8.76 から rake bs:test が落ちるようになった(#17467)

## 0.8.84
* 機能追加
  *  部門マスタに住所・電話番号等の項目を追加（#17439）

## 0.8.82
* 機能追加
  * 連携アプリAPIキー確認APIを追加（#16894）
  * Bizside::Api::Client に CoreProxy をプラグインとして追加（#16880）

## 0.8.76
* 機能修正
  * rake bs:test 実行時に
    fixtuers/bizside/system_settings.yml
    のような、サブディレクトリ内のフィクスチャもロードできるように修正

## 0.8.75
* 機能追加
  * 以下のAPIを追加(#16702, #16749)
    * 連携アプリAPIエンドポイント取得
    * メールマガジン記事追加
    * メールマガジン記事削除

## 0.8.74
* 機能追加
  * JobUtils に遅延ジョブの登録・キャンセル用のメソッドを追加（#16779）

## 0.8.70
* 機能修正
  * resque のバージョンを 1.26 系に固定（#16736）

## 0.8.69
* 機能修正
  * 2者間のCSVの比較結果のタスク rake bs:csv:diff を追加 (#16493)

## 0.8.68
* 機能追加
  * bizside_best_practices.gem を利用できるように

## 0.8.67
* 機能修正
  * MAGからのログアウト用のメッセージを bizside.messages.logout_not_available としてロケールファイルに梱包

## 0.8.66
* 機能追加
  * SqlUtils#like に :backward_match と :forward_match のオプションを指定できるように修正

## 0.8.65
* 機能追加
  * ファイル全文検索APIに以下の変更を実施（#16158）
    * ファイル全文検索APIのリクエストに「version(バージョン)」を追加
    * ファイル全文検索APIのリクエストに「attachment(添付ファイルフラグ)」を追加

## 0.8.62
* 機能修正
  * MimeMagicを利用してないアプリでもエラーにならないよう条件追加（#15692）
  * carrierwave 関係の i18n ロケールファイルをバンドル

## 0.8.57
* 機能修正
  * Bizside::Redmine::Clientにチケット更新メソッドを追加（#16107）

## 0.8.54
* 機能修正(#15925)
  * 以下のAPIに社員が関連会社に所属しているかどうかの項目を追加
    * ユーザ一覧
    * ユーザ追加
    * ユーザ更新
    * アカウント無効化
    * アカウント有効化
    * ユーザ退職
    * ユーザ再雇用
    * ユーザ引継ぎ

## 0.8.53
* 機能修正
  * nokogiri のバージョンを Ruby-2.0 をサポートしている 1.6系に固定
  * rake bs:itamae 実行時に ROLE が app、job、db 以外の場合に RAILS_ENV、RAILS_ROOT を任意の環境変数に訂正

## 0.8.50
* 機能追加
  * Bizside.version_info でアプリのバージョン（Gitタグ）を取得できるようになりました。
  * Resqueジョブを操作するユーティリティクラス JobUtils を用意しました。
    各アプリで lib/job_utils.rb を用意している場合は、名前がバッティングしますのでご注意ください。
* 機能修正
  * bizside/resque.rb で config/resque.yml の読み込みと名前空間の設定まで行うようにしました。

## 0.8.48
* 機能修正
  * itamae.yml から ssl_server_chain の設定がなくなります。
    中間証明書 /etc/pki/tls/certs/server-chain.crt の存在有無から自動判定します。

## 0.8.47
* 機能修正
  * rake bs:log:analyze 取得したログファイルのファイル名のhostname部分から、
    同等環境か本番環境を判別していた外部依存箇所を除去。(#15785)
  * lib/bizside/file_uploader.rb の例外処理のログメッセージ出力を、
    bizside.gem でのログメッセージ出力と合わせた。(#14644)

## 0.8.44
* 機能削除
  * rake bs:db:dump:cron を廃止（板前レシピに移行）
* 機能修正
  * ユーザエージェントの特定処理を修正(#15761)
    * ロードバランサ配下で StickySession に依存しなくてよいように、
      ユーザエージェントは、リクエスト単位で生成し、セッションに保存はしないようにしました。
    * detecte_user_agent は bizside.gem 側で呼び出すので、
      アプリ側での呼び出しは不要になりました。

## 0.8.43
* 機能追加
  * 監査ログに以下を追加(#15750)
    * デバイス
    * ユーザエージェント

## 0.8.41
* 機能修正
  * 変更有無確認APIをv2以降から削除(#15520)
  * bizside.yml からメール設定を mail.yml に分離(#15587)

## 0.8.40
* 機能修正
  * セキュリティ対応 CarrierWave アップロード画像のExif情報を除去（#14644）

## 0.8.38
* 機能修正
  * requeest-log-analyzer での解析にオプション「--format rails3 --parse-strategy cautious」を追加(#15348)
  * rake bs:passenger:install を板前レシピに移行（#15319）
    メンテナンス画面の配置のみ rake bs:passenger:maintenance タスクとして残しています。
  * rake bs:redis:install を廃止して（板前に移行）
  * jenkinsの使用する database.yml に collation: utf8_general_ci を指定（#15286）
  * ShibbolethIdPのセキュリティ強化（#14500, #14501, #14502）

## 0.8.35
* 機能追加
  * cap deploy:setup 時にShibbolethSPの環境差異を定義できるようになりました（#15224）

## 0.8.28
* 機能修正
  * faraday のバージョンを 0.9 系に固定

## 0.8.26
* 機能追加
  * Redmineへのファイルアップロードメソッドを追加(#15176)

## 0.8.25
* 機能追加
  * StringUtilsのrand_stringメソッドを英字と数字が最低1文字を含むように対応(#14494)

## 0.8.23
* 機能追加
  * APIのクライアント側のgzip対応を gem 'faraday_middleware' を使用して対応(#14856)

## 0.8.22
* 機能修正
  * Bizside::Uploader::FilenameValidatorのエラーメッセージを修正(#14918)

## 0.8.21
* 機能追加
  * プロジェクト取得APIを追加(#15019)
  * 部門取得APIを追加(#15019)

## 0.8.20
* 機能修正
  * jodconverterのダウンロードURLが変更されていたので修正

## 0.8.19
* 機能追加
  * Passengerのレスポンスが「css, xml, json」の場合、gzip圧縮するようにしました
* 機能修正
  * メソッド Bizside::ShibUtils.idp_type を実装(#15032)
    Bizside::ShibUtils が提供する定数 IDP_TYPE_MAG または IDP_TYPE_SHIBBOLETH を取得できます。
* 機能削除
  * Bizside.config.quiet_assets を廃止
    Gemfile に
    gem 'quiet_assets'
    を追加して、Gemを使用してください。

## 0.8.16
* 機能修正
  * ログアウト時に指定する returnURL に含まれるクエリストリングを正しくハンドリングするように修正
  * Resqueジョブのエラー時にバックトレースがない場合のハンドリングを修正

## 0.8.14
* 機能追加
  * Bizside::Uploaderにバリデーションを追加(#14891)
    * CarrierWave::SanitizedFile.sanitize_regexpに一致する文字を含むファイルはアップロード不可です。

## 0.8.12
* 機能修正
  * rake bs:create_databases 時にERBテンプレートをパースするように修正

## 0.8.11
* 機能修正
  * APIクライアントのリクエストURLにAPIバージョンを含めるように修正
    * API実行時のパラメータで指定しない場合は v1 です。

## 0.8.10
* 機能修正
  * rake bs:shib:sp:install の板前化（#14729）
    * マルチドメイン用に複数のメタデータを出力できるように修正
    * マルチドメイン用にドメインごとに異なる IdP を設定できるように修正
    * rake bs:shib:sp:install は廃止されました
    * rake bs:shib:metadata:create は廃止されました

## 0.8.9
* 機能修正
  * HTTPレスポンスヘッダ(X-Powered-By)を表示しないように修正(#14497)

## 0.8.8
* 機能修正
  * fog-softlayer 1.1.4 でエンドポイントを環境変数で渡せるようになったことに伴い
    モンキーパッチを削除し、環境変数が設定されていなければ
    storage.ymlの値を環境変数に設定するようにしました。

## 0.8.7
* 機能修正
  * アカウント無効化APIを修正(#14662)
  * ユーザ退職APIを修正(#14662)

## 0.8.4
* 機能修正
  * Passenger バージョンアップ（5.0.23 => 5.0.30）
  * rake bs:itamae 実行時に任意のロールを実行できるように修正
    今までは app job db test のみサポートしていました。

## 0.8.3
* 機能修正
  * rake bs:shib:sp:install 時の環境変数 SHIB_CHECK_ADDRESS を itamae.yml で設定できる部分を廃止（#14391）
    板前でShibbolethSPを構築する場合、IPアドレスチェックは false になります。

## 0.8.2
* 機能追加
  * ユーザ追加APIを追加(#14153)
  * ユーザ更新APIを追加(#14153)
  * ユーザ削除APIを追加(#14154)
  * アカウント無効化APIを追加(#14155)
  * アカウント有効化APIを追加(#14155, #14220)
  * ユーザ退職APIを追加(#14156)
  * ユーザ再雇用APIを追加(#14156, #14221)
  * ユーザ引継ぎAPIを追加(#14217)
  * ユーザ一覧APIを修正(#14212)
* 機能修正
  * APIのリクエストパラメータをJSON形式に変更

## 0.8.0
* 機能修正
  * ruby 2.2 のサポートを開始
  * gem を 2.6.6 にバージョンアップ
  * bundler を 1.12.5 にバージョンアップ

## 0.7.101
* 機能修正
  * rake bs:shib:idp:install 時に httpd と mod_ssl をインストールするように修正

## 0.7.100
* 機能修正
  * rake bs:jenkins:install でインストールするJenkinsのバージョンを 1.658 に固定

## 0.7.99
* 機能削除
  * Rakeタスク bs:openresty:install、bs:openresty:config を廃止し、板前レシピに移行（#13907）

## 0.7.98
* 機能追加
  * itamae.yml でホスト単位での差異を定義できるように拡張（#13925）

## 0.7.95
* 機能修正
  * rake bs:jenkins:issue_ticket が Rails に依存していたので修正（#13792）
  * rake bs:mongodb:install が Rails に依存していたので修正
  * rake bs:phantomjs:install が Rails に依存していたので修正（#13792）

## 0.7.93
* 機能修正
  * ActiveRecordを利用しないRailsアプリでRakeタスクを実行できなかったのを修正（#13770）

## 0.7.91
* 機能修正
  * Rakeタスク bs:log:backup:cron タスクを廃止し、板前レシピ bizside::logrotate::cron に移行
  * rake bs:itamae ROLEの dbとjobで secure_log の設定先ホストを聞くよう lib/tasks/itamae.rake を修正（#13664）
  * rake bs:itamae 実行時、developmentモードのログ出力レベルを DEBUG から INFO に変更
    従来のようにデバッグ出力を有効にするには、rake bs:itamae ROLE=app DEBUG=true のように環境変数 DEBUG を指定します。

## 0.7.89
* 機能修正
  * itamae.yml にロール db が未定義の場合、cap deploy:cold 時にマイグレーションをエラーではなくスキップするように修正（#13570）
  * resqueの監視を微調整（#13570）
    cap deploy:start 時にGod自身が起動していることを担保するように修正
    （/etc/god/*.god ファイルの記述ミスがあり、God自身が起動できていないケースがあっても次回 cap deploy:start 時には問題ないように）

## 0.7.86
* rack のバージョンを 1.X.X 系にピン止め
* email_validator の依存を add_runtime_dependency から add_development_dependency に変更
    email_validator を使用しているアプリでは、Gemfile に、
    ```
    gem 'email_validator', '1.5.0'
    ```
    を追記してください。bizside.gem を定義しているだけでは含まれなくなりました。

## 0.7.84
* 機能修正
  * cap deploy:update 時にディレクトリ ~/rails_apps/[add_on_name]/shared を作成しておくように修正

## 0.7.83
* 機能修正
  * config/itamae/roles に定義されているロールでも、itamae.yml に定義がなければデプロイをスキップするように修正
    今までは、デプロイエラーになっていました。

## 0.7.80
* 機能修正
  * Railsアプリ以外から rake bs:create_databases タスクを実行できるように（#13513）

## 0.7.79
* 機能修正
  * Bizside::Uploader::Storage を不要なケースでは読み込まないように修正

## 0.7.78
* 機能修正
  * cap deploy:update 時にディレクトリ ~/rails_apps/[add_on_name]/releases を作成しておくように修正

## 0.7.75
* 機能修正
  * GhostScript(v9.15)のダウンロードURLが変更されていたので修正。

## 0.7.74
* 機能修正
  * xsendfile 対象のパスに /tmp/[add_on_name] を追加（#11677）
    以下の３つのパスが xsendfile の対象となります。
      * /data/[add_on_name]
      * /tmp/[add_on_name]
      * /var/[add_on_name]

## 0.7.73
* 機能修正
  * ログイン画面にパスワードリセット機能を追加(#12944)

## 0.7.71
* 機能追加
  * Bizside::FileUploaderFog機能を組み込み(Bizside::Uploader::Storageを追加)(#13118)
  * バックアップサーバのログファイルアーカイブ用のタスク(rake bs:log:archive)を追加(#13119)

## 0.7.70
* 機能追加
  * ファイル拡張子取得APIを追加(#12908)
  * Bizside::FileUploaderを追加(#12908)

## 0.7.68
* 機能追加
  * rake bs:shib:sp:install 時の環境変数 SHIB_CHECK_ADDRESS を追加（#13131）
    SHIB_CHECK_ADDRESS が true の場合、SSO認証を行おうとしている認証元クライアント（主にブラウザ）のIPアドレスをチェックします。
    IdPにアクセスする時とSPにアクセスする時で異なるIPアドレスを使用している場合、チェックエラーになります。
    参考： https://wiki.shibboleth.net/confluence/display/SHIB/AddressChecking

## 0.7.64
* 機能修正
  * BizSideAPIクライアントで、指定がないパラメータはクエリストリングに含めないように修正

## 0.7.63
* バグ修正
  * 監査ログに不必要な項目（Rubyロガーがデフォルトで出力する項目）が含まれていたのを修正（#13075）

## 0.7.61
* 機能修正
  * xsendfile 対象のパスに /var/[add_on_name] を追加（#13015）
    以下の２つのパスが xsendfile の対象となります。
      * /var/[add_on_name]
      * /data/[add_on_name]

## 0.7.60
* バグ修正
  * BizSideAPIクライアントの以下の実装に page, per の対応が抜けていたのを修正（#13056）
    * 04.役職
    * 05.協力会社
    * 06.部門
    * 07.部門所属ユーザ

## 0.7.59
* バグ修正
  * rake bs:test 時の Capybara.server_port の指定がおかしいパターンがあったのを修正

## 0.7.58
* 機能追加
  * Resqueの共通処理を汎用化（#12465）
    tmp/stop.txt が存在する場合は、キュー内のジョブを実行しないようにしました。

## 0.7.55
* 機能追加
  * rake bs:test 時の画面キャプチャの保存先を :save_dir で指定できるように修正
    従来は test/report/screenshots 固定でした。

## 0.7.54
* 機能追加
  * DBに保存しているセッションをすべて破棄するRakeタスク rake bs:sessions:clear を追加（#12893）
  * DBに保存しているセッションをすべて破棄するCapタスク bizside:sessions:clear を追加（#12893）

## 0.7.52
* 機能追加
  * rake bs:db:dump のスケジューリングを行うタスク rake bs:db:dump:cron を追加
* 機能修正
  * rake bs:db:dump の出力先に中間ディレクトリ yyyymm を作成し、その中に出力するように修正（#12877）
    ダンプしたファイルをObjectStorageに格納した場合、ウェブ画面からファイルを閲覧することができます。
    すべてのファイルが同じディレクトリに格納されていると画面操作が不便なので、年月ごとにディレクトリを分けることにします。

## 0.7.51
* バグ修正
  * rake bs:db:dump 時に読み込む database.yml がERB形式の場合にも対応

## 0.7.50
* 機能修正
  * rake bs:jenkins:install で0.7.43で廃止された rake bs:httpd:install への依存を削除 (#12729)

## 0.7.49
* 機能修正
  * rake bs:test で DRIVER=ie 時の微調整（#12630）

## 0.7.47
* 機能修正
  * bizside_authenticatable のセッションタイムアウト時のセッション破棄漏れを修正（#6740）

## 0.7.45
* 機能修正
  * rake bs:test で DRIVER=chrome をサポート（#12631）

## 0.7.44
* 機能修正
  * rake bs:font:install を削除（板前レシピに移行）

## 0.7.43
* 機能追加
  * データバックアップを行うタスク rake bs:rsync:backupを作成
    bizside.yml に新しい設定項目 rsync: が追加されています。
    ```
      rsync:
          backup:
            webcam:
              data_dir: 'railsdev@webcam.jcity.maeda.co.jp:/var/webcam'
              backup_base_dir: '/tmp/webcam'
              generations: 5
              crontab: '0 * * * *'
            okoze:
              data_dir: 'railsdev@okoze.jcity.maeda.co.jp:/data/okoze'
              backup_base_dir: '/tmp/okoze'
              generations: 5
              crontab: '0 * * * *'
    ```
* 機能削除
  * rake bs:httpd:install を削除（板前レシピに移行）
  * rake bs:fluentd:install を削除（板前レシピに移行）
  * rake bs:fluentd:config を削除（板前レシピに移行）

## 0.7.42
* 機能修正
  * ShibbolethIdPバージョンアップ 2.3.8 => 2.4.5（#12266）

## 0.7.41
* 機能修正
  * cucumber のタグ @ro と @unit を廃止

## 0.7.39
* 機能修正
  * cucumber-rails が cucumber-2系に対応したので利用を再開
    Gemfile に以下を追記することで利用できます。
    ```
      group :test do
        gem 'cucumber-rails', :require => false
      end
    ```

## 0.7.38
* 機能修正
  * ユーザ一覧取得APIのレスポンスに項目追加（#12361）

## 0.7.37
* 機能修正
  * assert_url の turbolinks 対応（#12419）

## 0.7.36
* 機能修正
  * ShibbolethSPのログアウト処理をローカルログアウトのみサポートするように限定（#12323）

## 0.7.35
* 機能修正
  * phantomjs のバージョンアップ 1.9.8 => 2.1.1

## 0.7.34
* 機能修正
  * バイナリデータ取得系APIに戻り値にヘッダ情報を追加(#12068)

## 0.7.32
* 機能追加
  * 監査ログに項目 department と project を追加(#12118)

## 0.7.31
* 機能修正
  * rake bs:create_databasesを修正(#12011)

## 0.7.30
* 機能修正
  * バイナリを返すAPIをブロックで呼んだ場合のレスポンスにステータスを追加(#11981)

## 0.7.29
* 機能追加
  * 部門所属ユーザAPIのレスポンス項目追加(#11955)

## 0.7.28
* 機能修正
  * 帳票出力APIの修正(#11959)

## 0.7.27
* 機能修正
  * 部門添付ファイル追加・プロジェクト添付ファイル追加APIにパラメータ追加（#11905）

## 0.7.26
* 機能修正
  * cap deploy、cap deploy:setup 等で、ジョブサーバの定義がなくても動作するように修正（#11706）

## 0.7.25
* バグ修正
  * cookie_storeを使用時のuser_agent設定を修正(#11819)

## 0.7.24
* 機能削除
  * rake bs:wkhtmltopdf:install タスクを廃止（板前レシピ化）

## 0.7.23
* 機能追加
  * ファイル全文検索API追加（#11634）

## 0.7.22
* 機能修正
  * ユーザエージェントIE判定を修正（#11691）

## 0.7.21
* 機能修正
  * cap deploy 時のホストの指定を deploy_config.rb から itamae.yml に変更（#11706）
    この対応に伴い、各アプリの deploy.rb で
    '''
    role :web
    role :app
    role :db
    role :job
    '''
    とロールの定義を行っていた実装は不要になります。

## 0.7.20
* 機能修正
  * APIパラメータ修正(#11707, #11709)

## 0.7.19
* 機能修正
  * 帳票出力APIの仕様変更(#11674)

## 0.7.16
* 機能修正
  * 監査ログアップロードAPIの修正(#11311)

## 0.7.15
* 機能追加
  * 部門ファイル取得・追加・削除、部門フォルダ追加のAPIを追加(#11548)
  * 部門添付ファイル取得・追加・削除APIの追加（#11549）

## 0.7.14
* 機能追加
  * APIクライアントのテストができるように調整（#11311）

## 0.7.13
* バグ修正
  * Rails4 で cucumber から fixtures を利用できるように修正
* 機能追加
  * ログの回収および分析の自動化(#11321)
  * rake bs:rsync:migrate 指定されたディレクトリ内のファイルを指定されたディレクトリに退避させ、退避が完了したファイルは参照先から削除する。
  * rake bs:log:analyze request-log-analyzerを実行する。
  * rake bs:redmine:log_report:upload RedmineのプロジェクトにWikiページを登録し、ログの分析結果を掲載します。

## 0.7.9
* 機能修正
  * Passengerバージョンアップ 5.0.16 => 5.0.23
    Security Fix を含みます

## 0.7.6
* 機能修正
  * ファイルアップロード関連のAPIを修正(#11311)

## 0.7.5
  * BizSideが提供するRakeタスクおよびCapistranoタスクのラッパーコマンド bs
    * Rakeコマンドの実行の代わりに bs コマンドで同じ処理を行うことができます。
      Rakeタスクを実行するには、事前に bundle install が必要ですが、bs コマンドの場合は、コマンド内で自動的に行われます。
      '''
      $ rake bs:itamae
      '''
      は
      '''
      $ bs itamae
      '''
      のように、Rakeタスクのネームスペース bs を省いた部分が bs コマンドのオプションになります。

## 0.7.2
  * APIの追加
    * プロジェクト添付ファイル取得・追加・削除APIの追加（#11546）

## 0.7.1
  * APIの追加
    * 取得したデータからファイルを出力するジョブを登録するAPIとfeatureを追加（#11317,#11332）
    * IDを指定して生成されたファイルを取得するAPIとfeatureを追加（#11318,#11332）

## 0.7.0
* 機能修正
  * itamaeの依存を修正
  * 板前ロール「db」を導入

## 0.6.13
* 機能修正
  * rake bs:god:install を廃止(#11271)

## 0.6.9
* 機能追加
  * rake bs:directory:permissions_x タスクを追加

## 0.6.8
* 機能修正
  * capistranoのsprocketsバージョンチェック処理の誤検知対応（sprockets -v → bundle exec sprockets -v）

## 0.6.7
* 機能追加
  * Itamae対応（#10960）
  * rake bs:httpd:install 時にXSendFileの設定ファイル「/etc/httpd/conf.d/xsendfile.conf」を用意（#10960）
  * rake bs:passenger:install 時にXSendFileのアプリ用設定ファイル「/etc/httpd/conf.d/[APPホスト]/[アドオン名]_xsendfile.conf」を用意（#11142）
  * rake bs:nginx:start タスクを追加
  * rake bs:nginx:stop タスクを追加
  * rake bs:font:noto:install タスクを追加
  * rake bs:openresty:install タスクを追加
  * rake bs:openresty:config タスクを追加
  * rake bs:wkhtmltopdf:install タスクを追加

## 0.6.6
  * Rails4系に対応（#11213）
    * カバレッジの取得およびCI上でのテスト結果の出力用の初期化処理を作成
    test/test_helper.rb の先頭で
    '''
      require 'bizside/test_help'
    '''
    することで各アプリでの記載を省略できるようになりました。

## 0.6.5
  * 監査ログファイル追加APIのパラメータ変更（#10910）
    * 指定可能なパラメータをfileのみに変更

## 0.6.2
  * 監査ログ出力項目の追加（#11128）
    * data項目の追加

## 0.5.75
* 機能修正
  * rake bs:db:dump で database.yml のポート番号を数値で指定した場合にエラーになるのを修正（#10996）

## 0.5.69
* 機能追加
  * API修正（#11047）
    * 会社ロゴ取得APIに modified_since を追加

## 0.5.64
* 機能修正
  * Cucumber出力結果のHTMLレイアウトを微調整

## 0.5.57
* 機能修正
  * rake bs:db:dump がポート番号を database.yml から読み取るように修正（#10996）

## 0.5.54
* バグ修正
  * ルート直下に Passenger をマウントした場合に /Shibboleth.sso に正常にアクセスできない問題を修正

## 0.5.36
* 機能修正
  * 会社ロゴの実体ファイルを取得するAPIの追加(#10948)

## 0.5.33
* 機能修正
  * 監査ログの一括取り込みAPIの作成(#10910)

## 0.5.28
* 機能修正
  * Passengerのメンテナンス画面差し替え(#10818)
  * Shibbolethのエラー画面差し替え(#10818)
  * ログイン画面差し替え(#10450, #10885)

## 0.5.20
* 機能修正
  * ShibbolethIdPが一時的にダウンしていても、Shibdの再起動が不要になるように修正（#10860, #10884）

## 0.5.18
* 機能修正
  * IEの受入テスト用セットアップの改善（#10730）
  * Cucumber用のUserInputHelperを廃止（#10730）
  * Cucumberで、ブラウザがリモートホスト上の場合には実行しないことを意味する @local タグを追加

## 0.5.14
* 機能修正
  * ShibbolethIdP のメタデータのファイル名を *-metadata.xml から *.xml による判定に変更（#9250）
  * Passenger設定時の中間証明書に関する設定 ssl.server_chain を廃止（#9560）

## 0.5.12
* 機能追加
  * ユーザエージェントのiPhone判定、Android Mobile判定、Windows判定を追加

## 0.5.9
* 機能修正
  * Cucumberバージョンアップ 2.0.2 => 2.1.0

## 0.5.8
* 機能修正
  * Passengerバージョンアップ 5.0.8 => 5.0.16

## 0.5.7
* 機能修正
  * BizSideAPI-Company で会社のステータス（有効・無効）を取得できるように修正（#10108）

## 0.5.6
* 機能追加
  * 監査ログを出力するかしないかを制御できるようにしました。
    リクエスト環境変数「BIZSIDE_SUPPRESS_AUDIT」が真の場合、監査ログを出力しません。
    ```
    class ApplicationController < ActionController::Base
      after_filter :auditable?

      # APIは監査ログに出力しない例
      def auditable?
        request.env['BIZSIDE_SUPPRESS_AUDIT'] = request.env['REQUEST_URI'].include?('/api/')
      end
    end
    ```
  * 監査ログに、ユーザの画面操作がどの機能に関するものかを識別する項目「feature」を追加しました。
    リクエスト環境変数「BIZSIDE_FEATURE」の値が、feature に出力されます。
    値は、
      ユーザ管理
      ワークフロー
      ドキュメント管理
    など、可読性のある文言を設定します。
  * 監査ログに、ユーザの画面操作がどのようなアクションなのかを識別する項目「action」を追加しました。
    リクエスト環境変数「BIZSIDE_ACTION」の値が、action に出力されます。
    値は、
      登録
      承認
      ダウンロード
    など、可読性のある文言を設定します。
  * 監査ログに、ユーザの能動的な画面操作よるリクエストを識別する項目「interactive」を追加しました。
    リクエスト環境変数「BIZSIDE_INTERACTIVE」の値が、interactive に出力されます。
    値は、
      1：ユーザの画面操作など
      0：アプリによる自動リクエストなど
    を設定します。

## 0.5.4
* 機能修正
  * cucumber のバージョンを 2.0系にアップデート
  * capybara のバージョンを 2.4系から2.5系にアップデート

## 0.4.81
* 機能修正
  * 各会社のログイン画面を編集した場合に即反映されるように修正（#9961）

## 0.4.80
* バグ修正
  * rake bs:shib:sp:install でメタデータ生成処理に問題があったのを修正（#10031）

## 0.4.78
* 機能追加
  * 会社ごとにログインページをカスタマイズできるように
  * SPメタデータを生成するタスク rake bs:metadata:create を追加

## 0.4.72
* 機能修正
  * ログサーバがサポートするElasticSearchのURLに Scan+Scroll を追加

## 0.4.71
* バグ修正
  * BizSideAPI-Users#index
    ページングしない場合は、パラメータ page と per をクエリストリングに含めない（互換性維持）ように修正

## 0.4.70
* 機能修正 #9666
  * rake bs:gs:install でインストールする God の設定において、
    ログロテート後に God を再起動しないように修正。

## 0.4.69
  * ログバックアップのCron設定を行うタスク rake bs:log:backup:cron を作成
    bizside.yml に新しい設定項目 crontab が追加されています。
    ```
      log:
        backup:
          backup_dir: /var/csc/backup
          crontab: '0 0 * * *'
    ```

## 0.4.67
* 機能追加
  * BizSideAPI-Users において、ページングができるように修正

## 0.4.63
* 機能追加
  * rake bs:log:backup でログファイルを削除せず、中身をクリアするように修正

## 0.4.62
* 機能追加
  * Passenger を 4.0.59 から 5.0.8 にバージョンアップ

## 0.4.59
* 機能修正
  * オブジェクトストレージ（CloudFuse）がmvに非対応のためcp&rmに変更

## 0.4.58
* 機能追加
  * logロテート&バックアップタスクを用意

## 0.4.56
* 機能追加
  * Jenkinsスレーブのインストールタスクを用意

## 0.4.54
* 機能追加
  * url_validator を追加

## 0.4.53
* 機能追加
  * rake bs:test でフィーチャ単体を実行する場合、デフォルトで EXPAND=true を設定
  * UserInputHelper#confirm にオプション :quiet を指定できるように修正

## 0.4.51
* 機能追加
  * java.security を更新
    jdk.tls.disabledAlgorithms=SSLv3

## 0.4.50
* 機能追加
  * rake bs:kibana:config:nginx でBizsideの追加設定ファイルを include できるように修正

## 0.4.49
* バグ修正
 * rake bs:shib:login:install で Tomcat を停止できない時があるのを修正

## 0.4.48
* バグ修正
 * Devise 認証後に Query String がなくなってしまうので修正

## 0.4.47
* バグ修正
  * rake csc:jenkins:slave:install が動かなくなっていたので修正

## 0.4.45
* 機能追加
  * BizSideAPI に project_folders を追加
  * BizSideAPI に project_files を追加

## 0.4.37
* 機能追加
  * jquery-treeTable（カスタマイズ済み）を梱包

## 0.4.36
* 機能追加
  * rake bs:shib:login:install 時のシェルスクリプト実行時オプションに -e を追加
  * rake bs:shib:sp:install 時のシェルスクリプト実行時オプションに -e を追加
  * Passenger を 4.0.57 から 4.0.59 にバージョンアップ

## 0.4.35
* 機能追加
  * rake bs:kibana:config:nginx の非インタラクティブ対応

## 0.4.34
* 機能追加
  * rake bs:fluentd:config:audit の非インタラクティブ対応

## 0.4.32
* バグ修正
  * email_validator を改善

## 0.4.31
* 機能追加
  * ユーザエージェントのIE判定を追加

## 0.4.30
* 機能追加
  * GhostScriptのインストールタスク rake bs:gs:install を追加

## 0.4.29
* 機能追加
  * Passenger を 4.0.53 から 4.0.57 にバージョンアップ
  * PhantomJS を 1.9.7 から 1.9.8 にバージョンアップ
  * PhantomJSの起動オプションに --ssl-protocol=tlsv1 を追加

## 0.4.26
* 機能追加
  * carrierwave用のユーティリティ追加

## 0.4.25
* 機能追加
  * Redmineのプロジェクト一覧を取得するAPIを追加

## 0.4.24
* バグ修正
  * gem_dir の実装が手抜きだったので修正
  * 非Shibboleth配下のパスでも監査ログが出力できるように修正

### 0.4.22
* 機能追加
  * rake bs:create_databases の最後に flush privileges を実行
  * rake bs:passenger:install の非インタラクティブ対応
  * rake bs:ldap:install の非インタラクティブ対応

### 0.4.21
* 機能追加
  * rake bs:create_databases の非インタラクティブ対応
  * rake bs:shib:idp:install の非インタラクティブ対応
  * rake bs:shib:sp:install の非インタラクティブ対応
  * rake bs:shib:login:install の非インタラクティブ対応

### 0.4.20
* 機能追加
  * yum install 時に -y オプションを付与し、非インタラクティブ化

### 0.4.19
* バグ修正
  * rake bs:shib:sp:install で <Location>タグのディレクトリ指定が // となる場合があったのを修正

### 0.4.18
* 機能追加
  * CollectionPresenceValidator を追加

### 0.4.17
* バグ修正
  * 0.4.6 のバグを修正

### 0.4.16
* 機能追加
  * ファイル変換処理の対象に拡張子「.jpeg」を追加
  * cucumber(capybara)のデフォルト待ち時間を設定可能に
  * poltergeistで自己認証証明書のサイトにアクセスできるように
  * smtp_settings に項目「openssl_verify_mode」を追加
* バグ修正
  * resque-web のアセットを梱包

### 0.4.10
* バグ修正
  * SMTPの設定を管理しきれてなかったので修正

### 0.4.9
* 機能追加
  * タスク rake bs:jod:install を追加
  * Bizside::FileConverer を追加
    bizside.yml で
    <pre>
      jod_converter:
        enabled: true
    </pre>
    とすることで有効になります。
    アプリの依存Gemに rmagick が必要になります。

### 0.4.7
* 機能追加
  * SMTPの設定を管理できるように

### 0.4.6
* 機能追加
  * rake bs:passenger:install 時に、server-chain.crtの記述をできるように修正

### 0.4.5
* バグ修正
  * rake bs:shib:sp:install 時に、IdPが同一サーバ上に構築されている場合、
    MetadataProvider はローカルファイルを参照するように修正

### 0.4.4
* バグ修正
  * Cucumberのドライラン（DRY_RUN=true）が実行できなくなっていたので修正

### 0.4.3
* バグ修正
  * メンテナンス中画面のクレジットを SoftLayer に修正

### 0.4.2
* 機能追加
  * ShibbolethIdP を稼働させる Tomcat のバージョンを 7.0.x にアップデート
    * バージョンアップする際には、既存の tomcat6 をアンインストールしてください。
      <pre>
      $ sudo yum erase tomcat6*
      $ rake bs:shib:idp:install
      </pre>
  * rake bs:shib:sp:install におけるバーチャルホスト対応
    * バージョンアップする際には、既存の /opt/shibboleth-idp/metadata/[アドオン名]-metadata.xml を削除してください。
* バグ修正
  * Tomcat-7.0.x で IdP のログイン画面が文字化けしていたのを修正

### 0.3.52
* バグ修正
  * rake bs:shib:sp:install で <Location>タグのディレクトリ指定が抜ける場合があったのを修正
  * [バーチャルホスト名].conf が passenger.conf より先に読み込まれるように、プリフィックス「BS-」を付与し、BS-[バーチャルホスト名].conf にファイル名を変更
    * バージョンアップする際には、/etc/httpd/conf.d/[バーチャルホスト名].conf を削除してください。

### 0.3.50
* 機能追加
  * rake bs:create_databases の実行時に誤って他のアプリのDBを削除しないようにアプリ名のチェックを追加

### 0.3.49
* 機能追加
  * デプロイ時に使用するモジュール「bizside/capistrano」を作成
    * git remote -v のパース処理

### 0.3.47
* 機能追加
  * rake bs:db:dump のダンプファイル名に日時を含めるように

### 0.3.46
* バグ修正
  * rake bs:shib:sp:install で <Location>タグのディレクトリ指定が抜ける場合があったのを修正

### 0.3.45
* 機能追加
  * rake bs:passenger:install 時の SSLv3.0 の脆弱性 (CVE-2014-3566)対応
* バグ修正
  * Shibboleth化対象のパスの末尾のスラッシュを除去（デグレ修正）
  * rake bs:httpd:install のスクリプトに全角スペースが混在していたのを修正（デグレ修正）

### 0.3.42
* バグ修正
  * 複数バーチャルホストの場合に、<VirtualHost>タグが最後の１つしか設定されていなかったのを修正

### 0.3.41
* バグ修正
  * rake bs:shib:sp:install 時にデータベースに接続しようとしてエラーになっていたのを修正

### 0.3.40
* 機能追加
  * Passenger を 4.0.52 から 4.0.53 にバージョンアップ
  * ShibbolethSP のインストール時に、Shibboleth化するパスを指定可能に
  * Railsアプリの設定ファイル場所を /etc/httpd/conf.d/rails/*.conf から /etc/httpd/conf.d/[バーチャルホスト名]/*.conf に変更
  * ShibbolethSPの設定ファイル場所を /etc/httpd/conf.d/shib.d/*.conf から /etc/httpd/conf.d/[バーチャルホスト名]/*.conf に変更
* バグ修正
  * 監査ログを出力しない設定なのに、logフォルダが存在しないとエラーになっていた

### 0.3.33
* 機能追加
  * ACLに true を指定できるように

### 0.3.32
* 機能追加
  * アプリを任意の場所にマウントできるように、bizside.yml に設定値 prefix を追加
    対応したタスク
    rake bs:passenger:install

### 0.3.31
* 機能追加
  * BizsideAuthenticatable
    Bizside.config.devise.allow_new_user の場合、認証できたユーザがDBにまだ未登録の場合に登録する
  * Cucumber を 1.3.16 から 1.3.17 にバージョンアップ

### 0.3.28
* 機能追加
  * BizSideAPI「create_company」に対応

### 0.3.26
* 機能追加
  * バリデータ email, tel, zip を追加

### 0.3.24
* 機能追加
  * BizSideAPI「companies」のレスポンス内容に運用区分を追加。
* バグ修正
  rake bs:passenger:install でメッセージ
  「AILS_ROOT=/home/railsdev/rails_apps/trial/current で処理を進めます。」
  が２回出力されるのが冗長なので抑制

### 0.3.23
* 機能追加
  * BizSideAPI「who_is」に対応
* バグ修正
  * ACL: ロールが見つからない場合はアクセス不可

### 0.3.21
* 機能追加
  * rake bs コマンドで bizside のタスクに加えて、アドオンのタスクも表示するように変更
  * bizside 標準のタスクヘルパーを Rake タスクから利用できるように
    <pre>
      require 'bizside/task_helper'
    </pre>
  * rake bs:passenger:install が行っている処理を標準出力に表示
  * 開発環境「RAILS_ENV=development」の場合、rake bs:passenger:config の後に httpd を再起動

### 0.3.20
* 機能追加
  * Passenger の設定ファイルで RackBaseURI が PassengerBaseURI に指定方法が変わったので修正
* バグ修正
  * bizside_authenticatable の改善

### 0.3.19
* 機能追加
  * Passenger を 4.0.49 から 4.0.50 にバージョンアップ

### 0.3.18
* 機能追加
  * SP用のメタデータを受領後に、relaying-party.xml を再構築するタスクを作成
    rake bs:shib:metadata:load

### 0.3.17
* バグ修正
  * bizside_authenticatable で development モードの場合に時折ログイン処理がリダイレクトループになる問題を修正

### 0.3.15
* バグ修正
  * rake bs:ldap:install を tmp フォルダなしの状態から実行できるように修正

### 0.3.14
* バグ修正
  * Passenger の Apache モジュールのインストール時をインタラクティブでないように修正
    Windows から Poderosa でインストールしようとするとエンターキーが反応しない（改行をCR+LFにすれば反応する）

### 0.3.13
* 機能追加
  * なし
* バグ修正
  * bizside_authenticatableが production モードで動作しなかったのを修正

### 0.3.12
* バグ修正
  * bizside_authenticatableが正しくログアウトできていなかったのを修正

### 0.3.11
* 機能追加
  * BizSideAPI に協力会社取得用のインターフェースを追加

### 0.3.10
* 機能追加
  * Passenger を 4.0.48 から 4.0.49 にバージョンアップ
