
Pod::Spec.new do |s|
	s.name             = 'fXDObjC'
	s.version          = '1.0.0'
	s.summary          = 'Objective-C module of fXDKit. Separated for stable compilation'

	s.description      = s.summary
	
	s.homepage         = 'https://github.com/petershine/fXDKit'
	s.license          = { :type => 'MIT', :file => 'LICENSE' }
	s.author           = { 'Peter SHIN' => 'petershine@fxceed.com' }
	s.source           = { :git => 'https://github.com/petershine/fXDKit.git', :tag => s.version.to_s }
	s.social_media_url = 'https://www.linkedin.com/in/petershine/'
	
	s.ios.deployment_target = '17.0'
	
	s.swift_version = '5.0'
	s.source_files = [
	'fXDObjC/_interfaces/*.{h,m}',
	'fXDObjC/_module/*.{h,m}',
	'fXDObjC/View/*.{h,m}',
	'fXDObjC/Object/*.{h,m}']
	
	s.exclude_files = ['fXDObjC/fXDObj.h']

end
