//
//  CoinData.swift
//  ByteCoin-Angela
//
//  Created by Павел Грицков on 23.02.23.
//

import Foundation

struct CoinData: Codable {
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
