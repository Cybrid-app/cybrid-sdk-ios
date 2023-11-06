//
//  QuotesRepository.swift
//  CybridSDK
//
//  Created by Cybrid on 22/08/22.
//

import BigInt
import CybridApiBankSwift

typealias CreateQuoteCompletion = (Result<QuoteBankModel, ErrorResponse>) -> Void

protocol QuotesRepository {
    static func createQuote(postQuoteBankModel: PostQuoteBankModel, _ completion: @escaping CreateQuoteCompletion)
}

protocol QuotesRepoProvider: AuthenticatedServiceProvider {

    var quotesRepository: QuotesRepository.Type { get set }
}

extension QuotesRepoProvider {

    func createQuote(postQuoteBankModel: PostQuoteBankModel, _ completion: @escaping CreateQuoteCompletion) {
        authenticatedRequest(quotesRepository.createQuote, parameters: postQuoteBankModel, completion: completion)
    }
}

extension CybridSession: QuotesRepoProvider {}

extension QuotesAPI: QuotesRepository {

    static func createQuote(postQuoteBankModel: PostQuoteBankModel, _ completion: @escaping CreateQuoteCompletion) {
        createQuote(postQuoteBankModel: postQuoteBankModel, completion: completion)
    }
}
