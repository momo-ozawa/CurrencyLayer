//
//  SupportedCurrenciesWireframe.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/27.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import UIKit

protocol SupportedCurrenciesWireframeProtocol {
    func routeToExchangeRates()
}

class SupportedCurrenciesWireframe: SupportedCurrenciesWireframeProtocol {

    private weak var viewController: UIViewController?

    init(for viewController: UIViewController) {
        self.viewController = viewController
    }

    func routeToExchangeRates() {
        self.viewController?.dismiss(animated: true, completion: nil)
    }
}
