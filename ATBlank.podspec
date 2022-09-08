#
# Be sure to run `pod lib lint ATBlank.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ATBlank'
  s.version          = '0.4.1'
  s.summary          = 'blank view'
  s.homepage         = 'https://github.com/ablettchen/ATBlank'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ablettchen' => 'ablettchen@gmail.com' }
  s.platform         = :ios, '10.0'
  s.source           = { :git => 'https://github.com/ablettchen/ATBlank.git', :tag => s.version.to_s }
  
  s.source_files = 'ATBlank/Classes/**/*'
  
  s.resource_bundles = {
    'ATBlank' => ['ATBlank/Assets/*.xcassets']
  }
  
  s.dependency 'Masonry'
  
end
