//
//  CybridModalViewController.swift
//  CybridSDK
//
//  Created by Cybrid on 16/08/22.
//

import UIKit

final class CybridModalViewController: UIViewController {
  typealias ModalContentView = UIView

  private var contentView: ModalContentView
  private let theme: Theme

  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = theme.colorTheme.secondaryBackgroundColor
    view.layer.cornerRadius = 28
    view.alpha = 0
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
    view.backgroundColor = Cybrid.theme.colorTheme.shadowColor
    view.alpha = 0

    containerView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(containerView)
    containerView.addSubview(contentView)

    containerView.constraint(attribute: .top, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .top, constant: 16)
    containerView.constraint(attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: view, attribute: .bottom, constant: -16)
    containerView.constraint(attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, constant: 20)
    containerView.constraint(attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, constant: -20)
    containerView.constraint(attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY)

    contentView.constraintEdges(to: containerView, insets: .init(top: 24, left: 24, bottom: 24, right: 24))

    containerView.layoutIfNeeded()
  }

  private func presentAnimation() {
    UIView.animate(
      withDuration: 0.2,
      animations: { [weak self] in
        self?.view.alpha = 1
      }, completion: { [weak self] _ in
        UIView.animate(
          withDuration: 0.4,
          delay: 0,
          usingSpringWithDamping: 0.5,
          initialSpringVelocity: 5,
          options: .curveEaseOut,
          animations: {
            self?.containerView.alpha = 1.0
          }, completion: nil
        )
      }
    )
  }

  private func dismissAnimation(_ completion: @escaping () -> Void) {
    UIView.animate(
      withDuration: 0.2,
      animations: { [weak self] in
        self?.view.alpha = 0.0
        self?.view.alpha = 0.0
      }, completion: { _ in
        completion()
      }
    )
  }

  func present() {
    if var topController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      self.modalPresentationStyle = .overFullScreen
      topController.present(self, animated: false, completion: { [weak self] in
        self?.presentAnimation()
      })
    }
  }

  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    dismissAnimation {
      super.dismiss(animated: flag, completion: completion)
    }
  }

  func replaceContent(_ newContent: UIView) {
    contentView.removeFromSuperview()
    contentView = newContent
    contentView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(contentView)
    contentView.constraintEdges(to: containerView, insets: .init(top: 24, left: 24, bottom: 24, right: 24))

    containerView.layoutSubviews()
  }
}
