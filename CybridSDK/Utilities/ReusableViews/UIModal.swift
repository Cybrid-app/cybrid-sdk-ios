//
//  UIModal.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 14/09/22.
//

import Foundation
import UIKit

open class UIModal: UIViewController {

    private let dispatchGroup = DispatchGroup()
    private var heighConstraint: NSLayoutConstraint?

    public var containerView = UIView()
    var height: CGFloat = 100
    var disableDismiss = false

    public init(height: CGFloat = 100) {

        super.init(nibName: nil, bundle: nil)

        self.containerView.backgroundColor = UIColor.white
        self.containerView.layer.cornerRadius = UIConstants.cornerRadius
        self.height = height
        self.setupViews()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    public required init?(coder: NSCoder) {
      assertionFailure("init(coder:) should never be used")
      return nil
    }

    private func setupViews() {

        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        containerView.isUserInteractionEnabled = true

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        containerView.constraint(attribute: .top,
                                 relatedBy: .greaterThanOrEqual,
                                 toItem: view,
                                 attribute: .top,
                                 constant: 10)
        containerView.constraint(attribute: .bottom,
                                 relatedBy: .equal,
                                 toItem: view,
                                 attribute: .bottom)
        containerView.constraint(attribute: .leading,
                                 relatedBy: .equal,
                                 toItem: view,
                                 attribute: .leading)
        containerView.constraint(attribute: .trailing,
                                 relatedBy: .equal,
                                 toItem: view,
                                 attribute: .trailing)
        heighConstraint = containerView.constraint(attribute: .height,
                                 relatedBy: .equal,
                                 toItem: nil,
                                 attribute: .notAnAttribute,
                                 constant: self.height)

        containerView.layoutIfNeeded()
    }

    @objc private func didTapBackground() {
        self.cancel()
    }

    public func present() {

        if var topController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(self, animated: true, completion: nil)
        }
    }

    public func modifyHeight(height: CGFloat) {

        self.heighConstraint?.constant = height
        self.view.layoutIfNeeded()
    }

    public func cancel() {
        if !self.disableDismiss {
            dismiss(animated: true)
        }
    }

    // MARK: UI Helpers
    internal func createLoadingScreen(content: UIView, text: String) {

        // -- Loading Label Container
        let loadingLabelContainer = UIView()
        content.addSubview(loadingLabelContainer)
        loadingLabelContainer.centerVertical(parent: content)
        loadingLabelContainer.constraintLeft(content, margin: 10)
        loadingLabelContainer.constraintRight(content, margin: 10)
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

    internal func createErrorScreen(content: UIView, message: String) {

        self.modifyHeight(height: 240)

        // -- Error container
        let errorContainer = UIView()
        content.addSubview(errorContainer)
        errorContainer.centerVertical(parent: content)
        errorContainer.constraintLeft(content, margin: 10)
        errorContainer.constraintRight(content, margin: 10)
        errorContainer.constraintHeight(190)

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
        errorMessage.font = UIFont.make(ofSize: 20)
        errorMessage.textColor = UIColor.init(hex: "#3A3A3C")
        errorMessage.setParagraphText(message, paragraphStyle)
        errorContainer.addSubview(errorMessage)
        errorMessage.below(errorImage, top: 20)
        errorMessage.constraintLeft(errorContainer, margin: 0)
        errorMessage.constraintRight(errorContainer, margin: 0)

        // -- Close button
        let closeButton = CYBButton(
            title: "Continue"
        ) {
            self.cancel()
        }
        errorContainer.addSubview(closeButton)
        closeButton.constraintLeft(errorContainer, margin: 0)
        closeButton.constraintRight(errorContainer, margin: 0)
        closeButton.constraintBottom(errorContainer, margin: 0)
        closeButton.constraintHeight(50)
    }

    internal func createDoneScreen(content: UIView, message: String) {

        self.modifyHeight(height: 240)

        // -- Error container
        let container = UIView()
        content.addSubview(container)
        container.centerVertical(parent: content)
        container.constraintLeft(content, margin: 10)
        container.constraintRight(content, margin: 10)
        container.constraintHeight(190)

        // -- Error Image
        let errorImage = UIImageView(image: getImage("kyc_verified", aClass: Self.self))
        container.addSubview(errorImage)
        errorImage.constraintTop(container, margin: 0)
        errorImage.centerHorizontal(parent: container)
        errorImage.setConstraintsSize(size: CGSize(width: 60, height: 60))

        // -- Error message
        let paragraphStyle = getParagraphStyle(1.05)
        paragraphStyle.alignment = .center
        let errorMessage = UILabel()
        errorMessage.font = UIFont.make(ofSize: 20)
        errorMessage.textColor = UIColor.init(hex: "#3A3A3C")
        errorMessage.setParagraphText(message, paragraphStyle)
        container.addSubview(errorMessage)
        errorMessage.below(errorImage, top: 20)
        errorMessage.constraintLeft(container, margin: 0)
        errorMessage.constraintRight(container, margin: 0)

        // -- Close button
        let closeButton = CYBButton(
            title: "Continue"
        ) {
            self.cancel()
        }
        container.addSubview(closeButton)
        closeButton.constraintLeft(container, margin: 0)
        closeButton.constraintRight(container, margin: 0)
        closeButton.constraintBottom(container, margin: 0)
        closeButton.constraintHeight(50)
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
}

// MARK: - Constants
extension UIModal {

    enum UIValues {

        static let contentInsets = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
    }
}

extension UIModal: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        let coordinates = touch.location(in: self.containerView)
        return coordinates.y < 0
    }
}
