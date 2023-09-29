//
//  SDKConfig.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 01/06/23.
//

import Foundation
import CybridApiBankSwift

public final class SDKConfig {

    private static let defaultAssets = ["BTC", "ETH", "SOL", "USDC"]

    public var environment: CybridEnvironment = .sandbox
    public var bearer: String = ""
    public var customerGuid: String = ""
    public var customer: CustomerBankModel?
    public var bank: BankBankModel?
    public var assetsForCreateDepositAddres: [String] = defaultAssets

    public init(
        environment: CybridEnvironment = .sandbox,
        bearer: String = "",
        customerGuid: String = "",
        customer: CustomerBankModel? = nil,
        bank: BankBankModel? = nil,
        assetsForCreateDepositAddres: [String] = []
    ) {

        self.environment = environment
        self.bearer = bearer
        self.customerGuid = customerGuid
        self.customer = customer
        self.bank = bank
        if !assetsForCreateDepositAddres.isEmpty {
            self.assetsForCreateDepositAddres = assetsForCreateDepositAddres
        }
    }
}
