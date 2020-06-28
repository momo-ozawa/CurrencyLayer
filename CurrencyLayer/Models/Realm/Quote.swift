//
//  Quote.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/27.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation
import RealmSwift

class Quote: Object {
    @objc dynamic var currencyCode: String = ""
    @objc dynamic var exchangeRateValue: Double = 0.0
    
    override class func primaryKey() -> String? {
        return "currencyCode"
    }
}
