//
//  SellQuoteViewController.swift
//  CybridSDK
//
//  Created by Cybrid on 23/06/22.
//

import UIKit

class SellQuoteViewController: UIViewController {

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(iOS, deprecated: 10, message: "You should never use this init method.")
  required init?(coder: NSCoder) {
    assertionFailure("init(coder:) should never be used")
    return nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .green
  }
}
