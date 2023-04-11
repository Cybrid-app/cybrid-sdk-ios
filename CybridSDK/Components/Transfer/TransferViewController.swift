//
//  TransferViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 23/12/22.
//

import UIKit

public final class TransferViewController: UIViewController {

    public enum ViewState { case LOADING, ACCOUNTS, ERROR, WARNING }
    public enum ModalViewState { case LOADING, CONFIRM, DETAILS, ERROR }
    public enum BalanceViewState { case LOADING, CONTENT }

    internal var transferViewModel: TransferViewModel!
    internal var theme: Theme!
    internal var localizer: Localizer!

    internal var errorMessageView = UILabel()
    internal var componentContent = UIView()
    internal var currentState: Observable<ViewState> = .init(.LOADING)

    internal var accountsPickerView = UIPickerView()
    internal var amountField: CYBTextField!

    public init() {

        super.init(nibName: nil, bundle: nil)
        self.transferViewModel = TransferViewModel(
            dataProvider: CybridSession.current,
            logger: Cybrid.logger
        )
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        self.currentState = self.transferViewModel.uiState
        self.setupView()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

      assertionFailure("init(coder:) should never be used")
      return nil
    }

    func setupView() {

        view.backgroundColor = .white
        self.initComponentContent()
        self.manageCurrentStateUI()
        self.transferViewModel.fetchAccounts()
    }
}

extension TransferViewController {

    private func initComponentContent() {

        // -- Error meesage view
        self.errorMessageView.backgroundColor = UIColor.red
        self.errorMessageView.textColor = UIColor.white
        self.errorMessageView.font = UIFont.systemFont(ofSize: 14)
        self.errorMessageView.textAlignment = .center
        self.view.addSubview(self.errorMessageView)
        self.errorMessageView.constraint(attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .topMargin,
                                         constant: 0)
        self.errorMessageView.constraint(attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .leading,
                                         constant: 10)
        self.errorMessageView.constraint(attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .trailing,
                                         constant: -10)
        self.errorMessageView.constraint(attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         constant: 20)
        self.errorMessageView.isHidden = true

        // -- Component Container
        self.view.addSubview(self.componentContent)
        self.componentContent.constraint(attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self.errorMessageView,
                                         attribute: .bottom,
                                         constant: 0)
        self.componentContent.constraint(attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .leading,
                                         constant: 10)
        self.componentContent.constraint(attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .trailing,
                                         constant: -10)
        self.componentContent.constraint(attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .bottomMargin,
                                         constant: 10)
    }

    private func manageCurrentStateUI() {

        // -- Await for error message UI
        self.transferViewModel.errorMessage.bind { error in
            if error {
                self.errorMessageView.isHidden = false
                self.errorMessageView.text = self.localizer.localize(with: "cybrid.transfer.errorMessage.text")
            }
        }

        // -- Await for UI State changes
        self.currentState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                self.transferView_Loading()

            case .ACCOUNTS:
                self.transferView_Accounts()

            case .ERROR:
                self.transferView_Error()

            case .WARNING:
                self.transferView_Warning()
            }
        }
    }

    internal func removeSubViewsFromContent() {

        for view in self.componentContent.subviews {
            view.removeFromSuperview()
        }
    }
}
