//
//  SupportedCurrenciesViewModel.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/24.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SupportedCurrenciesViewModel {
    
    private let disposeBag = DisposeBag()
                
    // MARK: - Inputs
    let baseCurrencyCode: BehaviorRelay<String>
    
    // MARK: - Outputs
    let currencies = BehaviorRelay<[Currency]>.init(value: [])
        
    // MARK: - Init
    
    init(
        input: (
            baseCurrencyCode: BehaviorRelay<String>,
            currencySelected: Signal<Currency>,
            cancelTap: Signal<Void>
        ),
        service: CurrencyServiceProtocol,
        wireframe: SupportedCurrenciesWireframeProtocol
    ) {
        self.baseCurrencyCode = input.baseCurrencyCode
        
        service.getCurrencyArray()
            .bind(to: currencies)
            .disposed(by: disposeBag)
        
        input.currencySelected
            .emit(onNext: { currency in
                service.setBaseCurrencyCode(currency.code)
                input.baseCurrencyCode.accept(currency.code)
                wireframe.routeToExchangeRates()
            })
            .disposed(by: disposeBag)
        
        input.cancelTap
            .emit(onNext: {
                wireframe.routeToExchangeRates()
            })
            .disposed(by: disposeBag)
    }

}
