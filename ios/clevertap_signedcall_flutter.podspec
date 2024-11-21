#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint clevertap_signedcall_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'clevertap_signedcall_flutter'
  s.version          = '0.0.7'
  s.summary          = 'CleverTap SignedCall Flutter plugin.'
  s.description      = <<-DESC
  CleverTap SignedCall supports 1-1 voice calls.
                       DESC
  s.homepage         = 'https://github.com/CleverTap/clevertap-signedcall-flutter-sdk'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'CleverTap' => 'http://www.clevertap.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'CleverTap-SignedCall-SDK', '0.0.9'

  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
