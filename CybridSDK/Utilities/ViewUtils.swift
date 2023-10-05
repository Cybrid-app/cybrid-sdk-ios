//
//  ViewUtils.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 11/08/23.
//

import UIKit

func getParagraphStyle(_ lineHeight: CGFloat) -> NSMutableParagraphStyle {

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = lineHeight
    return paragraphStyle
}

func setupScrollView(_ scroll: UIScrollView, parent: UIView) -> UIView {

    scroll.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        scroll.topAnchor.constraint(equalTo: parent.topAnchor),
        scroll.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
        scroll.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        scroll.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
    ])

    let contentView = UIView()
    scroll.addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    let heightConstraint = contentView.heightAnchor.constraint(equalTo: scroll.heightAnchor)
    heightConstraint.priority = UILayoutPriority(250)
    NSLayoutConstraint.activate([
        contentView.topAnchor.constraint(equalTo: scroll.topAnchor),
        contentView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
        contentView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
        contentView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
        contentView.widthAnchor.constraint(equalTo: scroll.widthAnchor),
        heightConstraint
    ])
    return contentView
}

func getImage(_ named: String, aClass: AnyClass) -> UIImage {

    return UIImage(named: named, in: Bundle(for: aClass), with: nil)!
}
