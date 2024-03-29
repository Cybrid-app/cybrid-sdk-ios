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
    let viewController = TradeViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }

  @IBAction func didTapTransfersButton(_ sender: Any) {
    let viewController = TransferViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }

  @IBAction func didTapAccountsButton(_ sender: Any) {
    let viewController = AccountsViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }

  @IBAction func didTapKYCButton(_ sender: Any) {
    let viewController = IdentityVerificationViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }

  @IBAction func didTapBankAccountsButton(_ sender: Any) {
    let viewController = BankAccountsViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }

  @IBAction func didTapExternalWalletsButton(_ sender: Any) {
    let viewController = ExternalWalletsViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  @IBAction func didTapCryptoTrasnferButton(_ sender: Any) {
    let viewController = CryptoTransferViewController()
    navigationController?.pushViewController(viewController, animated: true)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
}
