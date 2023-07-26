//
//  AccountTransfersViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 03/04/23.
//

import Foundation
import CybridApiBankSwift

class AccountTransfersViewModel: NSObject {
    
    // MARK: Static Final Vars
    static let assetNotFound = "error"

    // MARK: Observed properties
    internal var tranfers: Observable<[TransferBankModel]> = .init([])

    // MARK: Private properties
    private unowned var cellProvider: AccountTransfersViewProvider
    private var dataProvider: TransfersRepoProvider
    private var logger: CybridLogger?

    internal var assets = Cybrid.assets
    internal var currentAccountGUID: String = ""

    init(cellProvider: AccountTransfersViewProvider,
         dataProvider: TransfersRepoProvider,
         logger: CybridLogger?) {

        self.cellProvider = cellProvider
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
            guard let trasnferAsset = transfer.asset else {
                return assetNotFound
            }
            let asset = try Cybrid.findAsset(code: trasnferAsset)
            let amount = transfer.state == .completed ? transfer.amount ?? 0 : transfer.estimatedAmount ?? 0
            let amountValue = CDecimal(amount)
            let amountFormatted = AssetFormatter.forBase(asset, amount: amountValue)
            return amountFormatted
        } catch {
            return assetNotFound
        }
    }

    internal static func getAmountOfTransferInFormat(_ transfer: TransferBankModel) -> String {
        do {
            let amountFormatted = AccountTransfersViewModel.getAmountOfTransfer(transfer)
            if amountFormatted != assetNotFound {
                guard let trasnferAsset = transfer.asset else {
                    return assetNotFound
                }
                let asset = try Cybrid.findAsset(code: trasnferAsset)
                return AssetFormatter.format(asset, amount: amountFormatted)
            } else {
                return assetNotFound
            }
        } catch {
            return assetNotFound
        }
    }
}

// MARK: - AccountTransfersViewProvider

protocol AccountTransfersViewProvider: AnyObject {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData model: TransferBankModel) -> UITableViewCell

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, with transfer: TransferBankModel)
}

// MARK: - AccountTransfersViewModel + UITableViewDelegate + UITableViewDataSource

extension AccountTransfersViewModel: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tranfers.value.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellProvider.tableView(tableView, cellForRowAt: indexPath, withData: self.tranfers.value[indexPath.row])
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return AccountTransfersHeaderCell()
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellProvider.tableView(tableView, didSelectRowAt: indexPath, with: self.tranfers.value[indexPath.row])
    }
}
