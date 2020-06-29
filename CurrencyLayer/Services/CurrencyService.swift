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
    func getBaseCurrencyCode() -> String?
    func setBaseCurrencyCode(_ code: String)
}

class CurrencyService: CurrencyServiceProtocol {

    private let API: CurrencyAPIProtocol
    private let realmStore: CurrencyRealmStoreProtocol
    private let localStore: CurrencyLocalStore

    init(API: CurrencyAPIProtocol, realmStore: CurrencyRealmStoreProtocol, localStore: CurrencyLocalStore) {
        self.API = API
        self.realmStore = realmStore
        self.localStore = localStore
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
                let exchangeRates: [ExchangeRate] = $0.map { quote in
                    let convertedValue = quote.exchangeRateValue / baseValue * amount
                    return ExchangeRate(targetCurrencyCode: quote.currencyCode, value: convertedValue)
                }

                return exchangeRates.sorted { (lhs, rhs) in
                    lhs.targetCurrencyCode < rhs.targetCurrencyCode
                }
            }
    }

    func getCurrencyArray() -> Observable<[Currency]> {

        if let timestamp: Date = localStore.get(for: .currenciesFetchedTimestamp), Date() < timestamp + 30 * 60,
           let fetchedCurrencies = realmStore.getCurrencies() {
            return Observable.of(fetchedCurrencies)
        }

        return API.getCurrencies()
            .map { response in

                self.localStore.set(value: Date(), for: .currenciesFetchedTimestamp)

                let currencies: [Currency] = response.currencies.compactMap { [weak self] code, name in
                    let currency = self?.realmStore.addOrUpdateCurrency(code: code, name: name)
                    return currency
                }

                return currencies.sorted { (lhs, rhs) in
                    lhs.code < rhs.code
                }
            }
    }

    func getBaseCurrencyCode() -> String? {
        return localStore.get(for: .baseCurrencyCode)
    }

    func setBaseCurrencyCode(_ code: String) {
        localStore.set(value: code, for: .baseCurrencyCode)
    }

}

extension CurrencyService {

    private func getQuotesArray() -> Observable<[Quote]> {

        if let timestamp: Date = localStore.get(for: .quotesFetchedTimestamp), Date() < timestamp + 30 * 60,
           let fetchedQuotes = realmStore.getQuotes() {
            return Observable.of(fetchedQuotes)
        }

        return API.getQuotes()
            .map { [weak self] response in

                if response.success {
                    self?.localStore.set(value: Date(), for: .quotesFetchedTimestamp)
                }

                let quotes: [Quote] = response.quotes.compactMap { [weak self] currencyPair, exchangeRateValue in
                    let code = String(currencyPair.suffix(3))
                    let quote = self?.realmStore.addOrUpdateQuote(
                        currencyCode: code,
                        exchangeRateValue: exchangeRateValue
                    )
                    return quote
                }

                return quotes
        }
    }

}
