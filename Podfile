platform :ios, "9.0"
use_frameworks!
pod 'NCMB', :git => 'https://github.com/NIFTYCloud-mbaas/ncmb_ios.git'
pod 'Fabric'
pod 'Crashlytics'
pod 'Meyasubaco'
pod 'Google-Mobile-Ads-SDK'
pod 'NendSDK_iOS'
pod 'GoogleAnalytics-iOS-SDK'

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-Acknowledgements.plist', 'ZooZooZoo/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
