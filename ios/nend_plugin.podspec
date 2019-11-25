#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'nend_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin that bridging nendSDK.'
  s.description      = <<-DESC
A new Flutter plugin that bridging nendSDK.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'NendSDK_iOS', '~> 5.3.0'
  s.static_framework = true

  s.ios.deployment_target = '8.1'
end

