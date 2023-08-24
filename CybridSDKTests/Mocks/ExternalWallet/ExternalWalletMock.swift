//
//  ExternalWalletMock.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 23/08/23.
//

import CybridApiBankSwift

extension ExternalWalletBankModel {

    static let mock = ExternalWalletBankModel(
        guid: "1234",
        name: "BTC",
        asset: "BTC",
        environment: .sandbox,
        bankGuid: "1234",
        customerGuid: "1234",
        address: "_123456",
        tag: "",
        createdAt: Date(),
        state: .completed,
        failureCode: ""
    )
}

extension ExternalWalletListBankModel {

    static let mock = ExternalWalletListBankModel(
        total: 1,
        page: 0,
        perPage: 1,
        objects: [
            ExternalWalletBankModel.mock
        ]
    )
}
