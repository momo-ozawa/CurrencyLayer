//
//  ExchangeRatesViewModelTests.swift
//  CurrencyLayerTests
//
//  Created by Momo Ozawa on 2020/06/28.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import CurrencyLayer

class ExchangeRatesViewModelTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var viewModel: ExchangeRatesViewModel!

    override func setUp() {
        super.setUp()

        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
        
        let amountDriver: Driver<String> = scheduler.createColdObservable([
            Recorded.next(10, "0.0"),
            Recorded.next(20, "1.0"),
            Recorded.next(30, "10.0")
        ]).asDriver(onErrorJustReturn: "-1.0")
        
        let baseCurrencyTapSignal: Signal<Void> = scheduler.createColdObservable([
            Recorded.next(10, ())
        ]).asSignal(onErrorJustReturn: ())
        
        let service = MockCurrencyService(
            getUSDRateMock: { currencyCode in
                let rates = ["USD": 1.0, "JPY": 107.1, "SGD": 1.3]
                return rates[currencyCode] ?? 0.0
            },
            getExchangeRatesMock: { amount, baseValue in
                let rates = ["USD": 1.0, "JPY": 107.1, "SGD": 1.3]
                let exchangeRates = rates.map {
                    ExchangeRate(targetCurrencyCode: $0.key, value: $0.value / baseValue * amount)
                }
                return exchangeRates.sorted { (lhs, rhs) in
                    lhs.targetCurrencyCode < rhs.targetCurrencyCode
                }
            },
            getCurrencyArrayMock: {
                return []
            }
        )
        
        self.viewModel = ExchangeRatesViewModel(
            input: (
                amount: amountDriver,
                baseCurrencyTap: baseCurrencyTapSignal
            ),
            service: service,
            wireframe: MockExchangeRatesWireframe()
        )
    }
    
    func testCurrencyCode() {
        let currencyCodeObserver = scheduler.createObserver(String.self)
        
        viewModel.currencyCode
            .subscribe(currencyCodeObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
                
        XCTAssertEqual(currencyCodeObserver.events.first, Recorded.next(0, "USD"))
    }
    
    func testExchangeRates() {
        let exchangeRatesObserver = scheduler.createObserver([ExchangeRate].self)
        
        viewModel.exchangeRates
            .skip(1)
            .subscribe(exchangeRatesObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expected10 = [
            ExchangeRate(targetCurrencyCode: "JPY", value: 0.0),
            ExchangeRate(targetCurrencyCode: "SGD", value: 0.0),
            ExchangeRate(targetCurrencyCode: "USD", value: 0.0)
        ]
        
        let expected20 = [
            ExchangeRate(targetCurrencyCode: "JPY", value: 107.1),
            ExchangeRate(targetCurrencyCode: "SGD", value: 1.3),
            ExchangeRate(targetCurrencyCode: "USD", value: 1.0)
        ]
        
        let expected30 = [
            ExchangeRate(targetCurrencyCode: "JPY", value: 1071.0),
            ExchangeRate(targetCurrencyCode: "SGD", value: 13.0),
            ExchangeRate(targetCurrencyCode: "USD", value: 10.0)
        ]
        
        let expected = [
            Recorded.next(10, expected10),
            Recorded.next(20, expected20),
            Recorded.next(30, expected30)
        ]
        
        XCTAssertEqual(exchangeRatesObserver.events, expected)
    }

}
