//
//  CryptoPriceListView.swift
//  CybridSDK
//
//  Created by Cybrid on 20/06/22.
//

import CybridApiBankSwift
import UIKit

public class ListPricesView: UITableView {

  private var viewModel: ListPricesViewModel!
  weak var itemDelegate: ListPricesItemDelegate?
  private let theme: Theme

  public init(theme: Theme? = nil) {

    self.theme = theme ?? Cybrid.theme
    super.init(frame: .zero, style: .plain)
    self.viewModel = ListPricesViewModel(cellProvider: self,
                                          dataProvider: CybridSession.current,
                                          logger: Cybrid.logger)
    setupView()
  }

  @available(iOS, deprecated: 10, message: "You should never use this init method.")
  required init?(coder: NSCoder) {

    assertionFailure("init(coder:) should never be used")
    return nil
  }

  /// This method will detect when the Price List View is added or removed from the View Hierarchy.
  override public func didMoveToWindow() {

    super.didMoveToWindow()
    if window == nil {
      /// If the ListView is been removed from the View Hierarchy we want to stop receiving live updates
      stopLiveUpdates()
    } else {
      /// If the ListView is been added to the View Hierarchy we want to start receiving live updates
      startLiveUpdates()
    }
  }

  private func setupView() {

    delegate = viewModel
    dataSource = viewModel
    register(CryptoPriceTableViewCell.self, forCellReuseIdentifier: CryptoPriceTableViewCell.reuseIdentifier)
    rowHeight = Constants.rowHeight
    estimatedRowHeight = Constants.rowHeight
    translatesAutoresizingMaskIntoConstraints = false
    allowsSelection = true
  }

  private func startLiveUpdates() {

    viewModel.filteredCryptoPriceList.bind { _ in
      self.reloadData()
    }

    viewModel.selectedAsset.bind { [itemDelegate, viewModel] selectedAsset in
      if let asset = selectedAsset {
        if itemDelegate != nil {
          itemDelegate?.onSelected(
            asset: asset,
            pairAsset: (viewModel?.selectPairAsset.value)!)
        }
        viewModel?.selectedAsset.value = nil
        viewModel?.selectPairAsset.value = nil
      }
    }
    viewModel.fetchPriceList()
  }

  private func stopLiveUpdates() {
    viewModel.stopLiveUpdates()
  }

  public func embed(in view: UIView) {

    willMove(toSuperview: view)
    view.addSubview(self)
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: self,
                         attribute: .top,
                         relatedBy: .equal,
                         toItem: view,
                         attribute: .topMargin,
                         multiplier: 1.0,
                         constant: 0),
      NSLayoutConstraint(item: self,
                         attribute: .bottom,
                         relatedBy: .equal,
                         toItem: view,
                         attribute: .bottomMargin,
                         multiplier: 1.0,
                         constant: 0),
      NSLayoutConstraint(item: self,
                         attribute: .leading,
                         relatedBy: .equal,
                         toItem: view,
                         attribute: .leading,
                         multiplier: 1.0,
                         constant: 0),
      NSLayoutConstraint(item: self,
                         attribute: .trailing,
                         relatedBy: .equal,
                         toItem: view,
                         attribute: .trailing,
                         multiplier: 1.0,
                         constant: 0)
    ])
    layoutSubviews()
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
}

// MARK: - CryptoPriceViewProvider

extension ListPricesView: ListPricesViewProvider {

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData dataModel: CryptoPriceModel) -> UITableViewCell {

    guard
      let cell = tableView.dequeueReusableCell(
        withIdentifier: CryptoPriceTableViewCell.reuseIdentifier, for: indexPath
      ) as? CryptoPriceTableViewCell
    else {
      return UITableViewCell()
    }
    cell.customize(dataModel: dataModel)
    return cell
  }
}

// MARK: - Constants

fileprivate extension ListPricesView {

  enum Constants {

    static let rowHeight: CGFloat = UIConstants.minimumTargetSize
  }
}
