//
//  ExchangeRatesViewModel.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/24.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import CoreData
import Foundation
import RxSwift
import RxCocoa

class ExchangeRatesViewModel {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Outputs
    
    let currencyCode = BehaviorRelay<String>.init(value: "USD")
    let exchangeRates = BehaviorRelay<[ExchangeRate]>.init(value: [])
    
    // MARK: - Init
    
    init(
        amount: Driver<String>,
        service: CurrencyServiceProtocol
    ) {
        
        let baseValue = currencyCode
            .map { service.getUSDRate(for: $0) }
            .flatMap { $0 }
            .asDriver(onErrorJustReturn: 1.0)

        Driver
            .combineLatest(amount, baseValue) { amount, value in
                service.getExchangeRates(for: Double(amount) ?? 0.0, baseValue: value)
            }
            .asObservable()
            .flatMap { $0 }
            .bind(to: exchangeRates)
            .disposed(by: disposeBag)
    }

}

struct ExchangeRate {
    let targetCurrencyCode: String
    let value: Double
}
