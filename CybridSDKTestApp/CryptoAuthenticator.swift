//
//  CryptoAuthenticator.swift
//  CybridSDKTestApp
//
//  Created by Cybrid on 12/07/22.
//

import CybridSDK
import Foundation
import CybridApiIdpSwift

class CryptoAuthenticator {

    private let session: URLSession
    private let tokenScopes = "banks:read banks:write accounts:read accounts:execute customers:read customers:write customers:execute prices:read quotes:execute trades:execute trades:read workflows:execute workflows:read external_bank_accounts:execute external_bank_accounts:read external_bank_accounts:write transfers:read transfers:execute"
    // private let customerTokenScopes: Set<ScopesIdpModel> = 
    private var clientId: String = ""
    private var clientSecret: String = ""

    init(session: URLSession, clientId: String, clientSecret: String) {

        self.session = session
        self.clientId = clientId
        self.clientSecret = clientSecret
    }

    func getBearer(env: CybridEnvironment, completion: @escaping (Result<String, Error>) -> Void) {

        guard let url = URL(string: "https://id.\(env).cybrid.app/oauth/token") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "grant_type": "client_credentials",
            "client_id": self.clientId,
            "client_secret": self.clientSecret,
            "scope": self.params
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            completion(.failure(error))
            return
        }

        session.dataTask(with: request) { data, response, error in

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
                        completion(.success(bearer))
                        return
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
}
