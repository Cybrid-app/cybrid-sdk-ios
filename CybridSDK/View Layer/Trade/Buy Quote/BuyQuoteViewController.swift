//
//  BuyQuoteViewController.swift
//  CybridSDK
//
//  Created by Cybrid on 23/06/22.
//

import UIKit

final class BuyQuoteViewController: UIViewController {

  private var viewModel: BuyQuoteViewModel
  private let theme: Theme
  private let localizer: Localizer

  private lazy var cryptoPickerIcon = URLImageView(url: nil)
  private lazy var cryptoPickerTextField: CYBTextField = {
    let textField = CYBTextField(style: .rounded, icon: .urlImage(""), theme: theme)
    textField.placeholder = localizer.localize(with: CybridLocalizationKey.trade(.buy(.selectCurrency)))

    return textField
  }()

  private lazy var cryptoPickerView = UIPickerView()

  private lazy var contentStackView: UIStackView = {
    let spacerView = UIView()
    spacerView.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
    let stackView = UIStackView(arrangedSubviews: [
      currencyLabel,
      cryptoPickerTextField,
      amountLabel,
      amountTextField,
      cryptoExchangeStackView,
      buttonContainer,
      spacerView
    ])
    stackView.alignment = .fill
    stackView.axis = .vertical
    stackView.spacing = Constants.ContentStackView.itemSpacing
    stackView.distribution = .fill
    stackView.setCustomSpacing(Constants.PickerView.bottomSpacing, after: cryptoPickerTextField)
    stackView.setCustomSpacing(Constants.Button.topSpacing, after: cryptoExchangeStackView)

    return stackView
  }()

  private lazy var amountTextField: CYBTextField = {
    let textField = CYBTextField(style: .plain, icon: .text(""), theme: theme)
    textField.placeholder = "0.0"
    textField.keyboardType = .decimalPad
    textField.delegate = viewModel
    textField.rightView = switchButton
    textField.rightViewMode = .always

    return textField

  }()

  private lazy var switchButton: UIButton = {
    let image = UIImage(named: "switchIcon", in: Bundle(for: Self.self), with: nil)
    let button = UIButton(type: .custom)
    button.setImage(image, for: .normal)
    button.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
    return button
  }()

  private lazy var currencyLabel: UILabel = {
    let label = UILabel.makeLabel(with: .caption, { _ in })
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.buy(.currency)))
    return label
  }()

  private lazy var amountLabel: UILabel = {
    let label = UILabel.makeLabel(with: .caption, { _ in })
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.buy(.amount)))
    return label
  }()

  private lazy var cryptoExchangeStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      flagIcon,
      cryptoExchangePriceLabel
    ])
    stackView.spacing = Constants.ContentStackView.itemSpacing
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fill
    return stackView
  }()

  private lazy var flagIcon = URLImageView(url: nil)

  private lazy var cryptoExchangePriceLabel: UILabel = {
    let label = UILabel.makeLabel(with: .caption, { _ in })
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.buy(.amount)))
    return label
  }()

  private lazy var buyButton: CYBButton = {
    let button = CYBButton(theme: theme)
    button.setTitle(localizer.localize(with: CybridLocalizationKey.trade(.buy(.cta))), for: .normal)
    button.isEnabled = false

    return button
  }()

  private lazy var buttonContainer = UIView()

  init(viewModel: BuyQuoteViewModel, theme: Theme, localizer: Localizer) {
    self.viewModel = viewModel
    self.theme = theme
    self.localizer = localizer

    super.init(nibName: nil, bundle: nil)
  }

  @available(iOS, deprecated: 10, message: "You should never use this init method.")
  required init?(coder: NSCoder) {
    assertionFailure("init(coder:) should never be used")
    return nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
    bindViewModel()
  }

  private func setupViews() {
    view.backgroundColor = .none
    setupContentStackView()
    setupPickerView()
    setupFlagIcon()
    setupSwitchButton()
    setupButton()
  }

  private func setupContentStackView() {
    view.addSubview(contentStackView)
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    contentStackView.constraintEdges(to: view, insets: Constants.ContentStackView.insets)
  }

  private func setupPickerView() {
    cryptoPickerView.delegate = viewModel
    cryptoPickerView.dataSource = viewModel
    cryptoPickerTextField.inputView = cryptoPickerView
  }

  private func setupFlagIcon() {
    flagIcon.constraint(attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: Constants.FlagIcon.size.width)
    flagIcon.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: Constants.FlagIcon.size.height)
    cryptoExchangeStackView.constraint(attribute: .height,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .notAnAttribute,
                                       constant: Constants.FlagIcon.size.height)
  }

  private func setupSwitchButton() {
    switchButton.constraint(attribute: .height,
                            relatedBy: .equal,
                            toItem: nil,
                            attribute: .notAnAttribute,
                            constant: Constants.SwitchButton.size.height)
    switchButton.constraint(attribute: .width,
                            relatedBy: .equal,
                            toItem: nil,
                            attribute: .notAnAttribute,
                            constant: Constants.SwitchButton.size.width)
  }

  private func setupButton() {
    buttonContainer.addSubview(buyButton)

    buyButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    buyButton.constraint(attribute: .top, relatedBy: .equal, toItem: buttonContainer, attribute: .top)
    buyButton.constraint(attribute: .bottom, relatedBy: .equal, toItem: buttonContainer, attribute: .bottom)
    buyButton.constraint(attribute: .trailing, relatedBy: .equal, toItem: buttonContainer, attribute: .trailing)
    buyButton.constraint(attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: buttonContainer, attribute: .leading)
    buyButton.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: Constants.Button.height)
  }

  @objc
  private func toggleSwitch() {
    viewModel.switchConversion()
  }

  private func bindViewModel() {
    viewModel.amountText.bind { [weak self] newAmountText in
      self?.amountTextField.text = newAmountText
    }
    viewModel.cryptoCurrency.bind { [weak self] newCurrencySelection in
      self?.cryptoPickerTextField.resignFirstResponder()
      guard let selection = newCurrencySelection else {
        self?.cryptoPickerTextField.text = nil
        self?.cryptoPickerTextField.updateIcon(nil)
        return
      }
      self?.cryptoPickerTextField.text = selection.asset.name + " " + selection.asset.code
      self?.cryptoPickerTextField.updateIcon(.urlImage(selection.imageURL))
      self?.amountTextField.placeholder = CybridCurrencyFormatter.formatInputNumber(BigDecimal(0, precision: selection.asset.decimals))
      self?.amountTextField.updateIcon(.text(selection.asset.code))
      self?.updateIcons(shouldInputCrypto: self?.viewModel.shouldInputCrypto.value ?? true)
    }
    viewModel.displayAmount.bind { [weak self] newAmount in
      self?.cryptoExchangePriceLabel.text = newAmount ?? ""
    }
    viewModel.shouldInputCrypto.bind { [weak self] shouldInputCrypto in
      self?.updateIcons(shouldInputCrypto: shouldInputCrypto)
    }
    viewModel.ctaButtonEnabled.bind { [weak self] isButtonEnabled in
      self?.buyButton.isEnabled = isButtonEnabled
    }
    viewModel.fetchPriceList()
  }

  private func updateIcons(shouldInputCrypto: Bool) {
    if shouldInputCrypto, let cryptoSelection = viewModel.cryptoCurrency.value {
      amountTextField.updateIcon(.text(cryptoSelection.asset.code))
      flagIcon.isHidden = false
      flagIcon.setURL(Cybrid.getCryptoIconURLString(with: viewModel.fiatCurrency.asset.code))
    } else {
      let fiatSelection = viewModel.fiatCurrency
      amountTextField.updateIcon(.text(fiatSelection.asset.code))
      flagIcon.isHidden = true
    }
  }
}

extension BuyQuoteViewController {
  enum Constants {
    enum ContentStackView {
      static let insets = UIEdgeInsets(top: UIConstants.minimumTargetSize,
                                       left: UIConstants.spacingXl2,
                                       bottom: UIConstants.spacingXl2,
                                       right: UIConstants.spacingXl2)
      static let itemSpacing: CGFloat = UIConstants.spacingXl // 12.0
    }

    enum FlagIcon {
      static let size: CGSize = CGSize(width: 28, height: UIConstants.sizeMd)
    }

    enum Button {
      static let topSpacing: CGFloat = 20
      static let height: CGFloat = UIConstants.sizeLg // 48
    }

    enum PickerView {
      static let bottomSpacing: CGFloat = 34
    }

    enum SwitchButton {
      static let size: CGSize = CGSize(width: UIConstants.sizeMd, height: UIConstants.sizeMd)
    }
  }
}
