#
# Be sure to run `pod lib lint Tibei.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Tibei'
  s.version          = '0.1.3'
  s.summary          = 'A Bonjour-powered library to simplify communication between devices.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Tibei is a library that enables simple communication between devices, using Bonjour to publish and discover them. It is currently in a very early stage of development, still lacking documentation, testing and proper API polishing. This is a WIP.
                       DESC

  s.homepage         = 'https://github.com/valbrand/Tibei'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Oliveira' => 'dvalbrand@gmail.com' }
  s.source           = { :git => 'https://github.com/valbrand/Tibei.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.4'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'Sources/Tibei/**/*'

  # s.resource_bundles = {
  #   'Tibei' => ['Tibei/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
