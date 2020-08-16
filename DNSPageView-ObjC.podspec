
Pod::Spec.new do |s|
  s.name             = 'DNSPageView-ObjC'
  s.version          = '2.0.0'
  s.summary          = 'DNSPageView-ObjC is a library for pageView'
  s.description      = <<-DESC
                       DNSPageView-ObjC is a library for pageView.
                       DESC

  s.homepage         = 'https://github.com/Danie1s/DNSPageView-ObjC'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniels' => '176516837@qq.com' }
  s.source           = { :git => 'https://github.com/Danie1s/DNSPageView-ObjC.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.framework    = 'UIKit'
  s.source_files = 'DNSPageView-ObjC/*.{h,m}'
  s.requires_arc = true

end
