//
//  CurrencyLocalStore.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/28.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation

enum DefaultsKey: String {
    case quotesFetchedTimestamp
    case currenciesFetchedTimestamp
    case baseCurrencyCode
}

protocol CurrencyLocalStoreProtocol {
    func get<T>(for key: DefaultsKey) -> T?
    func set<T>(value: T?, for key: DefaultsKey)
}

class CurrencyLocalStore: CurrencyLocalStoreProtocol {
    
    static let shared = CurrencyLocalStore()
    
    private let defaults: UserDefaults = UserDefaults.standard
    
    private init() {}
    
    func get<T>(for key: DefaultsKey) -> T? {
        return defaults.object(forKey: key.rawValue) as? T
    }
    
    func set<T>(value: T?, for key: DefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
}
