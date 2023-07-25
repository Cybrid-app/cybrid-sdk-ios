//
//  PaymentModal.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 22/07/23.
//

import UIKit

class PaymentModal: UIModal {

    private let localizer = CybridLocalizer()
    private var accountBalance: BalanceUIModel
    private var onConfirm: ((String, String) -> Void)?

    let amountInput = UITextField()
    let messageInput = UITextField()

    init(accountBalance: BalanceUIModel, onConfirm: ((String, String) -> Void)?) {

        self.accountBalance = accountBalance
        self.onConfirm = onConfirm
        super.init(height: UIValues.modalSize)
        setupViews()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

        assertionFailure("init(coder:) should never be used")
        return nil
    }

    private func setupViews() {

        // -- Title
        let assetCode = self.accountBalance.asset?.code ?? ""
        let depositTitle = UILabel()
        depositTitle.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        depositTitle.textAlignment = .left
        depositTitle.textColor = UIColor.black
        depositTitle.text = "Deposit details for \(assetCode)"
        containerView.addSubview(depositTitle)
        depositTitle.constraintSafeTop(containerView, margin: 10)
        depositTitle.constraintLeft(containerView, margin: 20)
        depositTitle.constraintRight(containerView, margin: 20)
        depositTitle.constraintHeight(23)

        // -- Amount Title
        let amountTitle = UILabel()
        amountTitle.font = UIFont.systemFont(ofSize: 13, weight: .light)
        amountTitle.textAlignment = .left
        amountTitle.textColor = UIColor(hex: "#818181")
        amountTitle.text = "Amount of \(assetCode)"
        containerView.addSubview(amountTitle)
        amountTitle.below(depositTitle, top: 25)
        amountTitle.constraintLeft(containerView, margin: 20)
        amountTitle.constraintRight(containerView, margin: 20)
        amountTitle.constraintHeight(14)

        // -- Amount Input
        amountInput.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        amountInput.textAlignment = .left
        amountInput.textColor = UIColor.black
        amountInput.placeholder = "0.0"
        containerView.addSubview(amountInput)
        amountInput.below(amountTitle, top: 10)
        amountInput.constraintLeft(containerView, margin: 20)
        amountInput.constraintRight(containerView, margin: 20)
        amountInput.constraintHeight(16)

        // -- Message Title
        let messageTitle = UILabel()
        messageTitle.font = UIFont.systemFont(ofSize: 13, weight: .light)
        messageTitle.textAlignment = .left
        messageTitle.textColor = UIColor(hex: "#818181")
        messageTitle.text = "Message for transaction"
        containerView.addSubview(messageTitle)
        messageTitle.below(amountInput, top: 25)
        messageTitle.constraintLeft(containerView, margin: 20)
        messageTitle.constraintRight(containerView, margin: 20)
        messageTitle.constraintHeight(14)

        // -- Amount Input
        messageInput.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        messageInput.textAlignment = .left
        messageInput.textColor = UIColor.black
        messageInput.placeholder = "Optional message"
        containerView.addSubview(messageInput)
        messageInput.below(messageTitle, top: 10)
        messageInput.constraintLeft(containerView, margin: 20)
        messageInput.constraintRight(containerView, margin: 20)
        messageInput.constraintHeight(40)

        // -- Payment Button
        let generateNewQRButton = CYBButton(
            title: "Generate",
            action: { [self] in
                let amount = self.amountInput.text!
                let message = self.messageInput.text!
                if !amount.isEmpty {
                    self.onConfirm?(amount, message)
                    self.cancel()
                }
            }
        )
        containerView.addSubview(generateNewQRButton)
        generateNewQRButton.below(messageInput, top: 20)
        generateNewQRButton.constraintLeft(containerView, margin: 20)
        generateNewQRButton.constraintRight(containerView, margin: 20)
        generateNewQRButton.constraintHeight(45)
    }

    @objc func close() {
        self.dismiss(animated: true)
    }
}

extension PaymentModal {

    enum UIValues {

        // -- Size
        static let modalSize: CGFloat = 285
    }
}
