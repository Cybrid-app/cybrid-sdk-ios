//
//  IdentityVerificationWithDetailsBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 06/12/22.
//

import Foundation
import CybridApiBankSwift

extension IdentityVerificationWithDetailsBankModel {

    init?(json: [String: Any]) {

        guard
            let createdAt = json[IdentityVerificationWithDetailsBankModel.CodingKeys.createdAt.rawValue] as? String
        else {
            return nil
        }

        let type = json[IdentityVerificationWithDetailsBankModel.CodingKeys.type.rawValue] as? String ?? ""
        let method = json[IdentityVerificationWithDetailsBankModel.CodingKeys.method.rawValue] as? String ?? ""
        let state = json[IdentityVerificationWithDetailsBankModel.CodingKeys.state.rawValue] as? String ?? ""
        let outcome = json[IdentityVerificationWithDetailsBankModel.CodingKeys.outcome.rawValue] as? String ?? ""
        let personaState = json[IdentityVerificationWithDetailsBankModel.CodingKeys.personaState.rawValue] as? String ?? ""

        let codingKeys = IdentityVerificationWithDetailsBankModel.CodingKeys.self
        let createdAtDate = getDate(stringDate: createdAt)

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            customerGuid: json[codingKeys.customerGuid.rawValue] as? String ?? "",
            type: IdentityVerificationWithDetailsBankModel.TypeBankModel(rawValue: type) ?? .kyc,
            method: IdentityVerificationWithDetailsBankModel.MethodBankModel(rawValue: method) ?? .idAndSelfie,
            createdAt: createdAtDate,
            state: IdentityVerificationWithDetailsBankModel.StateBankModel(rawValue: state) ?? .storing,
            outcome: IdentityVerificationWithDetailsBankModel.OutcomeBankModel(rawValue: outcome) ?? .passed,
            failureCodes: nil,
            personaInquiryId: json[codingKeys.personaInquiryId.rawValue] as? String ?? "",
            personaState: IdentityVerificationWithDetailsBankModel.PersonaStateBankModel(rawValue: personaState) ?? .unknown)
    }

    static func fromArray(objects: [[String: Any]]) -> [IdentityVerificationWithDetailsBankModel] {

        var models = [IdentityVerificationWithDetailsBankModel]()
        for object in objects {
            // -- Creating the AccountBankModel
            let model = IdentityVerificationWithDetailsBankModel(json: object)
            if let model = model {
                models.append(model)
            }
        }
        return models
    }
}
