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
      * [CybridEnvironment](#CybridEnvironment)
      * [CybridLogger](#CybridLogger)
      * [Setup](#setup)
      * [Cybrid](#cybrid)
   * [Components](#components)
      * [ListPrices](#list-prices)
         * [ListPricesItemDelegate](#list-prices-item-delegate)
         * [Preview](#preview)
      * [Trade](#trade)
         * [Preview](#preview) 

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

### Cybrid

The SDK provides a Singleton object or class called `Cybrid` that allows easy interaction with the general SDK configurations. It offers a list of available methods as follows:

1. `Cybrid.setup()`

Method to initialize the [SDK](#setup)

Parameteres:

| Argument      | Descrption          | Default    |
| ------------- |:-------------------:|:----------:|
| sdkConfig    | [SDKConfig](#sdkconfig) | |
| locale        | [Locale](https://developer.apple.com/documentation/foundation/locale) | nil |
| logger  | [CybridLogger](#CybridLogger) | nil |
| refreshRate      | [TimeInterval](https://developer.apple.com/documentation/foundation/timeinterval) for components that support it  | 5 |
| completion         | () -> Void | nil |

2. `Cybrid.refreshBearer()`

Method to refresh the Bearer

Parameters:

| Argument      | Descrption          | Default    |
| ------------- |:-------------------:|:----------:|
| bearer    | Bearer token should be retrieved from the backend (String) | |

3. `Cybrid.findAsset() throws -> AssetBankModel`

Method to find an asset, this method can throw an exception

Parameters:

| Argument      | Descrption          | Default    |
| ------------- |:-------------------:|:----------:|
| code    | AssetBankModel code | |

You should call it with `try` and handle any exceptions with a `do-catch` block, similar to the example below:

```swift
do {
    let asset = try findAsset(code: "exampleCode")
} catch {
    // Handle the error here
}
```

or

```swift
let asset = try? findAsset(code: "exampleCode")
```

Using `try` and `do-catch` allows you to handle any exceptions that may be thrown within `findAsset`, which is especially important when working with functions that can generate errors.

## Components

All components can be instantiated either with their `ViewController` or as independent `UIView` that can be placed anywhere, such as in `SwiftUI`, `CustomViewController`, or within a `UIView`.

The only component that behaves strictly as a `UIView` is the ListPrices component.

### ListPrices

The ListPrices component allows you to view a list of available currencies for the logged-in customer and allows them to see the real-time price of the currency. It also includes a search feature.

This method is tied to the TimeInterval (refreshRate) configured at the beginning in the SDK to update the list of prices respecting that time interval.

To use this component, you should utilize the `ListPricesView` class, which provides the following methods:

1. constructor (`ListPricesView()`)

Constructor to initialize this component with no arguments.

2. `setViewModel()`

To make the component work and render the view, you should call this method, which only takes the `ListPricesViewModel` class as a parameter.

3. `embed()`

This method allows you to easily inject this view into a `UIView` or `UIViewController`

And this memebers:

1. itemDelegate: [ListPricesItemDelegate](#list-prices-item-delegate), can be nil

#### ListPricesItemDelegate

ListPricesItemDelegate is a protocol that implements the function:

```swift
func onSelected(asset: AssetBankModel, counterAsset: AssetBankModel)
```

#### Preview

<p align="center">
  <img src="https://github.com/Cybrid-app/cybrid-sdk-ios/assets/7268597/72b2c251-317e-4901-93b2-fef7583092eb">
</p>

### Trade

The Trade Component allows you to display a user interface for buying or selling a cryptocurrency asset from or to a fiat account (e.g., USD). This component relies entirely on the `ListPricesView` component to display the list of assets initially.

This component is also affected by the general configuration of `TimeInterval` (refreshRate) for updating asset prices and refreshing the `QuoteBankModel`.

To use this component, you can do so in the following ways:

1. TradeVIewController

To use this component, you simply need to create an instance of `TradeViewController` and display it.

#### Preview

<p align="center">
  <img src="https://github.com/Cybrid-app/cybrid-sdk-ios/assets/7268597/b91ee833-8d57-40f2-9de3-aff62fcd98d1">
</p>


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
