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
