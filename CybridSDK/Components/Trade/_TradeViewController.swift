//
//  TradeViewController.swift
//  CybridSDK
//
//  Created by Cybrid on 22/06/22.
//

import CybridApiBankSwift
import UIKit

public final class _TradeViewController: UIViewController {
  // MARK: Private properties

  private let theme: Theme
  private let localizer: Localizer
  private let logger: CybridLogger?
  private var viewModel: _TradeViewModel
  private let segments = [_TradeType.buy, _TradeType.sell]

  // MARK: UI Properties
  private lazy var cryptoExchangePriceLabel: UILabel = {
    let label = UILabel.makeLabel(.caption, { _ in })
    label.accessibilityIdentifier = "cryptoExchangePriceLabel"
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.buy(.amount)))
    return label
  }()

  private var tradeConfirmationModalView: TradeConfirmationModalView?
  private var modalViewController: CybridModalViewController?

  public init(selectedCrypto: AssetBankModel) {
    self.theme = Cybrid.theme
    self.localizer = CybridLocalizer()
    self.logger = Cybrid.logger
    self.viewModel = _TradeViewModel(selectedCrypto: selectedCrypto,
                                    dataProvider: CybridSession.current,
                                    logger: logger)

    super.init(nibName: nil, bundle: nil)
  }

  init(viewModel: _TradeViewModel) {
    self.theme = Cybrid.theme
    self.localizer = CybridLocalizer()
    self.logger = Cybrid.logger
    self.viewModel = viewModel

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

  override public func viewDidDisappear(_ animated: Bool) {
    viewModel.stopPriceUpdate()
    super.viewDidDisappear(animated)
  }

  private func dismissModal() {
    modalViewController?.dismiss(animated: true)
  }

  private func confirmOperation() {
    modalViewController?.replaceContent(
      LoadingModalView(
        message: localizer.localize(with: CybridLocalizationKey.trade(.loadingModal(.processingMessage)))
      )
    )
    viewModel.confirmOperation()
  }

  private func showConfirmationModal(data: TradeConfirmationModalView.DataModel) {
    if tradeConfirmationModalView == nil {
      tradeConfirmationModalView = TradeConfirmationModalView(
        theme: theme,
        localizer: localizer,
        dataModel: data,
        onCancel: { [weak self] in
          self?.dismissModal()
          self?.viewModel.stopQuoteUpdateIfNeeded()
        }, onConfirm: { [weak self] in
          self?.confirmOperation()
        }
      )
    } else {
      tradeConfirmationModalView?.updateData(data)
    }
    if modalViewController == nil, let view = tradeConfirmationModalView {
      modalViewController = CybridModalViewController(theme: theme, view)
    }
    if !(modalViewController?.contentView === tradeConfirmationModalView), let view = tradeConfirmationModalView {
      modalViewController?.replaceContent(view)
    }
    if presentedViewController == nil {
      modalViewController?.present()
    } else if let presentedVC = presentedViewController, presentedVC != modalViewController {
      presentedVC.dismiss(animated: true) { [weak modalViewController] in
        modalViewController?.present()
      }
    }
  }

  private func showSuccessModal(data: TradeSuccessModalView.DataModel) {
    let successModal = TradeSuccessModalView(
      theme: theme,
      localizer: localizer,
      dataModel: data,
      onBuyMoreTap: { [weak self] in
        self?.dismissModal()
      }
    )

    modalViewController?.replaceContent(successModal)
  }
}

// MARK: - UI Setup

extension _TradeViewController {
  func setupViews() {
    view.backgroundColor = theme.colorTheme.primaryBackgroundColor
  }
}

// MARK: - Data Bindings

extension _TradeViewController {

  func updateConfirmationModalData() {
    viewModel.createQuote()
  }
}

// MARK: - Constants

extension _TradeViewController {
  enum Constants {
    enum ContentStackView {
      static let insets = UIEdgeInsets(top: UIConstants.spacingXl3, // 24
                                       left: UIConstants.spacingXl2, // 16
                                       bottom: UIConstants.spacingXl2, // 16
                                       right: UIConstants.spacingXl2) // 16
      static let itemSpacing: CGFloat = UIConstants.spacingXl // 12.0
    }

    enum SegmentControl {
      static let bottomSpacing = UIConstants.minimumTargetSize
    }

    enum FlagIcon {
      static let size = CGSize(width: 28, height: UIConstants.sizeMd)
    }

    enum Button {
      static let topSpacing: CGFloat = 20
      static let height: CGFloat = UIConstants.sizeLg // 48
    }

    enum PickerView {
      static let bottomSpacing: CGFloat = 34
    }

    enum SwitchButton {
      static let size = CGSize(width: UIConstants.sizeMd, height: UIConstants.sizeMd)
    }
  }
}
