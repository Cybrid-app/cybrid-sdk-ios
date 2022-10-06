//
//  LoginController.swift
//  CybridSDKTestApp
//
//  Created by Erick Sanchez Perez on 05/10/22.
//

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
