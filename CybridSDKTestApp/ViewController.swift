//
//  ViewController.swift
//  CybridSDKTestApp
//
//  Created by Cybrid on 17/06/22.
//

import UIKit
@testable import CybridSDK

/*
 open: te permite sobreescribir.
 public: te permite exponer el codigo fuera del Bundle (App, SDK).
 internal: default. Te permite acceder desde cualquier lado dentro del mismo Bundle.
 fileprivate: No puede ser accedido fuera del archivo
 private: No puede accedido fuera del cuerpo de la clase o el codigo.
 */

class ViewController: UIViewController {

  private var imageView: URLImageView?

  override func viewDidLoad() {
    super.viewDidLoad()
    imageView = URLImageView(urlString: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/YouTube_social_white_squircle.svg/1200px-YouTube_social_white_squircle.svg.png", placeholder: UIImage(named: "placeholder"))
    setupView()
  }

  private func setupView() {
    guard let image = imageView else { return }
    image.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(image)
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: image, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0),
      NSLayoutConstraint(item: image, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
      NSLayoutConstraint(item: image, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50),
      NSLayoutConstraint(item: image, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
    ])
    image.layoutSubviews()
  }
}
