//
//  ContentSizedTableView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 03/10/23.
//

import UIKit

final class ContentSizedTableView: UITableView {

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric,
                      height: contentSize.height + adjustedContentInset.top)
    }
}
