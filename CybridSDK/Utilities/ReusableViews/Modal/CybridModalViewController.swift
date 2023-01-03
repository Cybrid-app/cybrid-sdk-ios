//
//  CybridModalViewController.swift
//  CybridSDK
//
//  Created by Cybrid on 16/08/22.
//

import UIKit

final class CybridModalViewController: UIViewController {
  typealias ModalContentView = UIView

  internal var contentView: ModalContentView
  private let theme: Theme
  private let dispatchGroup = DispatchGroup()

  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = theme.colorTheme.secondaryBackgroundColor
    view.layer.cornerRadius = Constants.cornerRadius
    return view
  }()

  init(theme: Theme, _ contentView: ModalContentView) {
    self.contentView = contentView
    self.theme = theme

    super.init(nibName: nil, bundle: nil)

    setupViews()
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
    contentView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(containerView)
    containerView.addSubview(contentView)

    containerView.constraint(attribute: .top,
                             relatedBy: .greaterThanOrEqual,
                             toItem: view,
                             attribute: .top,
                             constant: Constants.minimumVerticalSpacing)
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

    contentView.constraintEdges(to: containerView, insets: Constants.contentInsets)

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

  func replaceContent(_ newContent: UIView) {
    DispatchQueue.main.async(group: dispatchGroup, flags: [.barrier]) { [weak self] in
      guard let self = self else { return }
      newContent.frame = self.contentView.frame
      newContent.translatesAutoresizingMaskIntoConstraints = false
      newContent.alpha = 0.0
      let oldContent = self.contentView
      self.containerView.addSubview(newContent)
      newContent.constraintEdges(to: self.containerView,
                                 insets: Constants.contentInsets)

      UIView.transition(
        with: self.containerView,
        duration: 0.2,
        options: .showHideTransitionViews,
        animations: {
          oldContent.alpha = 0.0
          newContent.alpha = 1.0
        },
        completion: { _ in
          oldContent.removeFromSuperview()
          self.contentView = newContent
        }
      )
    }
  }
}

// MARK: - Constants

extension CybridModalViewController {
  enum Constants {
    static let cornerRadius: CGFloat = UIConstants.radiusXl
    static let minimumVerticalSpacing: CGFloat = UIConstants.spacingXl2
    static let contentInsets = UIEdgeInsets(top: UIConstants.spacingXl3,
                                            left: UIConstants.spacingXl3,
                                            bottom: UIConstants.spacingXl3,
                                            right: UIConstants.spacingXl3)
  }
}

extension CybridModalViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    let coordinates = touch.location(in: containerView)
    print(coordinates)
    return coordinates.y < 0
  }
}
