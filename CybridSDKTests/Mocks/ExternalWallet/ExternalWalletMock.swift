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
        environment: "sandbox",
        bankGuid: "1234",
        customerGuid: "1234",
        address: "_123456",
        tag: "",
        createdAt: Date(),
        state: "completed",
        failureCode: ""
    )

    static let mockEth = ExternalWalletBankModel(
        guid: "1234",
        name: "ETH",
        asset: "ETH",
        environment: "sandbox",
        bankGuid: "1234",
        customerGuid: "1234",
        address: "_1234x6",
        tag: "",
        createdAt: Date(),
        state: "completed",
        failureCode: ""
    )

    static let mockDeleted = ExternalWalletBankModel(
        guid: "12342",
        name: "BTC",
        asset: "BTC",
        environment: "sandbox",
        bankGuid: "1234",
        customerGuid: "1234",
        address: "_123456",
        tag: "",
        createdAt: Date(),
        state: "deleted",
        failureCode: ""
    )

    static let mockDeleting = ExternalWalletBankModel(
        guid: "12342",
        name: "BTC",
        asset: "BTC",
        environment: "sandbox",
        bankGuid: "1234",
        customerGuid: "1234",
        address: "_123456",
        tag: "",
        createdAt: Date(),
        state: "deleting",
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

    static let mockWithDeletes = ExternalWalletListBankModel(
        total: 1,
        page: 0,
        perPage: 1,
        objects: [
            ExternalWalletBankModel.mock,
            ExternalWalletBankModel.mockDeleted,
            ExternalWalletBankModel.mockDeleting
        ]
    )

    static let mockForCrpytoTransfer = ExternalWalletListBankModel(
        total: 1,
        page: 0,
        perPage: 1,
        objects: [
            ExternalWalletBankModel.mock,
            ExternalWalletBankModel.mockEth,
            ExternalWalletBankModel.mockDeleted,
            ExternalWalletBankModel.mockDeleting
        ]
    )
}
