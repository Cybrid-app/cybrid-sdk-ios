# cybrid-sdk-ios

iOS SDK Library and Demo App for Cybrid API.

[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS-Green?style=flat-square)
![CircleCI](https://circleci.com/gh/Cybrid-app/cybrid-sdk-ios.svg?style=svg)
[![codecov](https://codecov.io/gh/Cybrid-app/cybrid-sdk-ios/branch/main/graph/badge.svg?token=LTJJFQJWEA)](https://codecov.io/gh/Cybrid-app/cybrid-sdk-ios)

- [Installation](#installation)
- [Contribution Guidelines](#contribution)

## Installation

### CocoaPods

Add our podspec repo to your App's Podfile:

`source 'git@github.com:Cybrid-app/cybrid-podspecs.git'`

An then install the depenedencies:

`pod install CybridSDK`

## Usage

### 1. Setup SDK
In your AppDelegate, call `Cybrid.setup` method to customize our SDK.
```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  let guid = Bundle.main.object(forInfoDictionaryKey: "CybridCustomerGUID") as? String
  Cybrid.setup(authenticator: cryptoAuthenticator,
               customerGUID: guid ?? "",
               fiat: .usd,
               logger: logger)
  return true
}
```

### 2. Implement CybridAuthenticator in order to inject Bearer token to SDK

```
import CybridSDK
import Foundation

class CryptoAuthenticator: CybridAuthenticator {

  private let session: URLSession

  init(session: URLSession) {
    self.session = session
  }

  func makeCybridAuthToken(completion: @escaping (Result<CybridBearer, Error>) -> Void) {
    // 1. Setup a call to your own API to retrieve Cybrid's JWT
    guard let url = URL(string: "https://id.demo.cybrid.app/oauth/token") else {
      completion(.failure(CybridError.authenticationError))
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // 2. Pass parameters if needed
    let parameters: [String: Any] = [ ... ]
    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    } catch let error {
      completion(.failure(error))
      return
    }
    
    // 3. Make request
    session.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }

      guard
        let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode),
        let responseData = data
      else {
        completion(.failure(CybridError.serviceError))
        return
      }

      do {
        if
          let jsonResponse = try JSONSerialization.jsonObject(with: responseData) as? [String: Any],
          let bearer = jsonResponse["access_token"] as? String
        {
        // 4. Call completion success with Access Token
          completion(.success(bearer))
          return
        } else {
          completion(.failure(CybridError.serviceError))
          return
        }
      } catch let error {
        completion(.failure(error))
        return
      }
    }.resume()
  }
}
```

### 3. Use our Components:

- Price List View:

This component allow you to display the latest prices of the supported assets:

```
let tableView = CryptoPriceListView(navigationController: navigationController)
```

- Trade Component: You can navigate to this component from Price List component.

- Accounts Component:

This component allow you to display the available accounts and get the detail of each one.

To show the component you only have to present the ViewController:

```
let accounts = AccountsViewController()
```

