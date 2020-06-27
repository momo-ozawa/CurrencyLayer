//
//  ExchangeRatesWireframe.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/27.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import UIKit

protocol ExchangeRatesWireframeProtocol {
    func routeToSupportedCurrencies(with currencyCode: String)
}

class ExchangeRatesWireframe: ExchangeRatesWireframeProtocol {
    
    private weak var viewController: UIViewController?
    
    init(for viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func routeToSupportedCurrencies(with currencyCode: String) {
        
//        let viewModel = SupportedCurrenciesViewModel(currencyCode: currencyCode)
//        
//        let destination = SupportedCurrenciesViewController.createWith(
//            storyboard: R.storyboard.supportedCurrenciesStoryboard(),
//            viewModel: viewModel,
//            wireframe: SupportedCurrenciesWireframe()
//        )
//        
//        let navigation = UINavigationController(rootViewController: destination)
//        
//        self.viewController?.present(navigation, animated: true, completion: nil)

    }
    
    private func navigateToSupportedCurrencies() {
    }
    
}
