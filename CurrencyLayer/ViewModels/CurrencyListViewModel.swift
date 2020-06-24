//
//  CurrencyListViewModel.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/24.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import CoreData
import Foundation
import RxSwift
import RxCocoa

class CurrencyListViewModel {
    
    private let disposeBag = DisposeBag()
            
    let apiType: CurrencyLayerAPIProtocol.Type

    // MARK: - Input
    
    // MARK: - Output
    
    let currencies = BehaviorRelay<[Currency]>.init(value: [])
        
    // MARK: - Init
    
    init(apiType: CurrencyLayerAPIProtocol.Type = CurrencyLayerAPI.self) {
        self.apiType = apiType
        
        bindOutput()
    }
    
    func bindOutput() {
        apiType.getCurrencies()
            .asObservable()
            .map {
                $0.currencies.map { key, value in Currency(code: key, name: value) }
            }
            .bind(to: currencies)
            .disposed(by: disposeBag)
    }

}

struct Currency {
    let code: String
    let name: String
}
