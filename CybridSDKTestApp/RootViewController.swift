//
//  ViewController.swift
//  CybridSDKTestApp
//
//  Created by Cybrid on 17/06/22.
//

import UIKit

class RootViewController: UIViewController {

  

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func didTapCryptoListButton(_ sender: Any) {
    let viewController = CryptoPriceListTestVC()
    navigationController?.pushViewController(viewController, animated: true)
  }
}
