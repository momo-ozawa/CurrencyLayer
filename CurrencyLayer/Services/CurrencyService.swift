//
//  CurrencyService.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/26.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation
import RxSwift

protocol CurrencyServiceProtocol {
    func getUSDRate(for currencyCode: String) -> Observable<Double>
    func getExchangeRates(for amount: Double, baseValue: Double) -> Observable<[ExchangeRate]>
    func getCurrencyArray() -> Observable<[Currency]>
}

struct CurrencyService: CurrencyServiceProtocol {
    
    let apiType: CurrencyLayerAPIProtocol.Type
    
    init(apiType: CurrencyLayerAPIProtocol.Type) {
        self.apiType = apiType
    }
    
    func getUSDRate(for currencyCode: String) -> Observable<Double> {
        return getQuotesArray()
            .map {
                $0.first { quote in
                    quote.currencyCode == currencyCode
                    }?.exchangeRateValue ?? 1.0
            }
    }
    
    
    func getExchangeRates(for amount: Double, baseValue: Double) -> Observable<[ExchangeRate]> {
        return getQuotesArray()
            .map {
                $0.map { quote in
                    let convertedValue = quote.exchangeRateValue / baseValue * amount
                    return ExchangeRate(targetCurrencyCode: quote.currencyCode, value: convertedValue)
                }
            }
            .map { exchangeRates in
                exchangeRates.sorted { (lhs, rhs) in
                    lhs.targetCurrencyCode < rhs.targetCurrencyCode
                }
            }
        
    }
    
    func getCurrencyArray() -> Observable<[Currency]> {
        return apiType.getCurrencies()
            .map {
                $0.currencies.map { code, name in
                    Currency(code: code, name: name)
                }
            }
            .map { currencies in
                currencies.sorted { (lhs, rhs) in
                    lhs.code < rhs.code
                }
            }
    }

}

extension CurrencyService {
    
    private func getQuotesArray() -> Observable<[Quote]> {
        return apiType.getQuotes()
            .map {
                $0.quotes.map { currencyPair, exchangeRateValue in
                    let code = String(currencyPair.suffix(3))
                    return Quote(currencyCode: code, exchangeRateValue: exchangeRateValue)
                }
            }
    }
}
