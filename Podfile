source 'https://cdn.cocoapods.org/'
source 'git@github.com:Cybrid-app/cybrid-podspecs.git'

iphoneOS_deployment_target = '13.0'
platform :ios, iphoneOS_deployment_target

project 'CybridSDK'
use_frameworks!

def common_pods
  pod 'CybridApiBankSwift'
  pod 'BigInt'
  pod 'PersonaInquirySDK2'
  pod 'Plaid'
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

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
