//
//  ExchangeRatesWireframe.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/27.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol ExchangeRatesWireframeProtocol {
    func routeToSupportedCurrencies(with currencyCode: BehaviorRelay<String>)
}

class ExchangeRatesWireframe: ExchangeRatesWireframeProtocol {

    private weak var viewController: UIViewController?

    init(for viewController: UIViewController) {
        self.viewController = viewController
    }

    func routeToSupportedCurrencies(with currencyCode: BehaviorRelay<String>) {
        let dependency = SupportedCurrenciesViewController.Dependency(currencyCode: currencyCode)
        let destinationVC = SupportedCurrenciesViewController.instantiate(with: dependency)
        let navigationVC = UINavigationController(rootViewController: destinationVC)
        self.viewController?.present(navigationVC, animated: true)
    }

}
