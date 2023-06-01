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
    
    @IBOutlet var clientId: UITextField?
    @IBOutlet var clientSecret: UITextField?
    @IBOutlet var customerGuid: UITextField?
    @IBOutlet var errorLabel: UILabel?
    
    private var loader: LoginLooader? = nil
    
    private var environment = CybridEnvironment.sandbox
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // -- Setup textFields
        self.setUITexteFildUnderLine(textField: self.clientId)
        self.setUITexteFildUnderLine(textField: self.clientSecret)
        self.setUITexteFildUnderLine(textField: self.customerGuid)
    }
    
    @IBAction func demoLogin(_ sender: Any) {

        self.loader = LoginLooader()
        self.loader?.present()

        // -- Geting clientID and Secret from envs
        let clientId = Bundle.main.object(forInfoDictionaryKey: "CybridClientId") as? String ?? ""
        let clientSecret = Bundle.main.object(forInfoDictionaryKey: "CybridClientSecret") as? String ?? ""
        let customerGuid = Bundle.main.object(forInfoDictionaryKey: "CybridCustomerGUID") as? String ?? ""

        // -- Get bearer
        self.getLocalBearer(clientId: clientId,
                            clientSecret: clientSecret,
                            customerGuid: customerGuid)
    }
    
    @IBAction func login(_ sender: Any) {
        
        self.errorLabel?.isHidden = true
        let clientIdValue = clientId?.text ?? ""
        let clientSecretValue = clientSecret?.text ?? ""
        let customerGuidValue = customerGuid?.text ?? ""
        
        if (clientIdValue.isEmpty ||
            clientSecretValue.isEmpty ||
            customerGuidValue.isEmpty) {

            self.errorLabel?.isHidden = false
            return
        }
        self.loader = LoginLooader()
        self.loader?.present()
        self.getLocalBearer(clientId: clientIdValue,
                            clientSecret: clientSecretValue,
                            customerGuid: customerGuidValue)
    }
    
    func getLocalBearer(clientId: String, clientSecret: String, customerGuid: String) {
        
        let authenticator = CryptoAuthenticator(session: .shared,
                                                clientId: clientId,
                                                clientSecret: clientSecret,
                                                customerGuid: customerGuid)
        authenticator.getBearer(environment: self.environment, completion: { [weak self] result in
            
            switch result {
            case .success(let bearer):
                self?.initCybridSDK(customerGuid: customerGuid, bearer: bearer)
            case .failure(let error):
                
                DispatchQueue.main.async {

                    self?.loader?.dismiss(animated: true)
                    self?.errorLabel?.text = error.localizedDescription
                }
                print(error)
            }
        })
    }
    
    func initCybridSDK(customerGuid: String, bearer: String) {
        
        Cybrid.setup(bearer: bearer,
                     customerGUID: customerGuid,
                     environment: self.environment,
                     logger: ClientLogger()) {
            
            if self.loader != nil {
                DispatchQueue.main.async {
                    self.loader?.dismiss(animated: true)
                }
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToComponents", sender: self)
            }
        }
    }
}

// MARK: UITextField Delegation
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

// MARK: Utitlies
extension LoginController {
    
    func setUITexteFildUnderLine(textField: UITextField?) {

        textField?.backgroundColor = .clear
        textField?.borderStyle = UITextField.BorderStyle.none
        textField?.layer.cornerRadius = 0
        textField?.textColor = UIColor.white

        let underline = UIView()
        underline.backgroundColor = UIColor.white
        underline.translatesAutoresizingMaskIntoConstraints = false
        textField?.addSubview(underline)
        underline.constraint(attribute: .leading,
                             relatedBy: .equal,
                             toItem: textField,
                             attribute: .leading)
        underline.constraint(attribute: .trailing,
                             relatedBy: .equal,
                             toItem: textField,
                             attribute: .trailing)
        underline.constraint(attribute: .top,
                             relatedBy: .equal,
                             toItem: textField,
                             attribute: .bottom)
        underline.constraint(attribute: .height,
                             relatedBy: .equal,
                             toItem: nil,
                             attribute: .notAnAttribute,
                             constant: 1)
    }
}
