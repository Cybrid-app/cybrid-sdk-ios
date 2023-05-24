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
    
    private var loader: LoginLooader? = nil
    
    private var env = CybridEnvironment.sandbox
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // -- Setup textFields
        self.setUITexteFildUnderLine(textField: self.clientID)
        self.setUITexteFildUnderLine(textField: self.clientSecret)
        self.setUITexteFildUnderLine(textField: self.customerGUID)
    }
    
    @IBAction func demoLogin(_ sender: Any) {

        self.loader = LoginLooader()
        self.loader?.present()
        self.getBearer(id: "", secret: "", guid: "")
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
        self.loader = LoginLooader()
        self.loader?.present()
        self.getBearer(id: clientIDValue, secret: clientSecretValue, guid: customerGUIDValue)
    }
    
    func getBearer(id: String, secret: String, guid: String) {
        
        let authenticator = CryptoAuthenticator(session: .shared, id: id, secret: secret)
        authenticator.getBearer(env: env, completion: { [weak self] result in
            
            switch result {
            case .success(let bearer):
                self?.initCybridSDK(guid: guid, bearer: bearer)
            case .failure(let error):
                
                DispatchQueue.main.async {

                    self?.loader?.dismiss(animated: true)
                    self?.errorLabel?.text = error.localizedDescription
                }
                print(error)
            }
        })
    }
    
    func initCybridSDK(guid: String, bearer: String) {
        
        var guidClient = ""
        if (guid == "") {
            guidClient = Bundle.main.object(forInfoDictionaryKey: "CybridCustomerGUID") as? String ?? ""
        } else {
            guidClient = guid
        }
        Cybrid.setup(bearer: bearer,
                     customerGUID: guidClient,
                     environment: env,
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
