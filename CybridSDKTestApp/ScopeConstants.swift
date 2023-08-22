//
//  ScopeConstants.swift
//  CybridSDKTestApp
//
//  Created by Erick Sanchez Perez on 08/06/23.
//

import CybridApiBankSwift
import CybridApiIdpSwift

struct ScopeContants {
    
    internal static let bankTokenScopes = "banks:read banks:write customers:read customers:write customers:execute"
    
    internal static let customerTokenScopes: Set<PostCustomerTokenIdpModel.ScopesIdpModel> = [
        .customersRead, .customersWrite, .accountsRead, .accountsExecute, .pricesRead, .quotesRead, .quotesExecute, .tradesRead, .tradesExecute, .transfersRead, .transfersExecute, .externalBankAccountsRead, .externalBankAccountsWrite, .externalBankAccountsExecute, .workflowsRead, .workflowsExecute, .depositAddressesRead, .depositAddressesExecute, .externalWalletsRead, .externalWalletsExecute
    ]
}
