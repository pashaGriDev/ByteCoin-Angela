//
//  CoinManager.swift
//  ByteCoin-Angela
//
//  Created by Павел Грицков on 23.02.23.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinPrice(_ coinManager: CoinManager, coinModel: CoinModel)
    func didFailWithError(_ coinManager: CoinManager, error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = Keys.coinapi
    
    let currencyArray =
    ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR",
     "JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString) { data in
            parseJSON(data)
        }
    }
    
    private func performRequest(with urlString: String, complition: @escaping (Data) -> Void) {
           if let url = URL(string: urlString) {
               let session = URLSession(configuration: .default)
               let task = session.dataTask(with: url) { data, response, error in
                   if let error {
                       delegate?.didFailWithError(self, error: error)
                       return
                   }
                   if let safeData = data {
                       complition(safeData)
                   }
               }
               task.resume()
           } else {
               print("Failed URL!")
           }
       }
    
    func parseJSON(_ safeData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(CoinData.self, from: safeData)
            
            let rate = String(format: "%.2f", decodeData.rate)
            let base = decodeData.asset_id_base
            let quote = decodeData.asset_id_quote
            
            let coinModel = CoinModel(currencyBase: base, currencyQuote: quote, rate: rate)
            delegate?.didUpdateCoinPrice(self, coinModel: coinModel)
            
        } catch {
            delegate?.didFailWithError(self, error: error)
        }
    }
    
}
