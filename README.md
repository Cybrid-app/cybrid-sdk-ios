# Cybrid iOS SDK

[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-Green?style=flat-square)
[![CircleCI](https://dl.circleci.com/status-badge/img/gh/Cybrid-app/cybrid-sdk-ios/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/Cybrid-app/cybrid-sdk-ios/tree/main)
[![codecov](https://codecov.io/gh/Cybrid-app/cybrid-sdk-ios/branch/main/graph/badge.svg?token=LTJJFQJWEA)](https://codecov.io/gh/Cybrid-app/cybrid-sdk-ios)

The Cybrid iOS SDK for cryptocurrency transactions and financial services offers a comprehensive solution for iOS applications. We provide customizable UI screens and elements to efficiently collect user data. Moreover, we expose low-level APIs to enable the creation of entirely customized user experiences. Whether it's for cryptocurrency transactions, identity verification (KYC), or managing bank accounts and wallets, our SDK simplifies integration into your iOS app, ensuring flexibility and quality.

Table of contents
=================

<!--ts-->
   * [Requirements](#requirements)
   * [Installation](#installation)
   * [Integration](#integration)
      * [SDKConfig](#sdkconfig)
      * [CybridEnvironment](#cybridEnvironment)
      * [CybridLogger](#cybridLogger)
      * [Setup](#setup)

<!--te-->

## Requirements

The Cybrid iOS SDK requires Xcode 14.1 or later and is compatible with apps targetting iOS 13 or above.

## Installation

To install our iOS SDK for now, you can only do so via Cocoapods. If you haven’t already, install the latest version of [CocoaPods](https://guides.cocoapods.org/using/getting-started.html).

1. If you don’t have an existing [Podfile](https://guides.cocoapods.org/syntax/podfile.html), run the following command to create one:

`pod init`

2. Add our podspec to your Podfile (second line)

`source 'git@github.com:Cybrid-app/cybrid-podspecs.git'`

3. Add the dependencie in the Podfile common_pods section)

`pod CybridSDK`

4. Run the following command in terminal:

`pod install`

Don’t forget to use the `.xcworkspace` file to open your project in Xcode, instead of the `.xcodeproj` file, from here on out.

5. In the future, to update to the latest version of the SDK, run in terminal:

`pod update CybridSDK`

## Integration

### SDKConfig

To get the SDK up and running, you'll need to pass an SDKConfig object to it the first time you instantiate it. The SDKConfig object should be provided as an argument in its constructor:

| Argument      | Descrption          | Default    |
| ------------- |:-------------------:|:----------:|
| enviroment    | [CybridEnvironment]() | sandbox  |
| bearer        | Bearer token should be retrieved from the backend | |
| customerGuid  | Customer GUID value | |
| customer      | CustomerBankModel | nil |
| bank.         | BankBankModel | nil |

The SDK must have a `bearer` token to interact with the platform APIs.
For demonstration purposes **only**, we request a token in the demo application using the bank's credentials.

### CybridEnvironment

The available environments are:

- staging
- sandbox
- production

### CybridLogger

The SDK isupports supplying a logger implementation for events that are generated at runtime.
You can create your own logger implementation that extends our `CybridLogger` class and add the `log` method, as shown in the following example:

```swift
final class CustomLogger: CybridLogger {
    func log(_ event: CybridEvent) {
    print("\(event.level.rawValue):\(event.code) - \(event.message)")
  }
}
```

### Setup

To set up the SDK, you simply need to call the `setup` function from the Cybrid module, which takes `SDKConfig`, `CybridLogger`, and a completion block of type `() -> Void` as parameters

```swift
Cybrid.setup(sdkConfig: sdkConfig, logger: CustomLogger()) {}
```

When this completion is called, it means that the SDK is ready to render any screen or component you need.





### 3. Use our Components:

The SDK implements a set of `ViewController` components that you can integrate easily in your application.

- Price List View:

This component is an isolated view that displays the latest prices of the support assets on the platform.

```
let tableView = CryptoPriceListView()
```

- Trade Component: 

This component display the latest prices of the supported assets and allow you to trade (i.e. buy or sell) the asset.

```
let tableView = CryptoPriceListView(navigationController: navigationController)
```

- Accounts Component:


This component allows you to display the available accounts and get the details for each account.


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

- 2: Use the Login Screen and pass the `clientId`, `clientSecret` and `customerGuid` values.

The demo application can be run on the simulator or on a physical device.
