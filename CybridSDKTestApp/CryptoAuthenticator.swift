//
//  CryptoAuthenticator.swift
//  CybridSDKTestApp
//
//  Created by Cybrid on 12/07/22.
//

import CybridSDK
import Foundation

class CryptoAuthenticator: CybridAuthenticator {

    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func getBearer(completion: @escaping (Result<CybridBearer, Error>) -> Void) {

        guard let url = URL(string: "https://id.demo.cybrid.app/oauth/token") else {
            completion(.failure(CybridError.authenticationError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let id = Bundle.main.object(forInfoDictionaryKey: "CybridClientId")
        let secret = Bundle.main.object(forInfoDictionaryKey: "CybridClientSecret")
        let parameters: [String: Any] = [
            "grant_type": "client_credentials",
            "client_id": id ?? "",
            "client_secret": secret ?? "",
            "scope": "banks:read banks:write accounts:read accounts:execute customers:read customers:write customers:execute prices:read quotes:execute trades:execute trades:read"
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
                completion(.failure(CybridError.serviceError))
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
