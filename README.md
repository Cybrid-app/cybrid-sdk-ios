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
         * [TradeViewModel](#trade-view-model)
         * [Preview](#preview)
      * [Transfer](#transfer)
         * [TransferViewModel](#transfer-view-model)
         * [Preview](#preview)
      * [Accounts](#accounts)
         * [AccountsViewModel](#accounts-view-model)
         * [Preview](#preview)
         * [AccountTrades](#account-trades)
            * [AccountTradesViewModel](#account-trades-view-model) 
            * [Permissions](#permissions) 
      * [Identity](#identity)
         * [IdentityVerificationViewModel](#identity-verification-view-model)
         * [Permissions](#permissions)
      * [BankAccounts](#bank-accounts)
         * [BankAccountsViewModel](#bank-accounts-view-model)
         * [Preview](#preview)
       * [DepositAddress](#deposit-address)
         * [DepositAddressViewModel](#deposit-address-view-model)
         * [Preview](#preview)
       * [ExternalWallets](#external-wallets)
         * [ExternalWalletsViewModel](#external-wallets-view-model)
         * [Permissions](#permissions)
         * [Preview](#preview)
       * [CryptoTransfer](#crypto-transfer)
         * [CryptoTransferViewModel](#crypto-transfer-view-model)
         * [Preview](#preview) 
    * [Demo App](#demo-app) 

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

To use the component as UIVIewController, you simply need to create an instance of `TradeViewController` and display it.

```swift
let tradeViewController = TradeViewController()
```

2. TradeView

To use the component as UIView, you simply need to create the view and pass the [TradeViewModel](#trade-view-model) instance.

```swift
let tradeView = TradeView()
tradeView.parentController = self
tradeView.initComponent(tradeViewModel: tradeViewModel)
```

#### TradeViewModel

The TradeViewModel helps manage how the view interacts with Cybrid services and manipulates the view based on certain inputs. Creating it is as straightforward as this:

```swift
let tradeViewModel = TradeViewModel(
    dataProvider: CybridSession.current,
    logger: Cybrid.logger
)
```

#### Preview

<p align="center">
  <img src="https://github.com/Cybrid-app/cybrid-sdk-ios/assets/7268597/b91ee833-8d57-40f2-9de3-aff62fcd98d1">
</p>

### Transfer

The TransferComponent allows you to make a deposit from a connected bank account or make a withdrawal to a connected bank account, the component also shows the available balance in the configured fiat account.

To use this component, you can do so in the following ways:

1. TransferViewController

To use this component, you simply need to create an instance of `AccountsViewController` and display it.

```swift
let transferViewController = TransferViewController()
```

2. TransferView

To use the component as UIView, you simply need to create the view and pass the [TransferViewModel](#transfer-view-model) instance.

```swift
let transferView = TransferView()
transferView.parentController = self
transferView.initComponent(transferViewModel: transferViewModel)
```

#### TransferViewModel

The TransferViewModel helps manage how the view interacts with Cybrid services and manipulates the view based on certain inputs. Creating it is as straightforward as this:

```swift
let transferViewModel = TransferViewModel(
    dataProvider: CybridSession.current,
    logger: Cybrid.logger
)
```

#### Preview

<p align="center">
  <img src="https://github.com/Cybrid-app/cybrid-sdk-ios/assets/7268597/b91ee833-8d57-40f2-9de3-aff62fcd98d1">
</p>

### Accounts

The Accounts Component allows you to display the overall balance of all customer accounts and a list of customer accounts. It displays fiat accounts first and then accounts related to a cryptocurrency asset, all sorted alphabetically. Each account can provide a detailed view, showing the latest transfers or trades made.

This component is related to the `TransfersComponent` and `DepositAddressComponent`.

To use this component, you can do so in the following ways:

1. AccountsVIewController

To use this component, you simply need to create an instance of `AccountsViewController` and display it.

```swift
let accountsViewController = AccountsViewController()
```

2. AccountsView

To use the component as UIView, you simply need to create the view and pass the [AccountsViewModel](#accounts-view-model) instance.

```swift
let accountsView = AccountsView()
accountsView.parentController = self
accountsView.initComponent(accountsViewModel: accountsViewModel)
```

#### AccountsViewModel

The AccountsVieWModel helps manage how the view interacts with Cybrid services and manipulates the view based on certain inputs. Creating it is as straightforward as this:

```swift
let accountsViewModel = AccountsViewModel(
    dataProvider: CybridSession.current,
    logger: Cybrid.logger
)
```

#### Preview

<div align="center">
  <video src="https://github.com/Cybrid-app/cybrid-sdk-ios/assets/7268597/4b4765b0-7684-45eb-ab22-0b4bbd3bdad3" controls />
</div>

#### AccountTrades

The AccountTrades component allows you to view a crypto account and its specific details, such as its balance in the account and its real-time balance in the configured fiat account, in addition to a list of recent trades, whether purchase or sale, each with detail and the possibility of clicking and being able to see even more detail.

To use this component, you can do so in the following ways:

1. AccountTradesViewController

To use this component, you simply need to create an instance of `AccountTradesViewController` and add this to the constructor:

| Argument      | Descrption          | Default    |
| ------------- |:-------------------:|:----------:|
| balance    | BalaceUIModel | |

```swift
let accountTradesViewController = AccountTradesViewController(balance: BalaceUIModel)
```

2. AccountTradesView

To use the component as UIView, you simply need to create the view and pass the [AccountTradesViewModel](#account-trades-view-model) instance.

```swift
let accountTradesView = AccountTradesView()
accountTradesView.parentController = self
accountTradesView.initComponent(balance: BalaceUIModel, accountsViewModel: accountsViewModel)
```

##### AccountTradesViewModel

The AccountsVieWModel helps manage how the view interacts with Cybrid services and manipulates the view based on certain inputs. Creating it is as straightforward as this:

```swift
let accountTradesViewModel = AccountTradesViewModel(
    dataProvider: CybridSession.current,
    logger: Cybrid.logger
)
```

##### Preview

<div align="center">
  <video src="https://github.com/Cybrid-app/cybrid-sdk-ios/assets/7268597/4b4765b0-7684-45eb-ab22-0b4bbd3bdad3" controls />
</div>

#### AccountTransfers

The AccountTrades component allows you to view a fiat account and its specific details, such as its balance in the account and pending balance, in addition to a list of recent transfers, whether withdraw or deposit, each with detail and the possibility of clicking and being able to see even more detail.

To use this component, you can do so in the following ways:

1. AccountTransfersViewController

To use this component, you simply need to create an instance of `AccountTransfersViewController` and add this to the constructor:

| Argument      | Descrption          | Default    |
| ------------- |:-------------------:|:----------:|
| balance    | BalaceUIModel | |

```swift
let accountTransfersViewController = AccountTransfersViewController(balance: BalaceUIModel)
```

2. AccountTransfersView

To use the component as UIView, you simply need to create the view and pass the [AccountTransfersViewModel](#account-transfers-view-model) instance.

```swift
let accountTransfersView = AccountTransfersView()
accountTransfersView.parentController = self
accountTransfersView.initComponent(balance: BalaceUIModel, accountTransfersViewModel: AccountTransfersViewModel)
```

##### AccountTransfersViewModel

The AccountTransfersViewModel helps manage how the view interacts with Cybrid services and manipulates the view based on certain inputs. Creating it is as straightforward as this:

```swift
let accountTransfersViewModel = AccountTransfersViewModel(
    dataProvider: CybridSession.current,
    logger: Cybrid.logger
)
```

##### Preview

<div align="center">
  <video src="https://github.com/Cybrid-app/cybrid-sdk-ios/assets/7268597/4b4765b0-7684-45eb-ab22-0b4bbd3bdad3" controls />
</div>

### Identity

The Identity component allows you to carry out a KYC (Know Your Client) process through the [Persona](https://withpersona.com/) platform; The component checks if the customer already has the process completed and verified, otherwise it will show the status of the verification whether it is in process, an error, or the verification needs to be carried out for the first time.

To use this component, you can do so in the following ways:

1. IdentityVerificationViewController

To use this component, you simply need to create an instance of `IdentityVerificationViewController` and display it.

```swift
let identityVerificationViewController = IdentityVerificationViewController()
```

2. IdentityView

To use the component as UIView, you simply need to create the view and pass the [IdentityVerificationViewModel](#identity-verificacion-view-model) instance.

```swift
let identityView = IdentityView()
identityView.parentController = self
identityView.initComponent(identityVerificationViewModel: identityVerificationViewModel)
```

#### IdentityVerificationViewModel

The IdentityVerificationViewModel helps manage how the view interacts with Cybrid services and manipulates the view based on certain inputs. Creating it is as straightforward as this:

```swift
let identityVerificationViewModel = IdentityVerificationViewModel(
    dataProvider: CybridSession.current,
    logger: Cybrid.logger
)
```

#### Permissions

This component requires two permissions to be configured in the project plist to be able to open the camera.

| Key      | Type          | Value    |
| ------------- |:-------------------:|:----------:|
| Privacy - Camera Usage Description | String | In app permission request String |
| Privacy - Photo Library Usage Description | String | In app permission request String |

### BankAccounts

This component currently only allows you to see the connected bank accounts and a bit of detail about them with the possibility of disconnecting (deleting) the customer

To use this component, you can do so in the following ways:

1. BankAccountsViewController

To use this component, you simply need to create an instance of `BankAccountsViewController` and display it.

```swift
let bankAccountsViewController = BankAccountsViewController()
```

2. BankAccountsView

To use the component as UIView, you simply need to create the view and pass the [BankAccountsViewModel](#bank-accounts-view-model) instance.

```swift
let bankAccountsView = BankAccountsView()
bankAccountsView.parentController = self
bankAccountsView.initComponent(bankAccountsViewModel: BankAccountsViewModel)
```

#### BankAccountsViewModel

The BankAccountsViewModel helps manage how the view interacts with Cybrid services and manipulates the view based on certain inputs. Creating it is as straightforward as this:

```swift
let bankAccountsViewModel = BankAccountsViewModel(
    dataProvider: CybridSession.current,
    logger: Cybrid.logger
)
```

#### Preview

<div align="center">
  <video src="https://github.com/Cybrid-app/cybrid-sdk-ios/assets/7268597/4b4765b0-7684-45eb-ab22-0b4bbd3bdad3" controls />
</div>

### DepositAddress

This component allows you to create a deposit addres of a trading type account by showing you a QR code with the supported network, the address (with the option to copy with a button) and also create a payment code that will allow you to add a message and the amount payment.

At the moment the only trading accounts accepted are:

- BTC
- ETH
- BCH
- LTC
- USDC
- USDC_POL
- USDC_STE

To use this component, you can do so in the following ways:

1. DepositAddressViewController

To use this component, you simply need to create an instance of `DepositAddressViewController` and display it.

```swift
let depositAddressViewController = DepositAddressViewController()
```

2. DepositAddressView

To use the component as UIView, you simply need to create the view and pass the [DepositAddressViewModel](#deposit-address-view-model) instance.

```swift
let depositAddressView = DepositAddressView()
depositAddressView.parentController = self
depositAddressView.initComponent(depositAddressViewModel: DepositAddressViewModel)
```

#### DepositAddressViewModel

The DepositAddressViewModel helps manage how the view interacts with Cybrid services and manipulates the view based on certain inputs. Creating it is as straightforward as this:

```swift
let depositAddressViewModel = DepositAddressViewModel(
    dataProvider: CybridSession.current,
    logger: Cybrid.logger
)
```

#### Preview

<div align="center">
  <video src="https://github.com/Cybrid-app/cybrid-sdk-ios/assets/7268597/4b4765b0-7684-45eb-ab22-0b4bbd3bdad3" controls />
</div>

### ExternalWallets

This component allows you to see the wallets that have been added to the account, be able to see the details of each one such as the custom name that has been given, the address, tag (if it has one) and the last transfers with a little of detail; It will also allow you to add a wallet only with the custom name, address (with a button to scan QR codes for addresses), tag (if it has one).

To use this component, you can do so in the following ways:

1. ExternalWalletsViewController

To use this component, you simply need to create an instance of `ExternalWalletsViewController` and display it.

```swift
let externalWalletsViewController = ExternalWalletsViewController()
```

2. ExternalWalletsView

To use the component as UIView, you simply need to create the view and pass the [ExternalWalletsViewModel](#external-wallets-view-model) instance.

```swift
let externalWalletsView = ExternalWalletsView()
externalWalletsView.parentController = self
externalWalletsView.initComponent(externalWalletsViewModel: ExternalWalletsViewModel)
```

#### ExternalWalletsViewModel

The ExternalWalletsViewModel helps manage how the view interacts with Cybrid services and manipulates the view based on certain inputs. Creating it is as straightforward as this:

```swift
let externalWalletsViewModel = ExternalWalletsViewModel(
    dataProvider: CybridSession.current,
    logger: Cybrid.logger
)
```

#### Permissions

This component requires two permissions to be configured in the project plist to be able to open the camera.

| Key      | Type          | Value    |
| ------------- |:-------------------:|:----------:|
| Privacy - Camera Usage Description | String | In app permission request String |
| Privacy - Photo Library Usage Description | String | In app permission request String |

#### Preview

<div align="center">
  <video src="https://github.com/Cybrid-app/cybrid-sdk-ios/assets/7268597/4b4765b0-7684-45eb-ab22-0b4bbd3bdad3" controls />
</div>

### CryptoTransfer

This component allows you to make a withdrawal to one of your portfolios previously added to the customer's account, allowing you to choose the trading asset to make the withdrawal; It will always show the customer a notice to confirm the withdrawal with more information and the commissions that are generated when making the transfer.

To use this component, you can do so in the following ways:

1. CryptoTransferViewController

To use this component, you simply need to create an instance of `CryptoTransferViewController` and display it.

```swift
let cryptoTransferViewController = CryptoTransferViewController()
```

2. CryptoTransferView

To use the component as UIView, you simply need to create the view and pass the [CryptoTransferViewModel](#crypto-transfer-view-model) instance.

```swift
let cryptoTransferView = CryptoTransferView()
cryptoTransferView.parentController = self
cryptoTransferView.initComponent(cryptoTransferViewModel: CryptoTransferViewModel)
```

#### CryptoTransferViewModel

The CryptoTransferViewModel helps manage how the view interacts with Cybrid services and manipulates the view based on certain inputs. Creating it is as straightforward as this:

```swift
let cryptoTransferViewModel = CryptoTransferViewModel(
    dataProvider: CybridSession.current,
    logger: Cybrid.logger
)
```

#### Preview

<div align="center">
  <video src="https://github.com/Cybrid-app/cybrid-sdk-ios/assets/7268597/4b4765b0-7684-45eb-ab22-0b4bbd3bdad3" controls />
</div>

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
