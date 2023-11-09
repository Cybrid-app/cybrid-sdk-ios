//
//  BankAccountsView_Authorization.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 07/11/23.
//

import UIKit

extension BankAccountsView {

    internal func bankAccountsView_Authorization() {

        // -- Scroll
        let scroll = UIScrollView()
        self.addSubview(scroll)
        let contentView = setupScrollView(scroll, parent: self)

        // -- IamgeTitle
        let imageTitle = UIImageView(image: getImage("bankAuthorizationImage", aClass: Self.self))
        contentView.addSubview(imageTitle)
        imageTitle.constraintTop(contentView, margin: 0)
        imageTitle.centerHorizontal(parent: contentView)
        imageTitle.setConstraintsSize(size: CGSize(width: 183, height: 174))

        // -- Title
        let titleString = localizer.localize(with: UIStrings.authMessageTitle)
        let title = UILabel()
        title.font = UIFont.make(ofSize: 23)
        title.textAlignment = .center
        let paragraphStyle = getParagraphStyle(1.19)
        paragraphStyle.alignment = .center
        title.setParagraphText(titleString, paragraphStyle)
        contentView.addSubview(title)
        title.below(imageTitle, top: 17)
        title.constraintLeft(contentView, margin: 15)
        title.constraintRight(contentView, margin: 15)
        title.constraintHeight(32)

        // -- Warning Container
        let warningContainer = UIView()
        warningContainer.layer.backgroundColor = UIColor(red: 0.983, green: 0.894, blue: 0.578, alpha: 1).cgColor
        warningContainer.layer.cornerRadius = 10
        contentView.addSubview(warningContainer)
        warningContainer.below(title, top: 18)
        warningContainer.constraintLeft(contentView, margin: 15)
        warningContainer.constraintRight(contentView, margin: 15)
        warningContainer.constraintHeight(103)

        // -- Warning Label
        let warningString = localizer.localize(with: UIStrings.authWarningMessage)
        let warningLabel = UILabel()
        warningLabel.font = UIFont.make(ofSize: 17.5, weight: .bold)
        warningLabel.numberOfLines = 0
        warningLabel.lineBreakMode = .byWordWrapping
        let warningLabelParagraph = getParagraphStyle(1.1)
        warningLabelParagraph.alignment = .justified
        warningLabel.setParagraphText(warningString, warningLabelParagraph)
        warningContainer.addSubview(warningLabel)
        warningLabel.centerVertical(parent: warningContainer)
        warningLabel.constraintLeft(warningContainer, margin: 20)
        warningLabel.constraintRight(warningContainer, margin: 20)

        // -- Message
        let messageString = localizer.localize(with: UIStrings.authMessageString)
        let messageLabel = UILabel()
        messageLabel.font = UIFont.make(ofSize: 18)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        let messageParagraph = getParagraphStyle(1.1)
        messageParagraph.alignment = .justified
        messageLabel.setParagraphText(messageString, messageParagraph)
        contentView.addSubview(messageLabel)
        messageLabel.below(warningContainer, top: 17)
        messageLabel.constraintLeft(contentView, margin: 20)
        messageLabel.constraintRight(contentView, margin: 20)

        // -- Continue button
        let authorizeString = localizer.localize(with: UIStrings.authButton)
        let authorizeButton = CYBButton(title: authorizeString) { [self] in
            self.openPlaid()
        }
        contentView.addSubview(authorizeButton)
        authorizeButton.below(messageLabel, top: 25)
        authorizeButton.constraintLeft(contentView, margin: 15)
        authorizeButton.constraintRight(contentView, margin: 15)
        authorizeButton.constraintHeight(48)
        authorizeButton.constraintBottom(contentView, margin: 15)
    }
}
