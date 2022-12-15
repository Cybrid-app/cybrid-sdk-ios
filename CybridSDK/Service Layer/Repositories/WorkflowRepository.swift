//
//  WorkflowsRepository.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 04/12/22.
//

import Foundation
import CybridApiBankSwift

typealias FetchWorkflowCompletion = (Result<WorkflowWithDetailsBankModel, ErrorResponse>) -> Void
typealias CreateWorkflowCompletion = (Result<WorkflowBankModel, ErrorResponse>) -> Void

protocol WorkflowRepository {

    static func fetchWorkflow(guid: String, _ completion: @escaping FetchWorkflowCompletion)
    static func createWorkflow(postWorkflowBankModel: PostWorkflowBankModel, _ completion: @escaping CreateWorkflowCompletion)
}

protocol WorkflowProvider: AuthenticatedServiceProvider {
    var workflowRepository: WorkflowRepository.Type { get set }
}

// MARK: WorkflowProvider Extensions
extension WorkflowProvider {

    func fetchWorkflow(guid: String, _ completion: @escaping FetchWorkflowCompletion) {
        authenticatedRequest(workflowRepository.fetchWorkflow,
                             parameters: guid,
                             completion: completion)
    }

    func createWorkflow(postWorkflowBankModel: PostWorkflowBankModel, _ completion: @escaping CreateWorkflowCompletion) {
        authenticatedRequest(workflowRepository.createWorkflow,
                             parameters: postWorkflowBankModel,
                             completion: completion)
    }
}

// MARK: CybridSession Extensions
extension CybridSession: WorkflowProvider {}

// MARK: WorkflowsAPI Extensions
extension WorkflowsAPI: WorkflowRepository {

    static func fetchWorkflow(guid: String, _ completion: @escaping FetchWorkflowCompletion) {
        getWorkflow(workflowGuid: guid, completion: completion)
    }

    static func createWorkflow(postWorkflowBankModel: PostWorkflowBankModel, _ completion: @escaping CreateWorkflowCompletion) {
        createWorkflow(postWorkflowBankModel: postWorkflowBankModel, completion: completion)
    }

}
