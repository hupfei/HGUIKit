#
# Be sure to run `pod lib lint HGUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HGUIKit'
  s.version          = '0.1.1'
  s.summary          = 'QMUIKit + MVVM'
  s.description      = '基于 QMUIKit 快速创建 MVVM 框架'
  s.homepage         = 'https://github.com/hupfei/HGUIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hupfei' => 'HG_hupfei@163.com' }
  s.source           = { :git => 'https://github.com/hupfei/HGUIKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  
  s.requires_arc = true

  s.dependency 'YYKit'
  s.dependency 'QMUIKit'
  s.dependency 'ReactiveObjC'
  s.dependency 'MJRefresh'
  
  s.source_files = 'HGUIKit/Classes/**/*'
  s.resource = 'HGUIKit/HGUIKit.bundle'
  
end
