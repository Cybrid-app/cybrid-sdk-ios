//
//  Component.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 11/07/23.
//

import UIKit

public class Component: UIView, ComponentProtocol {

    internal var parentView: UIView?

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

    func embed(in view: UIView) {

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

    internal func removeSubViewsFromContent() {

        for view in self.subviews {
            view.removeFromSuperview()
        }
    }

    internal func createLoaderScreen() {

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
        loadingLabel.setParagraphText("Loading your wallets", paragraphStyle)
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
    internal func createEmptySection() -> UIView {

        // -- Loading Label Container
        let emptyContainer = UIView()
        self.addSubview(emptyContainer)
        emptyContainer.centerVertical(parent: self)
        emptyContainer.constraintLeft(self, margin: 10)
        emptyContainer.constraintRight(self, margin: 10)
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
        emptyLabel.font = UIFont.make(ofSize: 20)
        emptyLabel.textColor = UIColor.init(hex: "#3A3A3C")
        emptyLabel.setParagraphText("No wallets have been added.", paragraphStyle)
        emptyContainer.addSubview(emptyLabel)
        emptyLabel.below(imageEmpty, top: 20)
        emptyLabel.constraintLeft(emptyContainer, margin: 0)
        emptyLabel.constraintRight(emptyContainer, margin: 0)

        // -- Return
        return emptyContainer
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

protocol ComponentProtocol {
    func setupView()
}
