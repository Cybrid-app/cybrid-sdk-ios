target 'CybridSDK' do
  use_frameworks!

  # Pods for CybridSDK
  pod 'SwiftLint', '~> 0.47.1'
  pod 'Alamofire', '5.4.0' # Outdated version

  if ENV['IS_RUNNING_ON_CI']
    pod 'CybridApiBankSwift', :path => '../cybrid-api-bank-swift/CybridApiBankSwift.podspec'
  end

end
