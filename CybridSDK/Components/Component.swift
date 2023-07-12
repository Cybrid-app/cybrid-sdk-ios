//
//  Component.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 11/07/23.
//

import UIKit

public class Component: UIView, ComponentProtocol {

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
}

protocol ComponentProtocol {
    func setupView()
}
