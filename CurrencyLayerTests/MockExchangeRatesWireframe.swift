//
//  MockExchangeRatesWireframe.swift
//  CurrencyLayerTests
//
//  Created by Momo Ozawa on 2020/06/28.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import RxCocoa
import RxSwift
import XCTest
@testable import CurrencyLayer

class MockExchangeRatesWireframe: ExchangeRatesWireframeProtocol {
    
    func routeToSupportedCurrencies(with currencyCode: BehaviorRelay<String>) {
        
    }
    
}
