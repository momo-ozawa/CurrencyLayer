//
//  CurrencyLayerRouter.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/24.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Alamofire
import Foundation

enum CurrencyLayerRouter: URLRequestConvertible {
    
    private enum Constants {
        static let baseURLPath = "http://api.currencylayer.com"
        static let apiKey = "b12b94fe84ac68d947e800e31ce96f65"
    }
    
    case currencies
    case quotes
    
    var method: HTTPMethod {
        switch self {
        case .currencies, .quotes:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .currencies:
            return "/list"
        case .quotes:
            return "/live"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .currencies, .quotes:
            return ["access_key": Constants.apiKey]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
    
}
