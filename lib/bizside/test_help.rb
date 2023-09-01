require 'minitest/reporters'

require_relative 'coverage/launch'
Bizside::CoverageLaunch.load_from_test_helper()

case ENV['CI'].to_s.downcase
when 'jenkins'
  Minitest::Reporters.use! [
    Minitest::Reporters::DefaultReporter.new,
    Minitest::Reporters::JUnitReporter.new
  ]
else
  unless ENV['RM_INFO']
    Minitest::Reporters.use! [
      Minitest::Reporters::DefaultReporter.new(color: true)
    ]
  end
end
