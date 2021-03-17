# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TOG-Test' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TOG-Test
  pod 'RxSwift', '6.1.0'
  pod 'RxCocoa', '6.1.0'
  pod 'RxDataSources', '~> 5.0'
  pod 'SwiftyJSON'
  pod 'Alamofire'
  pod 'Kingfisher'
  pod "ESPullToRefresh"
  pod 'YouTubePlayer'

  target 'TOG-TestTests' do
    inherit! :search_paths
    # Pods for testing
#    pod 'RxBlocking', '6.1.0'
#    pod 'RxTest', '6.1.0'
  end

  target 'TOG-TestUITests' do
    # Pods for testing
  end
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
