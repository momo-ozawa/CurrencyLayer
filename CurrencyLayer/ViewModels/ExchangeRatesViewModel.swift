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
    
    let currencyCode: BehaviorRelay<String>
    let exchangeRates = BehaviorRelay<[ExchangeRate]>.init(value: [])
    
    // MARK: - Init
    
    init(
        input: (
            amount: Driver<String>,
            baseCurrencyTap: Signal<Void>
        ),
        service: CurrencyServiceProtocol,
        wireframe: ExchangeRatesWireframeProtocol
    ) {
        let baseCurrencyCode = service.getBaseCurrencyCode() ?? "USD"
        currencyCode = BehaviorRelay<String>.init(value: baseCurrencyCode)
        
        let baseValue = currencyCode
            .map { service.getUSDRate(for: $0) }
            .flatMap { $0 }
            .asDriver(onErrorJustReturn: 1.0)
        
        Driver
            .combineLatest(input.amount, baseValue) { amount, value in
                service.getExchangeRates(for: Double(amount) ?? 0.0, baseValue: value)
            }
            .asObservable()
            .flatMap { $0 }
            .bind(to: exchangeRates)
            .disposed(by: disposeBag)
        
        input.baseCurrencyTap
            .emit(onNext: {
                wireframe.routeToSupportedCurrencies(with: self.currencyCode)
            })
            .disposed(by: disposeBag)
    }

}

