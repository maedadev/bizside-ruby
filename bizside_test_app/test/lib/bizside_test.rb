require 'test_helper'

class BiziseTest < ActiveSupport::TestCase
  TARGET_CLASS_NAMES = %w[
    CronValidator Gengou JobUtils QueryBuilder
    RecordHasWarnings SqlUtils StringUtils UserAgent Yes
  ].freeze
  TEMP_BIZSIDE_YAML_PATH = File.join('tmp', 'bizside.yml')

  setup do
    @original_config_file_env = ENV['CONFIG_FILE']
    # bizside.rb を load すると config/bizside.yml から設定がリロードされる。
    # よってテスト対象の設定値が記載されたYAMLのパスを環境変数で指定する。
    ENV['CONFIG_FILE'] = TEMP_BIZSIDE_YAML_PATH
    FileUtils.mkdir_p('tmp')

    TARGET_CLASS_NAMES.each do |class_name|
      ::Object.__send__(:remove_const, class_name) rescue nil
    end
  end

  test 'within_bizside_namespace がない場合、対象クラスがトップレベルにも定義される' do
    File.write(TEMP_BIZSIDE_YAML_PATH, <<-YAML)
test:
    YAML

    load 'bizside.rb'

    TARGET_CLASS_NAMES.each do |class_name|
      assert self.class.const_defined?(class_name)
      assert self.class.const_defined?("Bizside::#{class_name}")
    end
  end

  test 'within_bizside_namespace がfalseの場合、対象クラスがトップレベルにも定義される' do
    File.write(TEMP_BIZSIDE_YAML_PATH, <<-YAML)
test:
  within_bizside_namespace: false
    YAML

    load 'bizside.rb'

    TARGET_CLASS_NAMES.each do |class_name|
      assert self.class.const_defined?(class_name)
      assert self.class.const_defined?("Bizside::#{class_name}")
    end
  end

  test 'within_bizside_namespace がtrueの場合、対象クラスがトップレベルには定義されない' do
    File.write(TEMP_BIZSIDE_YAML_PATH, <<-YAML)
test:
  within_bizside_namespace: true
    YAML

    load 'bizside.rb'

    TARGET_CLASS_NAMES.each do |class_name|
      assert_not self.class.const_defined?(class_name)
      assert self.class.const_defined?("Bizside::#{class_name}")
    end
  end

  teardown do
    ENV['CONFIG_FILE'] = @original_config_file_env
    FileUtils.rm_rf(TEMP_BIZSIDE_YAML_PATH)

    next if ::Bizside.config.within_bizside_namespace.present?

    TARGET_CLASS_NAMES.each do |class_name|
      next if self.class.const_defined?(class_name)

      self.class.const_set class_name, self.class.const_get("::Bizside::#{class_name}")
    end
  end
end
