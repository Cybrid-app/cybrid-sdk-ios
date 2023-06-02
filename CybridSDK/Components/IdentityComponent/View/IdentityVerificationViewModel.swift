//
//  IdentityVerificationViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 01/11/22.
//

import Foundation
import CybridApiBankSwift
import Persona2

class IdentityVerificationViewModel: NSObject {

    // MARK: Private properties
    private var dataProvider: CustomersRepoProvider & IdentityVerificationRepoProvider
    private var logger: CybridLogger?

    // MARK: Internal properties
    internal var customerJob: Polling?
    internal var identityJob: Polling?
    internal var customerGuid = Cybrid.customerGuid

    // MARK: Public properties
    var UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
    var latestIdentityVerification: IdentityVerificationWrapper?

    // MARK: Constructor
    init(dataProvider: CustomersRepoProvider & IdentityVerificationRepoProvider,
         UIState: Observable<IdentityVerificationViewController.KYCViewState>,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.UIState = UIState
        self.logger = logger
    }

    // MARK: ViewModel Methods
    func createCustomerTest() {

        let postCustomerBankModel = PostCustomerBankModel(type: .individual)
        self.dataProvider.createCustomer(postCustomerBankModel: postCustomerBankModel) { [weak self] customerResponse in

            switch customerResponse {

            case .success(let customer):
                self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                self?.customerGuid = customer.guid!
                self?.getCustomerStatus()

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
    }

    func getCustomerStatus() {

        self.dataProvider.getCustomer(customerGuid: self.customerGuid) { [weak self] customerResponse in

            switch customerResponse {

            case .success(let customer):
                self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                self?.checkCustomerStatus(state: customer.state ?? .storing)

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
    }

    func getIdentityVerificationStatus(identityWrapper: IdentityVerificationWrapper? = nil) {

        if identityWrapper?.identityVerification == nil {

            self.fetchLastIdentityVerification { [weak self] lastVerification in
                if lastVerification == nil || lastVerification?.state == .expired {
                    self?.createIdentityVerification { recordIdentity in
                        self?.fetchIdentityVerificationWithDetailsStatus(record: recordIdentity)
                    }
                } else {
                    self?.fetchIdentityVerificationWithDetailsStatus(record: lastVerification)
                }
            }

        } else {
            if identityWrapper?.identityVerification?.state == .expired {

                self.createIdentityVerification { [weak self] recordIdentity in
                    self?.fetchIdentityVerificationWithDetailsStatus(record: recordIdentity)
                }
            } else {
                self.fetchIdentityVerificationWithDetailsStatus(record: identityWrapper?.identityVerification)
            }
        }
    }

    func fetchIdentityVerificationWithDetailsStatus(record: IdentityVerificationBankModel?) {

        self.dataProvider.getIdentityVerification(guid: record?.guid ?? "") { [weak self] identityResponse in

            switch identityResponse {

            case .success(let recordDetails):

                let wrapper = IdentityVerificationWrapper(identity: record, details: recordDetails)
                self?.checkIdentityRecordStatus(wrapper: wrapper)

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
    }

    func fetchLastIdentityVerification(_ completion: @escaping (_ record: IdentityVerificationBankModel?) -> Void) {

        self.dataProvider.listIdentityVerifications(customerGuid: self.customerGuid) { [weak self] listCustomerResponse in

            switch listCustomerResponse {

            case .success(let list):
                self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                if list.total > 0 {

                    let verifications = list.objects
                    let verification = verifications[0]
                    completion(verification)
                } else {
                    completion(nil)
                }

            case .failure:

                self?.logger?.log(.component(.accounts(.pricesDataError)))
                completion(nil)
            }
        }
    }

    func createIdentityVerification(_ completion: @escaping (_ record: IdentityVerificationBankModel?) -> Void) {

        let postIdentityVerificationBankModel = PostIdentityVerificationBankModel(
            type: .kyc,
            method: .idAndSelfie,
            customerGuid: self.customerGuid)

        self.dataProvider.createIdentityVerification(postIdentityVerificationBankModel: postIdentityVerificationBankModel) { [weak self] identityResponse in

            switch identityResponse {

            case .success(let identity):
                completion(identity)

            case .failure:

                self?.logger?.log(.component(.accounts(.pricesDataError)))
                completion(nil)
            }
        }
    }

    // MARK: Checker Funtions
    func checkCustomerStatus(state: CustomerBankModel.StateBankModel) {

        switch state {

        case .storing:
            if self.customerJob == nil {
                self.customerJob = Polling { self.getCustomerStatus() }
            }

        case .verified:

            self.customerJob?.stop()
            self.customerJob = nil
            self.UIState.value = .VERIFIED

        case .unverified:

            self.customerJob?.stop()
            self.customerJob = nil
            self.getIdentityVerificationStatus()

        case .rejected:

            self.customerJob?.stop()
            self.customerJob = nil
            self.UIState.value = .ERROR

        default:
            self.logger?.log(.component(.accounts(.pricesDataError)))

        }
    }

    func checkIdentityRecordStatus(wrapper: IdentityVerificationWrapper?) {

        switch wrapper?.identityVerificationDetails?.state {

        case .storing:

            if identityJob == nil {
                identityJob = Polling { self.getIdentityVerificationStatus(identityWrapper: wrapper) }
            }

        case .waiting:

            if wrapper?.identityVerificationDetails?.personaState == .completed || wrapper?.identityVerificationDetails?.personaState == .processing {
                if identityJob == nil {
                    self.identityJob = Polling { self.getIdentityVerificationStatus(identityWrapper: wrapper) }
                }
            } else {

                self.identityJob?.stop()
                self.identityJob = nil
                self.checkIdentityPersonaStatus(wrapper: wrapper)
            }

        case .expired:

            self.identityJob?.stop()
            self.identityJob = nil
            self.getIdentityVerificationStatus(identityWrapper: nil)

        case .completed:

            self.identityJob?.stop()
            self.identityJob = nil
            UIState.value = .VERIFIED

        default:

            self.identityJob?.stop()
            self.identityJob = nil
        }
    }

    func checkIdentityPersonaStatus(wrapper: IdentityVerificationWrapper?) {

        self.latestIdentityVerification = wrapper
        switch wrapper?.identityVerificationDetails?.personaState {

        case .waiting:

            UIState.value = .REQUIRED

        case .pending:

            UIState.value = .REQUIRED

        case .reviewing:

            UIState.value = .REVIEWING

        case .expired:

            getIdentityVerificationStatus(identityWrapper: nil)

        default:

            UIState.value = .ERROR
        }
    }
}

class IdentityVerificationWrapper {

    var identityVerification: IdentityVerificationBankModel?
    var identityVerificationDetails: IdentityVerificationWithDetailsBankModel?

    init(identity: IdentityVerificationBankModel?, details: IdentityVerificationWithDetailsBankModel?) {
        self.identityVerification = identity
        self.identityVerificationDetails = details
    }
}
