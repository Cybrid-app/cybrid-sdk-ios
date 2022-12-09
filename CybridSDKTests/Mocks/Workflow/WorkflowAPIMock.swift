//
//  WorkflowAPIMock.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 08/12/22.
//

import CybridApiBankSwift
import CybridSDK

final class WorkflowAPIMock: WorkflowsAPI {

    typealias CreateWorkflowCompletion = (_ result: Result<WorkflowBankModel, ErrorResponse>) -> Void
    typealias FetchWorkflowCompletion = (_ result: Result<WorkflowWithDetailsBankModel, ErrorResponse>) -> Void

    private static var createWorkflowCompletion: CreateWorkflowCompletion?
    private static var fetchWorkflowCompletion: FetchWorkflowCompletion?

    override class func createWorkflow(postWorkflowBankModel: PostWorkflowBankModel,
                                       apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                       completion: @escaping ((Result<WorkflowBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        createWorkflowCompletion = completion
        return createWorkflowWithRequestBuilder(postWorkflowBankModel: postWorkflowBankModel).requestTask
    }

    override class func getWorkflow(workflowGuid: String,
                                    apiResponseQueue: DispatchQueue = CybridApiBankSwiftAPI.apiResponseQueue,
                                    completion: @escaping ((Result<WorkflowWithDetailsBankModel, ErrorResponse>) -> Void)) -> RequestTask {
        fetchWorkflowCompletion = completion
        return getWorkflowWithRequestBuilder(workflowGuid: workflowGuid).requestTask
    }

    // MARK: Create Workflow States
    class func createWorkflowSuccessfully() {
        createWorkflowCompletion?(.success(WorkflowBankModel.mock()))
    }

    class func createWorkflowError() {
        createWorkflowCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }

    // MARK: Fetch Workflow States
    class func fetchWorkflowSuccessfully() {
        fetchWorkflowCompletion?(.success(WorkflowWithDetailsBankModel.mock()))
    }

    class func fetchWorkflow_Empty_Successfully() {
        fetchWorkflowCompletion?(.success(WorkflowWithDetailsBankModel.mockEmpty()))
    }

    class func fetchWorkflow_Incomplete_Successfully() {
        fetchWorkflowCompletion?(.success(WorkflowWithDetailsBankModel.mockIncomplete()))
    }

    class func fetchWorkflowError() {
        fetchWorkflowCompletion?(.failure(.error(0, nil, nil, CybridError.serviceError)))
    }
}

extension WorkflowBankModel {

    static func mock() -> Self {
        return WorkflowBankModel(
            guid: "1234",
            customerGuid: "1234",
            type: .plaid,
            createdAt: Date()
        )
    }
}

extension WorkflowWithDetailsBankModel {

    static func mock() -> Self {
        return WorkflowWithDetailsBankModel(
            guid: "1234",
            customerGuid: "1234",
            type: .plaid,
            createdAt: Date(),
            plaidLinkToken: "1234"
        )
    }

    static func mockEmpty() -> Self {
        return WorkflowWithDetailsBankModel(
            guid: "1234",
            customerGuid: "1234",
            type: .plaid,
            createdAt: Date(),
            plaidLinkToken: ""
        )
    }

    static func mockIncomplete() -> Self {
        return WorkflowWithDetailsBankModel(
            guid: "1234",
            customerGuid: "1234",
            type: .plaid,
            createdAt: Date()
        )
    }
}
