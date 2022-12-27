//
//  TransferViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 23/12/22.
//

import UIKit

public final class TransferViewController: UIViewController {

    public enum ViewState { case LOADING, ACCOUNTS, ERROR }

    internal var theme: Theme!
    internal var localizer: Localizer!

    internal var componentContent = UIView()
    internal var currentState: Observable<ViewState> = .init(.LOADING)

    public init() {

        super.init(nibName: nil, bundle: nil)
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

      assertionFailure("init(coder:) should never be used")
      return nil
    }
}
