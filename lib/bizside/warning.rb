require 'bizside/record_has_warnings'

module Bizside
  module Warning
    extend ActiveSupport::Concern

    included do
      attr_accessor :warnings_confirmed
    end

    def warnings
      @warnings ||= []
    end

    def check_warnings
      raise Bizside::RecordHasWarnings.new if warnings.present?
    end

    def warnings_confirmed?
      self.warnings_confirmed == '1' or self.warnings_confirmed == true
    end

  end
end
