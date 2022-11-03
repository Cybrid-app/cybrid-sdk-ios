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
    internal var customerGuid = Cybrid.customerGUID

    // MARK: Public properties
    var UIState: Observable<IdentityVerificationViewController.KYCViewState> = .init(.LOADING)
    var latestIdentityVerification: IdentityVerificationBankModel?

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

        self.dataProvider.createCustomer { [weak self] customerResponse in

            switch customerResponse {

            case .success(let customer):
                // self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                print("CREATE CUSTOMER")
                print(customer)
                print("---------------------------")
                self?.customerGuid = customer.guid ?? (self?.customerGuid ?? "")
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
                // self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                print("CUSTOMER STATUS")
                print(customer)
                print("---------------------------")
                self?.checkCustomerStatus(state: customer.state ?? .storing)

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
    }

    func getIdentityVerificationStatus(record: IdentityVerificationBankModel? = nil) {

        if record == nil {

            self.fetchLastIdentityVerification { [weak self] lastVerification in

                print("---> LAST VERIFICATION")
                print(lastVerification)
                print("---------------------------")

                if lastVerification == nil || lastVerification?.state == .expired || lastVerification?.personaState == .expired {

                    self?.createIdentityVerification { [weak self] recordIdentity in

                        print("-----> CREATION")
                        print(recordIdentity)
                        print("---------------------------")

                        self?.fetchIdentityVerificationStatus(record: recordIdentity)
                    }
                } else {
                    self?.fetchIdentityVerificationStatus(record: lastVerification)
                }
            }

        } else {
            if record?.state == .expired || record?.personaState == .expired {

                self.createIdentityVerification { [weak self] recordIdentity in

                    print("-----> CREATION")
                    print(recordIdentity)
                    print("---------------------------")

                    self?.fetchIdentityVerificationStatus(record: recordIdentity)
                }
            } else {
                self.fetchIdentityVerificationStatus(record: record)
            }
        }
    }

    func fetchIdentityVerificationStatus(record: IdentityVerificationBankModel?) {

        self.dataProvider.getIdentityVerification(guid: record?.guid ?? "") { [weak self] identityResponse in

            switch identityResponse {

            case .success(let record):
                print("IDENTITY STATUS")
                print(record)
                print("---------------------------")
                self?.checkIdentityRecordStatus(record: record)

            case .failure:
                self?.logger?.log(.component(.accounts(.pricesDataError)))
            }
        }
    }

    func fetchLastIdentityVerification(_ completion: @escaping (_ record: IdentityVerificationBankModel?) -> Void) {

        self.dataProvider.listIdentityVerifications(customerGuid: self.customerGuid) { [weak self] listCustomerResponse in

            switch listCustomerResponse {

            case .success(let list):
                // self?.logger?.log(.component(.accounts(.pricesDataFetching)))
                print("VERIFICATIONS LIST")
                print(list)
                print("---------------------------")

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

                print("CREATED VERIFICATION")
                print(identity)
                print("---------------------")
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

    func checkIdentityRecordStatus(record: IdentityVerificationBankModel?) {

        switch record?.state {

        case .storing:

            if identityJob == nil {
                identityJob = Polling { self.getIdentityVerificationStatus(record: record) }
            }

        case .waiting:

            if record?.personaState == .completed || record?.personaState == .processing {
                if identityJob == nil {
                    self.identityJob = Polling { self.getIdentityVerificationStatus(record: record) }
                }
            } else {

                self.identityJob?.stop()
                self.identityJob = nil
                self.checkIdentityPersonaStatus(record: record)
            }

        case .expired:

            self.identityJob?.stop()
            self.identityJob = nil
            self.getIdentityVerificationStatus(record: nil)

        case .completed:

            self.identityJob?.stop()
            self.identityJob = nil
            UIState.value = .VERIFIED

        default:
            print("--")
        }
    }

    func checkIdentityPersonaStatus(record: IdentityVerificationBankModel?) {

        switch record?.personaState {

        case .waiting:

            self.latestIdentityVerification = record
            UIState.value = .REQUIRED

        case .pending:

            self.latestIdentityVerification = record
            UIState.value = .REQUIRED

        case .reviewing:

            UIState.value = .REVIEWING

        case .unknown:

            UIState.value = .ERROR

        default:
            print("--")
        }
    }
}
