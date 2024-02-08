//
//  Component.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 11/07/23.
//

import UIKit

public class Component: UIView, ComponentProtocol {

    internal var parentView: UIView?
    internal var parentController: UIViewController?

    override init(frame: CGRect) {

        super.init(frame: frame)
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

        assertionFailure("init(coder:) should never be used")
        return nil
    }

    func setupView() {
        print("SDK Component - Setup View")
    }

    // MARK: Embeddings Helpers
    func embed(in view: UIView, parent: UIViewController? = nil) {

        self.parentController = parent
        self.parentView = view
        willMove(toSuperview: view)
        view.addSubview(self)
        self.constraint(attribute: .top,
                        relatedBy: .equal,
                        toItem: view,
                        attribute: .top,
                        constant: 0)
        self.constraint(attribute: .trailing,
                        relatedBy: .equal,
                        toItem: view,
                        attribute: .trailing,
                        constant: 0)
        self.constraint(attribute: .bottom,
                        relatedBy: .equal,
                        toItem: view,
                        attribute: .bottom,
                        constant: 0)
        self.constraint(attribute: .leading,
                        relatedBy: .equal,
                        toItem: view,
                        attribute: .leading,
                        constant: 0)
        layoutSubviews()
    }

    internal func embed(in viewController: UIViewController) {

        self.parentView = viewController.view
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

    // MARK: UI Component Helper
    internal func removeSubViewsFromContent() {

        for view in self.subviews {
            view.removeFromSuperview()
        }
    }

    // MARK: UI Helper Functions
    internal func createLoaderScreen(text: String) {

        // -- Loading Label Container
        let loadingLabelContainer = UIView()
        self.addSubview(loadingLabelContainer)
        loadingLabelContainer.centerVertical(parent: self)
        loadingLabelContainer.constraintLeft(self, margin: 10)
        loadingLabelContainer.constraintRight(self, margin: 10)
        loadingLabelContainer.constraintHeight(100)

        // -- Loading label
        let loadingLabel = UILabel()
        loadingLabel.font = UIFont.make(ofSize: 22)
        loadingLabel.textColor = UIColor.init(hex: "#3A3A3C")
        let paragraphStyle = getParagraphStyle(1.05)
        paragraphStyle.alignment = .center
        loadingLabel.setParagraphText(text, paragraphStyle)
        loadingLabelContainer.addSubview(loadingLabel)
        loadingLabel.constraintTop(loadingLabelContainer, margin: 0)
        loadingLabel.constraintLeft(loadingLabelContainer, margin: 0)
        loadingLabel.constraintRight(loadingLabelContainer, margin: 0)

        // -- Spinner
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = UIColor.init(hex: "#007AFF")
        spinner.startAnimating()
        loadingLabelContainer.addSubview(spinner)
        spinner.below(loadingLabel, top: 25)
        spinner.centerHorizontal(parent: loadingLabelContainer)
        spinner.setConstraintsSize(size: CGSize(width: 43, height: 43))
        spinner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    }

    @discardableResult
    internal func createEmptySection(text: String, font: UIFont = UIFont.make(ofSize: 20)) -> UIView {

        // -- Loading Label Container
        let emptyContainer = UIView()
        emptyContainer.constraintHeight(105)

        // -- Image
        let imageEmpty = UIImageView(image: getImage("ic_empty", aClass: Self.self))
        emptyContainer.addSubview(imageEmpty)
        imageEmpty.constraintTop(emptyContainer, margin: 0)
        imageEmpty.centerHorizontal(parent: emptyContainer)
        imageEmpty.setConstraintsSize(size: CGSize(width: 60, height: 60))

        // -- Loading label
        let paragraphStyle = getParagraphStyle(1.05)
        paragraphStyle.alignment = .center
        let emptyLabel = UILabel()
        emptyLabel.font = font
        emptyLabel.textColor = UIColor.init(hex: "#3A3A3C")
        emptyLabel.setParagraphText(text, paragraphStyle)
        emptyContainer.addSubview(emptyLabel)
        emptyLabel.below(imageEmpty, top: 20)
        emptyLabel.constraintLeft(emptyContainer, margin: 0)
        emptyLabel.constraintRight(emptyContainer, margin: 0)

        // -- Return
        return emptyContainer
    }

    @discardableResult
    internal func createError(message: String,
                              font: UIFont = UIFont.make(ofSize: 20)) -> UIView {

        // -- Error container
        let errorContainer = UIView()
        errorContainer.constraintHeight(105)

        // -- Error Image
        let errorImage = UIImageView(image: getImage("kyc_error", aClass: Self.self))
        errorContainer.addSubview(errorImage)
        errorImage.constraintTop(errorContainer, margin: 0)
        errorImage.centerHorizontal(parent: errorContainer)
        errorImage.setConstraintsSize(size: CGSize(width: 60, height: 60))

        // -- Error message
        let paragraphStyle = getParagraphStyle(1.05)
        paragraphStyle.alignment = .center
        let errorMessage = UILabel()
        errorMessage.font = font
        errorMessage.textColor = UIColor.init(hex: "#3A3A3C")
        errorMessage.setParagraphText(message, paragraphStyle)
        errorContainer.addSubview(errorMessage)
        errorMessage.below(errorImage, top: 20)
        errorMessage.constraintLeft(errorContainer, margin: 0)
        errorMessage.constraintRight(errorContainer, margin: 0)

        // -- Return
        return errorContainer
    }

    internal func frozenCustomerUI() {

        let localizer = CybridLocalizer()

        // -- Error container
        let container = UIView()
        self.addSubview(container)
        container.constraintHeight(245)
        container.centerVertical(parent: self)
        container.constraintLeft(self, margin: 10)
        container.constraintRight(self, margin: 10)

        // -- Error Image
        let errorImage = UIImageView(image: getImage("kyc_error", aClass: Self.self))
        container.addSubview(errorImage)
        errorImage.constraintTop(container, margin: 0)
        errorImage.centerHorizontal(parent: container)
        errorImage.setConstraintsSize(size: CGSize(width: 60, height: 60))

        // -- Error message
        let message = localizer.localize(with: "cybrid.customer.frozen")
        let paragraphStyle = getParagraphStyle(1.20)
        paragraphStyle.alignment = .center
        let errorMessage = UILabel()
        errorMessage.font = UIFont.make(ofSize: 22, weight: .bold)
        errorMessage.textColor = UIColor.init(hex: "#3A3A3C")
        errorMessage.setParagraphText(message, paragraphStyle)
        container.addSubview(errorMessage)
        errorMessage.below(errorImage, top: 20)
        errorMessage.constraintLeft(container, margin: 0)
        errorMessage.constraintRight(container, margin: 0)

        // -- Sub-title
        let subTitleString = localizer.localize(with: "cybrid.customer.frozen.details")
        let subTitile = UILabel()
        subTitile.font = UIFont.make(ofSize: 17.5)
        subTitile.textColor = UIColor.black
        subTitile.textAlignment = .center
        subTitile.text = subTitleString
        container.addSubview(subTitile)
        subTitile.below(errorMessage, top: 12.5)
        subTitile.constraintLeft(container, margin: 0)
        subTitile.constraintRight(container, margin: 0)

        // -- Add button
        let returnButtonString = localizer.localize(with: "cybrid.modal.continue.button")
        let returnButton = CYBButton(title: returnButtonString) {
            self.back()
        }
        container.addSubview(returnButton)
        returnButton.constraintLeft(self, margin: 10)
        returnButton.constraintRight(self, margin: 10)
        returnButton.below(subTitile, top: 50)
        returnButton.constraintHeight(48)
    }

    internal func label(font: UIFont,
                        color: UIColor,
                        text: String,
                        lineHeight: CGFloat,
                        aligment: NSTextAlignment = .center) -> UILabel {

        let paragraphStyle = getParagraphStyle(lineHeight)
        paragraphStyle.alignment = aligment
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.setParagraphText(text, paragraphStyle)
        return label
    }

    // MARK: Controller Helper
    internal func back() {
        if self.parentController?.navigationController != nil {
            self.parentController?.navigationController?.popViewController(animated: true)
        } else {
            self.parentController?.dismiss(animated: true)
        }
    }

    // MARK: Check customer
    internal func canRenderComponent() -> Bool {
        guard let customer = Cybrid.customer
        else { return true }
        self.frozenCustomerUI()
        return customer.state != "frozen"
    }
}

protocol ComponentProtocol {
    func setupView()
}
