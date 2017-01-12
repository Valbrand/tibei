project 'Tibei/Tibei.xcodeproj'

def framework_pods()
end

def test_pods()
    pod 'Quick', '~> 1.0'
    pod 'Nimble', '~> 5.0'
end

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Tibei-iOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Tibei-iOS
  framework_pods()

  target 'Tibei-iOSTests' do
    inherit! :search_paths
    # Pods for testing
    test_pods()
  end

end

target 'Tibei-tvOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Tibei-tvOS
  framework_pods()

  target 'Tibei-tvOSTests' do
    inherit! :search_paths
    # Pods for testing
    test_pods()
  end

end
