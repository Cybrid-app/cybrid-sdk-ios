//
//  CryptoAuthenticator.swift
//  CybridSDKTestApp
//
//  Created by Cybrid on 12/07/22.
//

import CybridSDK
import Foundation
import CybridApiBankSwift
import CybridApiIdpSwift

class CryptoAuthenticator {

    private let session: URLSession
    private let tokenScopes = "banks:read banks:write accounts:read accounts:execute customers:read customers:write customers:execute prices:read quotes:execute trades:execute trades:read workflows:execute workflows:read external_bank_accounts:execute external_bank_accounts:read external_bank_accounts:write transfers:read transfers:execute"
    private let customerTokenScopes: Set<PostCustomerTokenIdpModel.ScopesIdpModel> = [
        .customersRead, .customersWrite, .accountsRead, .accountsExecute, .pricesRead, .quotesRead, .quotesExecute, .tradesRead, .tradesExecute, .transfersRead, .transfersExecute, .externalBankAccountsRead, .externalBankAccountsWrite, .externalBankAccountsExecute, .workflowsRead, .workflowsExecute
    ]
    private var clientId: String = ""
    private var clientSecret: String = ""
    private var customerGuid: String = ""

    init(session: URLSession, clientId: String, clientSecret: String, customerGuid: String) {

        self.session = session
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.customerGuid = customerGuid
    }

    func getBearer(environment: CybridEnvironment, completion: @escaping (Result<PreSdkConfig, Error>) -> Void) {

        guard let url = URL(string: "https://id.\(environment).cybrid.app/oauth/token") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "grant_type": "client_credentials",
            "client_id": self.clientId,
            "client_secret": self.clientSecret,
            "scope": self.tokenScopes
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            completion(.failure(error))
            return
        }

        session.dataTask(with: request) { [self] data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard
                let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                let responseData = data
            else {
                return
            }

            do {
                if
                    let jsonResponse = try JSONSerialization.jsonObject(with: responseData) as? [String: Any],
                    let bearer = jsonResponse["access_token"] as? String {
                    self.getCustomerToken(environment: environment,
                                          bearer: bearer,
                                          completion: completion)
                } else {
                    completion(.failure(CybridError.serviceError))
                    return
                }
            } catch let error {
                completion(.failure(error))
                return
            }
        }.resume()
    }
    
    func getCustomerToken(environment: CybridEnvironment, bearer: String, completion: @escaping (Result<PreSdkConfig, Error>) -> Void) {
        
        // -- Set IDP environment
        CybridApiIdpSwiftAPI.basePath = environment.baseIdpPath
        
        // -- Set headers
        CybridApiIdpSwiftAPI.customHeaders = ["Authorization": "Bearer " + bearer]
        
        // -- Init PreSdkConfig
        var config = PreSdkConfig()
        
        // -- Get customer token
        let postCustomerToken = PostCustomerTokenIdpModel(customerGuid: self.customerGuid,
                                                          scopes: self.customerTokenScopes)
        CustomerTokensAPI.createCustomerToken(postCustomerTokenIdpModel: postCustomerToken) { [self] result in
            switch result {
                
            case .success(let token):

                config.bearer = token.accessToken ?? ""
                self.getBank(environment: environment,
                             bearer: bearer,
                             config: config,
                             completion: completion)
                
            case.failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    func getBank(environment: CybridEnvironment, bearer: String, config: PreSdkConfig, completion: @escaping (Result<PreSdkConfig, Error>) -> Void) {
        
        // -- Set Bank environment
        CybridApiBankSwiftAPI.basePath = environment.baseBankPath
        
        // -- Set headers
        CybridApiBankSwiftAPI.customHeaders = ["Authorization": "Bearer " + bearer]
        
        // -- Get bank
        // BanksAPI.
    }
}
