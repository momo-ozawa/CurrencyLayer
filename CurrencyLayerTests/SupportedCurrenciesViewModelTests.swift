//
//  SupportedCurrenciesViewModelTests.swift
//  CurrencyLayerTests
//
//  Created by Momo Ozawa on 2020/06/29.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import CurrencyLayer

class SupportedCurrenciesViewModelTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var viewModel: SupportedCurrenciesViewModel!

    override func setUp() {
        super.setUp()

        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
        
        let baseCurrencyCode = BehaviorRelay<String>.init(value: "")
                
        let currencySelectedSignal: Signal<Currency> = scheduler.createColdObservable([
            Recorded.next(10, Currency())
        ]).asSignal(onErrorJustReturn: Currency())
        
        let cancelTapSignal: Signal<Void> = scheduler.createColdObservable([
            Recorded.next(10, ())
        ]).asSignal(onErrorJustReturn: ())

        let service = MockCurrencyService(
            getUSDRateMock: { currencyCode in
                return 0.0
            },
            getExchangeRatesMock: { amount, baseValue in
                return []
            },
            getCurrencyArrayMock: {
                return []
            }
        )
        
        self.viewModel = SupportedCurrenciesViewModel(
            input: (
                baseCurrencyCode: baseCurrencyCode,
                currencySelected: currencySelectedSignal,
                cancelTap: cancelTapSignal
            ),
            service: service,
            wireframe: MockSupportedCurrenciesWireframe())
        
    }
    
    func testCurrencies() {
        let currenciesObserver = scheduler.createObserver([Currency].self)
        
        viewModel.currencies
            .subscribe(currenciesObserver)
            .disposed(by: disposeBag)
        
        XCTAssertEqual(currenciesObserver.events.first, Recorded.next(0, []))
    }

}
