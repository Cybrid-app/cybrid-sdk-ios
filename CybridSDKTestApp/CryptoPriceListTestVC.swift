//
//  CryptoPriceListViewController.swift
//  CybridSDK
//
//  Created by Cybrid on 20/06/22.
//

import UIKit
import CybridSDK

final class CryptoPriceListTestVC: UIViewController {

  lazy var tableView = CryptoPriceListView(navigationController: navigationController)

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(iOS, deprecated: 10, message: "You should never use this init method.")
  required init?(coder: NSCoder) {
    assertionFailure("init(coder:) should never be used")
    return nil
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
  }

  private func setupViews() {
    setupNavBar()
    setupTabBar()
    setupMainView()
    setupTableView()
  }

  private func setupMainView() {
    view.backgroundColor = .white
  }

  private func setupTableView() {
    tableView.embed(in: self)
  }

  private func setupNavBar() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
  }

  private func setupTabBar() {
    if #available(iOS 15.0, *) {
      let appearance = UITabBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.backgroundColor = .white
      tabBarController?.tabBar.standardAppearance = appearance
      tabBarController?.tabBar.scrollEdgeAppearance = appearance
    }
  }

}
