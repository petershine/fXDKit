
Pod::Spec.new do |s|
  s.name             = 'fXDObjC'
  s.version          = '0.0.1'
  s.summary          = 'Objective-C module of fXDKit. Separated for robust compilation'

  s.description      = 'Objective-C module of fXDKit. Separated for robust compilation. Personal and Professional collection of implementations and snippets, which have been included in most of my projects, since 2012'

  s.homepage         = 'https://github.com/petershine/fXDKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Peter SHIN' => 'petershine@fxceed.com' }
  s.source           = { :git => 'https://github.com/petershine/fXDKit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.linkedin.com/in/petershine/'

  s.ios.deployment_target = '11.0'

  s.swift_version = '4.2'
  s.source_files = 'fXDKit/Classes/_ObjC/**/*.{h,m}'

end
