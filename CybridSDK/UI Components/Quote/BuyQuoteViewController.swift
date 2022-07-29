//
//  BuyQuoteViewController.swift
//  CybridSDK
//
//  Created by Cybrid on 23/06/22.
//

import UIKit

final class BuyQuoteViewController: UIViewController {

  let cryptoItems = ["Bitcoin", "Etherium", "DogeCoin"]

  private lazy var cryptoPickerTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Select Cryptocurrency"
    textField.backgroundColor = UIColor(red: 0.929, green: 0.929, blue: 0.929, alpha: 0.8)
    textField.layer.cornerRadius = 10
    textField.textColor = .black
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: textField.frame.height))
    textField.leftViewMode = .always

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
      amountStackView,
      cryptoExchangePriceLabel,
      separatorLine,
      buttonContainer,
      spacerView
    ])
    stackView.alignment = .fill
    stackView.axis = .vertical
    stackView.spacing = Constants.ContentStackView.itemSpacing
    stackView.distribution = .fill
    stackView.setCustomSpacing(13.0, after: currencyLabel)
    stackView.setCustomSpacing(34.0, after: cryptoPickerTextField)
    stackView.setCustomSpacing(16.0, after: amountLabel)
    stackView.setCustomSpacing(14.0, after: amountStackView)
    stackView.setCustomSpacing(19.0, after: cryptoExchangePriceLabel)

    return stackView
  }()

  private lazy var amountStackView: UIStackView = {
    let spacerView = UIView()
    spacerView.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
    let stackView = UIStackView(arrangedSubviews: [
      cryptoAcronymusLabel,
      quoteTextField,
      iconImage
    ])
    stackView.spacing = Constants.ContentStackView.itemSpacing
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fill
    return stackView
  }()

  private lazy var quoteTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Placeholder"
    textField.borderStyle = UITextField.BorderStyle.none
    textField.backgroundColor = UIColor.white
    textField.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
    textField.keyboardType = .numberPad

    return textField

  }()

  private var iconImage = URLImageView(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/YouTube_social_white_squircle.svg/1200px-YouTube_social_white_squircle.svg.png"))

  private lazy var currencyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.baselineAdjustment = .alignCenters
    label.sizeToFit()
    label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
    label.font = label.font.withSize(12)
//    label.font = FormatStyle.headerSmall.font
//    label.textColor = FormatStyle.headerSmall.textColor
    label.text = "Currency"
    return label
  }()

  private lazy var amountLabel: UILabel = {
    let label = UILabel()
    label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.baselineAdjustment = .alignCenters
    label.sizeToFit()
    label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
    label.font = label.font.withSize(12)
//    label.font = FormatStyle.headerSmall.font
//    label.textColor = FormatStyle.headerSmall.textColor
    label.text = "Amount"
    return label
  }()

  private lazy var cryptoAcronymusLabel: UILabel = {
    let label = UILabel()
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.baselineAdjustment = .alignCenters
    label.sizeToFit()
    label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
//    label.font = FormatStyle.headerSmall.font
//    label.textColor = FormatStyle.headerSmall.textColor
    label.text = "BTC"
    return label
  }()

  private lazy var cryptoExchangePriceLabel: UILabel = {
    let label = UILabel()
    label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.baselineAdjustment = .alignCenters
    label.sizeToFit()
    label.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
//    label.font = FormatStyle.headerSmall.font
//    label.textColor = FormatStyle.headerSmall.textColor
    label.text = "$500 CAD"
    label.font = label.font.withSize(13)
    return label
  }()

  private lazy var separatorLine: UIImageView = {
    let separator = UIImageView.init(frame: CGRect(x: 8, y: 64, width: cell.frame.width - 16, height: 2))
    separator.backgroundColor = .blue
    return separator
  }()

  private lazy var buyButton: CYBButton = {
    let button = CYBButton()
    button.setTitle("Buy", for: .normal)
    button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.18)
    button.layer.cornerRadius = 10

    return button
  }()

  private lazy var buttonContainer = UIView()

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

    setupViews()
  }

  private func setupViews() {
    view.backgroundColor = .none
    setupContentStackView()
    setupPickerView()
    setupIcon()
    setupButton()
  }

  private func setupContentStackView() {
    view.addSubview(contentStackView)
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    contentStackView.constraint(attribute: .top,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .top,
                                constant: 58)
    contentStackView.constraint(attribute: .leading,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .leading,
                                constant: 16)
    contentStackView.constraint(attribute: .trailing,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .trailing,
                                constant: -16)
    contentStackView.constraint(attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .bottom,
                                constant: 0)
  }

  private func setupPickerView() {
    cryptoPickerView.delegate = self
    cryptoPickerView.dataSource = self
    cryptoPickerTextField.inputView = cryptoPickerView
    cryptoPickerTextField.constraint(attribute: .height,
                                     relatedBy: .equal,
                                     toItem: nil,
                                     attribute: .notAnAttribute,
                                     multiplier: 1.0,
                                     constant: 46)
  }

  private func setupIcon() {
    iconImage.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: Constants.Icon.size.height)
    iconImage.constraint(attribute: .width,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: Constants.Icon.size.width)
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
                         constant: 48)

  }
}
extension BuyQuoteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return cryptoItems.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return cryptoItems[row]
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    cryptoPickerTextField.text = cryptoItems[row]
    cryptoPickerTextField.resignFirstResponder()
  }
}
extension BuyQuoteViewController {
  enum Constants {
    enum ContentStackView {
      static let itemSpacing: CGFloat = 10
      static let horizontalMargin: CGFloat = 16
      static let verticalMargin: CGFloat = 10
    }
    enum Icon {
      static let size = CGSize(width: 24, height: 24)
    }
  }
}
