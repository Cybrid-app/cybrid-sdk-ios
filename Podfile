iphoneOS_deployment_target = '13.0'
platform :ios, iphoneOS_deployment_target

project 'CybridSDK'
use_frameworks!

def common_pods
  unless ENV['CI']
    pod 'CybridApiBankSwift', :path => '../cybrid-api-bank-swift/CybridApiBankSwift.podspec'
  end
end

def quality_pods
  pod 'SwiftLint', '~> 0.47.1'
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
