# 電話番号のバリデーション
# ActiveModel::EachValidatorを継承してRailsに統合する
class TelValidator < ActiveModel::EachValidator

  def initialize(options = {})
    super(options)
  end

  # レコード保存時に呼び出されるバリデーションメソッド
  # record ・・・　保存対象のレコード
  # attribute　・・・　チェック対象の属性（DBのカラム）
  # value　・・・　入力された値
  def validate_each(record, attribute, value)
    return if value.nil? or value.empty?
    
    unless validate_tel(record, value)
      record.errors[attribute] << I18n.t('errors.messages.invalid')
    end
  end
  
  private

  # 電話番号として妥当かどうかのチェック
  def validate_tel(record, value)
    # 全角・半角とわず数字とハイフンの構成であれば良しとしている
    value.match(/^[0-9|０-９]+[-|－]?[0-9|０-９]+[-|－]?[0-9|０-９]+$/)
  end
end
