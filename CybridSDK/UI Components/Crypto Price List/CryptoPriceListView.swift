//
//  CryptoPriceListView.swift
//  CybridSDK
//
//  Created by Cybrid on 20/06/22.
//

import UIKit

public class CryptoPriceListView: UITableView {

  private var viewModel: CryptoPriceViewModel
  public init() {
    viewModel = CryptoPriceViewModel()
    super.init(frame: .zero, style: .plain)

    setupView()
  }

  @available(iOS, deprecated: 10, message: "You should never use this init method.")
  required init?(coder: NSCoder) {
    assertionFailure("init(coder:) should never be used")
    return nil
  }

  private func setupView() {
    self.delegate = viewModel
    self.dataSource = viewModel
    self.register(CryptoPriceTableViewCell.self, forCellReuseIdentifier: CryptoPriceTableViewCell.reuseIdentifier)
    self.rowHeight = 44.0
    self.estimatedRowHeight = 44.0
    self.translatesAutoresizingMaskIntoConstraints = false
  }

  public func embed(in viewController: UIViewController) {
    willMove(toSuperview: viewController.view)
    viewController.view.addSubview(self)
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: self,
                         attribute: .top,
                         relatedBy: .equal,
                         toItem: viewController.view,
                         attribute: .topMargin,
                         multiplier: 1.0,
                         constant: 0),
      NSLayoutConstraint(item: self,
                         attribute: .bottom,
                         relatedBy: .equal,
                         toItem: viewController.view,
                         attribute: .bottomMargin,
                         multiplier: 1.0,
                         constant: 0),
      NSLayoutConstraint(item: self,
                         attribute: .leading,
                         relatedBy: .equal,
                         toItem: viewController.view,
                         attribute: .leading,
                         multiplier: 1.0,
                         constant: 0),
      NSLayoutConstraint(item: self,
                         attribute: .trailing,
                         relatedBy: .equal,
                         toItem: viewController.view,
                         attribute: .trailing,
                         multiplier: 1.0,
                         constant: 0)
    ])
    layoutSubviews()
  }

  public func startLiveUpdate() {
    viewModel.fetchPriceList()
  }
}
