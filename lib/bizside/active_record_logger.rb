if Rails.env.development?
  ActiveRecord::Base.logger = nil
end
