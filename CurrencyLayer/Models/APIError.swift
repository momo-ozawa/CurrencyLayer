//
//  APIError.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/24.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation

struct APIError: Error, Decodable {
    var error: ErrorDetail
}

struct ErrorDetail: Decodable {
    let code: Int
    let info: String
}
