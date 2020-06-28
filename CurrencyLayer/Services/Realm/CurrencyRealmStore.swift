//
//  CurrencyRealmStore.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/27.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

protocol CurrencyRealmStoreProtocol {
    func addOrUpdateCurrency(code: String, name: String) -> Currency?
    func addOrUpdateQuote(currencyCode: String, exchangeRateValue: Double) -> Quote?
    func getCurrencies() -> [Currency]?
    func getQuotes() -> [Quote]?
}

class CurrencyRealmStore: CurrencyRealmStoreProtocol {

    static let shared = CurrencyRealmStore()

    private init() {}

    func addOrUpdateCurrency(code: String, name: String) -> Currency? {
        do {
            let currency = Currency()
            currency.code = code
            currency.name = name
            let realm = try Realm()
            try realm.write {
                realm.add(currency, update: .modified)
            }
            return currency
        } catch let error {
            print("Failed to add Realm object: \(error.localizedDescription)")
            return nil
        }
    }

    func addOrUpdateQuote(currencyCode: String, exchangeRateValue: Double) -> Quote? {
        do {
            let quote = Quote()
            quote.currencyCode = currencyCode
            quote.exchangeRateValue = exchangeRateValue
            let realm = try Realm()
            try realm.write {
                realm.add(quote, update: .modified)
            }
            return quote
        } catch let error {
            print("Failed to add Realm object: \(error.localizedDescription)")
            return nil
        }
    }

    func getCurrencies() -> [Currency]? {
        do {
            let realm = try Realm()
            let currencies = realm.objects(Currency.self).sorted(byKeyPath: "code", ascending: true)
            return currencies.toArray()
        } catch let error {
            print("Failed to find Realm objects: \(error.localizedDescription)")
            return nil
        }
    }

    func getQuotes() -> [Quote]? {
        do {
            let realm = try Realm()
            let quotes = realm.objects(Quote.self).sorted(byKeyPath: "currencyCode", ascending: true)
            return quotes.toArray()
        } catch let error {
            print("Failed to find Realm objects: \(error.localizedDescription)")
            return nil
        }
    }

}
