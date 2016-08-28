# Podfile
use_frameworks!

target 'RxSwiftExample' do
    pod 'RxSwift',    '~> 2.0'
    pod 'RxCocoa',    '~> 2.0'
end

post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '2.3'
          config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
        end
      end
    end
