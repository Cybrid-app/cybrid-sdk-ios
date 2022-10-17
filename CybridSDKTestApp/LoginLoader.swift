//
//  LoginLoader.swift
//  CybridSDKTestApp
//
//  Created by Erick Sanchez Perez on 13/10/22.
//

import Foundation
import CybridSDK
import UIKit

class LoginLooader: UIModal {
    
    init() {
        
        super.init(height: 200)
        self.setutViews()
    }
    
    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

        assertionFailure("init(coder:) should never be used")
        return nil
    }
    
    func setutViews() {
        
        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIFont.systemFont(ofSize: 23, weight: .regular)
        title.textColor = UIColor.black
        title.textAlignment = .center
        title.text = "Logging with Cybrid, wait"
        
        self.containerView.addSubview(title)
        title.constraint(attribute: .top,
                        relatedBy: .equal,
                         toItem: self.containerView,
                         attribute: .topMargin,
                        constant: 30)
        title.constraint(attribute: .leading,
                        relatedBy: .equal,
                         toItem: self.containerView,
                        attribute: .leading,
                        constant: 10)
        title.constraint(attribute: .trailing,
                        relatedBy: .equal,
                         toItem: self.containerView,
                        attribute: .trailing,
                        constant: -10)
        title.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: 40)
        
        let loader = UIActivityIndicatorView()
        loader.color = UIColor.blue
        loader.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        self.containerView.addSubview(loader)
        loader.startAnimating()
        
        loader.constraint(attribute: .top,
                        relatedBy: .equal,
                        toItem: title,
                        attribute: .bottom,
                        constant: 15)
        loader.constraint(attribute: .centerX,
                         relatedBy: .equal,
                        toItem: self.containerView,
                        attribute: .centerX,
                        constant: 0)
        loader.constraint(attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: 60)
        loader.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: 60)
        
    }
}
