//
//  TradeViewController.swift
//  CybridSDK
//
//  Created by Cybrid on 22/06/22.
//

import CybridApiBankSwift
import UIKit

public final class TradeViewController: UIViewController {

  private let theme: Theme
  private let localizer: Localizer

  private lazy var segments = [
    localizer.localize(with: CybridLocalizationKey.trade(.buy(.title))),
    localizer.localize(with: CybridLocalizationKey.trade(.sell(.title)))
  ]

  lazy var segmentControl: UISegmentedControl = {
    let view = UISegmentedControl(items: segments)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.selectedSegmentIndex = 0
    view.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    return view
  }()

  lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  lazy var buyViewController = BuyQuoteViewController(
    viewModel: BuyQuoteViewModel(
      dataProvider: CybridSession.current,
      fiatAsset: .usd
    ),
    theme: theme,
    localizer: localizer
  )

  lazy var sellViewController = SellQuoteViewController()

  public init() {
    self.theme = Cybrid.theme
    self.localizer = CybridLocalizer()

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
    view.backgroundColor = .systemBackground
    buyViewController.willMove(toParent: self)
    sellViewController.willMove(toParent: self)
    addChild(buyViewController)
    addChild(sellViewController)
    view.addSubview(segmentControl)
    view.addSubview(containerView)
    setupSegmentControl()
    setupContainerView()
  }

  private func setupSegmentControl() {
    segmentControl.constraint(attribute: .top,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .topMargin,
                              constant: 30)
    segmentControl.constraint(attribute: .leading,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .leading,
                              constant: 18)
    segmentControl.constraint(attribute: .trailing,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .trailing,
                              constant: -18)
  }

  private func setupContainerView() {
    containerView.constraint(attribute: .top,
                             relatedBy: .equal,
                             toItem: segmentControl,
                             attribute: .bottom,
                             constant: 8)
    containerView.constraint(attribute: .bottom,
                             relatedBy: .equal,
                             toItem: view,
                             attribute: .bottom,
                             constant: -8)
    containerView.constraint(attribute: .leading,
                             relatedBy: .equal,
                             toItem: view,
                             attribute: .leading,
                             constant: 0)
    containerView.constraint(attribute: .trailing,
                             relatedBy: .equal,
                             toItem: view,
                             attribute: .trailing,
                             constant: 0)
    containerView.addSubview(buyViewController.view)
    containerView.addSubview(sellViewController.view)
    buyViewController.view.constraintEdges(to: containerView)
    sellViewController.view.constraintEdges(to: containerView)
    switchViews(toIndex: 0)
  }

  private func switchViews(toIndex index: Int) {
    switch index {
    case 0:
      buyViewController.view.isHidden = false
      buyViewController.view.isUserInteractionEnabled = true
      sellViewController.view.isHidden = true
      sellViewController.view.isUserInteractionEnabled = false
    case 1:
      buyViewController.view.isHidden = true
      buyViewController.view.isUserInteractionEnabled = false
      sellViewController.view.isHidden = false
      sellViewController.view.isUserInteractionEnabled = true
    default:
      return
    }
  }
  @objc
  func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    switchViews(toIndex: sender.selectedSegmentIndex)
  }
}
