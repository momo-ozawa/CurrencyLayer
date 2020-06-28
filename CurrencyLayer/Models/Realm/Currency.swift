//
//  Currency.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/27.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation
import RealmSwift

class Currency: Object {
    @objc dynamic var code: String = ""
    @objc dynamic var name: String = ""

    override class func primaryKey() -> String? {
        return "code"
    }
}
