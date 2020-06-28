//
//  Quotes.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/24.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation

struct Quotes: Decodable {
    typealias CurrencyPair = String
    
    var success: Bool
    var timestamp: Double // Unix timestamp
    var source: String
    var quotes: [CurrencyPair: Double]
}

