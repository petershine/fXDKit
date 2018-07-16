
Pod::Spec.new do |s|
  s.name             = 'fXDKit'
  s.version          = '0.1.4'
  s.summary          = 'Personal and Professional collection of implementations and snippets, which have been included in most of my projects, since 2012'

  s.description      = 'Personal and Professional collection of implementations and snippets, which have been included in most of my projects, since 2012'

  s.homepage         = 'https://github.com/petershine/fXDKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Peter SHIN' => 'petershine@fxceed.com' }
  s.source           = { :git => 'https://github.com/petershine/fXDKit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.linkedin.com/in/petershine/'

  s.ios.deployment_target = '10.0'

  s.swift_version = '4.0'
  s.source_files = 'fXDKit/Classes/**/*'
  s.resource_bundles = {'fXDKit' => ['fXDKit/Resources/*.*']}

	s.dependency 'Bolts'
	s.dependency 'FBSDKCoreKit'
	s.dependency 'FBSDKLoginKit'
	s.dependency 'FBSDKShareKit'

	s.dependency 'TwitterKit'
end
