#
# Be sure to run `pod lib lint HGUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HGUIKit'
  s.version          = '0.1.2'
  s.summary          = 'QMUIKit + MVVM'
  s.description      = '基于 QMUIKit 快速创建 MVVM 框架'
  s.homepage         = 'https://github.com/hupfei/HGUIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hupfei' => 'HG_hupfei@163.com' }
  s.source           = { :git => 'https://github.com/hupfei/HGUIKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  
  s.requires_arc = true
  s.dependency 'ReactiveObjC'
  s.dependency 'MJRefresh'
  s.dependency 'QMUIKit'
  
  s.resource = 'HGUIKit/HGUIKit.bundle'
  s.source_files = 'HGUIKit/Classes/*.h'
  s.subspec 'HGMainViewController' do |ss|
  	ss.source_files = 'HGUIKit/Classes/HGMainViewController/*.{h,m}'
  	ss.public_header_files = 'HGUIKit/Classes/HGMainViewController/*.{h}'
  	ss.dependency 'HGUIKit/Classes/HGMainViewModel'
  	ss.dependency 'HGUIKit/Classes/HGUIComponents'
  end
  s.subspec 'HGMainViewModel' do |ss|
  	ss.source_files = 'HGUIKit/Classes/HGMainViewModel/*.{h,m}'
  	ss.public_header_files = 'HGUIKit/Classes/HGMainViewModel/*.{h}'
  	ss.dependency 'HGUIKit/Classes/HGMainViewController'
  	ss.dependency 'HGUIKit/Classes/HGUIComponents'
  	ss.dependency 'HGUIKit/Classes/HGUICategory'
  end
  s.subspec 'HGUICategory' do |ss|
  	ss.source_files = 'HGUIKit/Classes/HGUICategory/*.{h,m}'
  	ss.public_header_files = 'HGUIKit/Classes/HGUICategory/*.{h}'
	ss.dependency 'HGUIKit/Classes/HGMainViewController/HGCommonViewController.{h,m}'
  end
  s.subspec 'HGUIComponents' do |ss|
  	ss.source_files = 'HGUIKit/Classes/HGUIComponents/*.{h,m}'
  	ss.public_header_files = 'HGUIKit/Classes/HGUIComponents/*.{h}'
  end
  
end
