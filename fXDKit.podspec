#
# Be sure to run `pod lib lint fXDKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'fXDKit'
  s.version          = '0.1.1'
  s.summary          = 'Personal and Professional collection of implementations and snippets, which have been included in most of my projects, since 2012'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/petershine/fXDKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Peter SHIN' => 'petershine@fxceed.com' }
  s.source           = { :git => 'https://github.com/petershine/fXDKit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.linkedin.com/in/petershine/'

  s.ios.deployment_target = '10.0'

  s.swift_version = '4.0'
  s.source_files = 'fXDKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'fXDKit' => ['fXDKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'ReactiveSwift'

  s.dependency 'FBSDKCoreKit'
  s.dependency 'FBSDKLoginKit'
  s.dependency 'FBSDKShareKit'

  s.dependency 'TwitterKit'
end
