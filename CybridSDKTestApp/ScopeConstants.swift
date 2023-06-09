//
//  ScopeConstants.swift
//  CybridSDKTestApp
//
//  Created by Erick Sanchez Perez on 08/06/23.
//

import CybridApiBankSwift
import CybridApiIdpSwift

struct ScopeContants {
    
    internal static let bankTokenScopes = "banks:read banks:write accounts:read accounts:execute customers:read customers:write customers:execute prices:read quotes:execute trades:execute trades:read workflows:execute workflows:read external_bank_accounts:execute external_bank_accounts:read external_bank_accounts:write transfers:read transfers:execute"

    internal static let customerTokenScopes: Set<PostCustomerTokenIdpModel.ScopesIdpModel> = [
        .customersRead, .customersWrite, .accountsRead, .accountsExecute, .pricesRead, .quotesRead, .quotesExecute, .tradesRead, .tradesExecute, .transfersRead, .transfersExecute, .externalBankAccountsRead, .externalBankAccountsWrite, .externalBankAccountsExecute, .workflowsRead, .workflowsExecute
    ]
}
