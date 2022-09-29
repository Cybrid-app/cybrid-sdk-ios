//
//  ViewController.swift
//  CybridSDKTestApp
//
//  Created by Cybrid on 17/06/22.
//

import UIKit
import CybridSDK

class RootViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func didTapCryptoListButton(_ sender: Any) {
    let viewController = CryptoPriceListTestVC()
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  @IBAction func didTapAccountsButton(_ sender: Any) {
    let viewController = AccountsViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }
}
