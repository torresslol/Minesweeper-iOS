# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'MineSweeper' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  
  # Pods for Minesweeper

  pod 'SwifterSwift'
  pod 'R.swift'
  pod 'IGListKit'
  pod 'LookinServer', :subspecs => ['Swift'], :configurations => ['Debug']
  pod 'SnapKit'
  target 'MineSweeperTests' do
    inherit! :search_paths
    # Pods for testing

  end

  target 'MineSweeperUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    
    # 添加以下配置来解决 libarclite 问题
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end

  # 解决模拟器上的 arm64 架构警告
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

