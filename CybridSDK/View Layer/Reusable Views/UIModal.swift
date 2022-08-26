//
//  UIModal.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 26/08/22.
//

import Foundation
import UIKit

internal class UIModal: UIViewController {

    private let theme: Theme
    private let dispatchGroup = DispatchGroup()

    internal var containerView = UIView()

    init(theme: Theme) {

        self.theme = theme
        super.init(nibName: nil, bundle: nil)

        self.containerView.backgroundColor = theme.colorTheme.secondaryBackgroundColor
        self.containerView.layer.cornerRadius = UIConstants.cornerRadius
        self.setupViews()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
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
        containerView.constraint(attribute: .height,
                                 relatedBy: .equal,
                                 toItem: nil,
                                 attribute: .notAnAttribute,
                                 constant: 100)

        containerView.layoutIfNeeded()
    }

    @objc private func didTapBackground() {
        dismiss(animated: true)
    }

    func present() {

        if var topController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(self, animated: true, completion: nil)
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

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        let coordinates = touch.location(in: self.containerView)
        return coordinates.y < 0
    }
}
