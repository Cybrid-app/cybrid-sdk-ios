//
//  AccountsViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 19/08/22.
//

import Foundation
import UIKit

public final class AccountsViewController: UIViewController {
    
    private var accountsViewModel: AccountsViewModel
    private let theme: Theme
    private let localizer: Localizer
    
    public init() {
        
        self.accountsViewModel = AccountsViewModel(
            dataProvider: CybridSession.current,
            logger: Cybrid.logger
        )
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        self.accountsViewModel.getAccounts()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
      assertionFailure("init(coder:) should never be used")
      return nil
    }
}
