//
//  MockCurrencyService.swift
//  CurrencyLayerTests
//
//  Created by Momo Ozawa on 2020/06/28.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import RxSwift
import XCTest
@testable import CurrencyLayer

class MockCurrencyService: CurrencyServiceProtocol {
    
    private var getUSDRateMock: (String) -> Double
    private var getExchangeRatesMock: (Double, Double) -> [ExchangeRate]
//    private var getCurrencyArrayMock: () -> [Currency]
//    private var getBaseCurrencyCodeMock: () -> String?
//    private var setBaseCurrencyCodeMock: (String) -> Void

    init(
        getUSDRateMock: @escaping (String) -> Double,
        getExchangeRatesMock: @escaping (Double, Double) -> [ExchangeRate]
//        getCurrencyArrayMock: @escaping () -> [Currency],
//        getBaseCurrencyCodeMock: @escaping () -> String?,
//        setBaseCurrencyCodeMock: @escaping (String) -> Void
    ) {
        self.getUSDRateMock = getUSDRateMock
        self.getExchangeRatesMock = getExchangeRatesMock
    }
    
    func getUSDRate(for currencyCode: String) -> Observable<Double> {
        let exchangeRateValue = getUSDRateMock(currencyCode)
        return Observable.of(exchangeRateValue)
    }
    
    func getExchangeRates(for amount: Double, baseValue: Double) -> Observable<[ExchangeRate]> {
        let exchangeRates = getExchangeRatesMock(amount, baseValue)
        return Observable.of(exchangeRates)
    }
    
    func getCurrencyArray() -> Observable<[Currency]> {
        return Observable.of([])
    }
    
    func getBaseCurrencyCode() -> String? {
        return "USD"
    }
    
    func setBaseCurrencyCode(_ code: String) {
    }
    
}
