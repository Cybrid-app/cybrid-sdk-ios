//
//  AccountTransfersViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 03/04/23.
//

import Foundation
import CybridApiBankSwift

open class AccountTransfersViewModel: NSObject {

    // MARK: Observed properties
    internal var tranfers: Observable<[TransferBankModel]> = .init([])

    // MARK: Private properties
    private var dataProvider: TransfersRepoProvider
    private var logger: CybridLogger?

    internal var assets = Cybrid.assets
    internal var currentAccountGUID: String = ""

    init(dataProvider: TransfersRepoProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }

    func getTransfers(accountGuid: String) {

        self.currentAccountGUID = accountGuid
        self.dataProvider.fetchTransfers(accountGuid: accountGuid) { [weak self] transferResult in

            switch transferResult {
            case .success(let transferList):
                self?.logger?.log(.component(.trades(.tradesDataFetching)))
                self?.tranfers.value = transferList.objects

            case .failure:
                self?.logger?.log(.component(.trades(.tradesDataError)))
            }
        }
    }

    internal static func getAmountOfTransfer(_ transfer: TransferBankModel) -> String {
        do {
            guard let transferAsset = transfer.asset else {
                return CybridConstants.transferAssetError
            }
            let asset = try Cybrid.findAsset(code: transferAsset)
            let amount = transfer.state == "completed" ? transfer.amount ?? 0 : transfer.estimatedAmount ?? 0
            let amountValue = CDecimal(amount)
            let amountFormatted = AssetFormatter.forBase(asset, amount: amountValue)
            return amountFormatted
        } catch {
            return CybridConstants.transferAssetError
        }
    }

    internal static func getAmountOfTransferInFormat(_ transfer: TransferBankModel) -> String {
        let amountFormatted = AccountTransfersViewModel.getAmountOfTransfer(transfer)
        if amountFormatted == CybridConstants.transferAssetError {
            return CybridConstants.transferAssetError
        }
        // swiftlint:disable:next force_try
        let asset = try! Cybrid.findAsset(code: transfer.asset!)
        return AssetFormatter.format(asset, amount: amountFormatted)
    }
}
