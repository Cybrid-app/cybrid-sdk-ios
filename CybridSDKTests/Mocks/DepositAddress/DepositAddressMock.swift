//
//  DepositAddressMock.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 27/07/23.
//

import CybridApiBankSwift

extension DepositAddressListBankModel {

    static let mock = DepositAddressListBankModel(
        total: 1,
        page: 1,
        perPage: 1,
        objects: [DepositAddressBankModel.mock]
    )
}

extension DepositAddressBankModel {

    static let mock = DepositAddressBankModel(
        guid: "1234",
        bankGuid: "1234",
        customerGuid: "1234",
        accountGuid: "1234",
        createdAt: Date(),
        asset: "BTC",
        state: "created",
        address: "qwerty123456789",
        format: "legacy",
        tag: "123456"
    )
}
