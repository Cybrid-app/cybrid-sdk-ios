//
//  CryptoPriceModel.swift
//  CybridSDK
//
//  Created by Cybrid on 20/06/22.
//

import Foundation

// MARK: - CryptoPriceModel

struct CryptoPriceModel: Equatable {
  let id: String // 12897019287
  let imageURL: String // https://abc.com/img.png
  let cryptoId: String // BTC
  let fiatId: String // USD
  let name: String // Bitcoin
  let price: Double // 20300.129870
}

/*
 MVVM
 - Model: datos que vienen del servicio
 - View: Lo que se ve en la pantalla
 - View Model: El que conecta los datos con la vista.
 */
