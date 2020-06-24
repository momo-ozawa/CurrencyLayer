//
//  RateListViewModel.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/24.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import CoreData
import Foundation
import RxSwift
import RxCocoa

class RateListViewModel {
    
    private let disposeBag = DisposeBag()
    
    let apiType: CurrencyLayerAPIProtocol.Type
    
    // MARK: - Input
    
    // MARK: - Output
    
    let rates = BehaviorRelay<[Rate]>.init(value: [])
    
    // MARK: - Init
    
    init(apiType: CurrencyLayerAPIProtocol.Type = CurrencyLayerAPI.self) {
        self.apiType = apiType
        
        bindOutput()
    }
    
    func bindOutput() {
        apiType.getQuotes()
            .debug()
            .map {
                $0.quotes.map { key, value in
                    let code = String(key.suffix(3))
                    return Rate(code: code, exchangeRateValue: value)
                }
            }
            .bind(to: rates)
            .disposed(by: disposeBag)
    }
}

struct Rate {
    let code: String
    let exchangeRateValue: Double
}
