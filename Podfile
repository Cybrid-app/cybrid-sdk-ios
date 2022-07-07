source 'git@github.com:Cybrid-app/cybrid-podspecs.git'
source 'https://github.com/CocoaPods/Specs'

iphoneOS_deployment_target = '13.0'
platform :ios, iphoneOS_deployment_target

project 'CybridSDK'
use_frameworks!

def common_pods
  unless ENV['CI']
    pod 'CybridApiBankSwift'
    pod 'BigInt'
  end
end

def quality_pods
  pod 'SwiftLint', '~> 0.47'
end

abstract_target 'Abstract' do
  common_pods

  target 'CybridSDK'
  target 'CybridSDKTests' do
    quality_pods
  end
  target 'CybridSDKTestApp' do
  end
end
