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
    
    init(baseCurrencyCode: BehaviorRelay<String>, service: CurrencyServiceProtocol) {
        self.baseCurrencyCode = baseCurrencyCode
        
        service.getCurrencyArray()
            .bind(to: currencies)
            .disposed(by: disposeBag)
        
        

        
    }
    
//    func bindOutput() {
//        apiType.getCurrencies()
//            .map {
//                $0.currencies.map { code, name in Currency(code: code, name: name) }
//            }
//            .bind(to: currencies)
//            .disposed(by: disposeBag)
//    }

}
