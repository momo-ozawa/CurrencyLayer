//
//  ExchangeRate.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/27.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation

struct ExchangeRate {
    let targetCurrencyCode: String
    let value: Double
}

extension ExchangeRate {
    var displayedValue: String {
        return String(format: "%.3f", self.value)
    }
}
