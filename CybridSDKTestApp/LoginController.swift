//
//  LoginController.swift
//  CybridSDKTestApp
//
//  Created by Erick Sanchez Perez on 05/10/22.
//

import CybridSDK
import Foundation
import UIKit

class LoginController: UIViewController {
    
    @IBOutlet var clientID: UITextField?
    @IBOutlet var clientSecret: UITextField?
    @IBOutlet var customerGUID: UITextField?
    @IBOutlet var errorLabel: UILabel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func tryToLogin(_ sender: Any) {
        
        self.errorLabel?.isHidden = true
        let clientIDValue = clientID?.text ?? ""
        let clientSecretValue = clientSecret?.text ?? ""
        let customerGUIDValue = customerGUID?.text ?? ""
        
        if (clientIDValue.isEmpty ||
            clientSecretValue.isEmpty ||
            customerGUIDValue.isEmpty) {

            self.errorLabel?.isHidden = false
            return
        }
        self.getBearer(id: clientIDValue, secret: clientSecretValue, guid: customerGUIDValue)
    }
    
    func getBearer(id: String, secret: String, guid: String) {
        
        let authenticator = CryptoAuthenticator(session: .shared, id: id, secret: secret)
        authenticator.getBearer(completion: { [weak self] result in
            
            switch result {
            case .success(let bearer):
                self?.initCybridSDK(cutomerGuid: guid, bearer: bearer)
            case .failure(let error):
              print(error)
            }
        })
    }
    
    func initCybridSDK(cutomerGuid: String, bearer: String) {
        
        Cybrid.setup(bearer: bearer,
                     customerGUID: cutomerGuid,
                     fiat: .usd,
                     logger: ClientLogger())
        performSegue(withIdentifier: "goToComponentsList", sender: self)
    }
}

// # MARK: UITextField Delegation
extension LoginController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
        let nextTag = textField.tag + 1;
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder();
        } else {
            textField.resignFirstResponder();
        }
        return true;
    }
}
