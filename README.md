# cybrid-sdk-ios

iOS SDK Library and Demo App for Cybrid API.

[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-Green?style=flat-square)
![CircleCI](https://circleci.com/gh/Cybrid-app/cybrid-sdk-ios.svg?style=svg)
[![codecov](https://codecov.io/gh/Cybrid-app/cybrid-sdk-ios/branch/main/graph/badge.svg?token=LTJJFQJWEA)](https://codecov.io/gh/Cybrid-app/cybrid-sdk-ios)

## Installation

### CocoaPods

Add our podspec repo to your App's Podfile:

`source 'git@github.com:Cybrid-app/cybrid-podspecs.git'`

An then install the depenedencies:

`pod install CybridSDK`

## Usage

### 1. Setup SDK

To use the SDK is neccesary have a `bearer` token, this token have to be requested to your API for security reasons.

For Demo purposes we request `bearer` token in the DemoApp but the credentials have to setted in the Login Screen.

After you get the token, setup the SDK like this:

```
Cybrid.setup(bearer: bearerToken,
             customerGUID: guid ?? "",
             fiat: .usd)
```

### 2. Logger

Our logger allows to log every kind of event that happens in the SDK.
You have to create your own logger implementation that extends of our logger. Check this basic implementation:

```
final class ClientLogger: CybridLogger {
	func log(_ event: CybridEvent) {
		print("\(event.level.rawValue):\(event.code) - \(event.message)")
	}
}
```

To use your client you have to set it in the SDk setup:

```
Cybrid.setup(...
             logger: ClientLogger())
```

### 3. Use our Components:

The SDK implemnts a list of comonents that you can implement easily in your application, all the components are `ViewControllers` so eaasily can be intancieted.

- Price List View:

This component is the only component that is isoleted view.
This component display the latest prices of the supported assets.

```
let tableView = CryptoPriceListView()
```

- Trade Component: 

This component display the latest prices of the supported assets and allow you to trade (Buy, Sell) the asset :

```
let tableView = CryptoPriceListView(navigationController: navigationController)
```

- Accounts Component:

This component allow you to display the available accounts and get the detail of each one.

To show the component you only have to present the ViewController:

```
let accounts = AccountsViewController()
```

## Demo App

To setup the demo app you have two options:

- 1: Add enviroment vars into the system

```
export CybridClientId = 'XXXX'
export CybridClientSecret = 'XXXX'
export CybridCustomerGUID = 'XXXX'
```

- 2: Use the Logn Screen and pass this 3 values

To run the demo app you need to run the demo app inside the emulator or physical device.
