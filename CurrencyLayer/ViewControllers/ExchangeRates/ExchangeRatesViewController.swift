//
//  ExchangeRatesViewController.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/24.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class ExchangeRatesViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    var viewModel: ExchangeRatesViewModel!
    var wireframe: ExchangeRatesWireframe!
    
    static func createWith(storyboard: UIStoryboard,
                           viewModel: ExchangeRatesViewModel,
                           wireframe: ExchangeRatesWireframe) -> ExchangeRatesViewController {
        guard let viewController = storyboard.instantiateInitialViewController() as? ExchangeRatesViewController else {
            fatalError("Failed to instantiate ViewController")
        }
        viewController.viewModel = viewModel
        viewController.wireframe = wireframe
        return viewController
    }

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var baseCurrencyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ExchangeRatesViewModel(
            amount: amountTextField.rx.text.orEmpty.asDriver(),
            service: CurrencyService(apiType: CurrencyLayerAPI.self)
        )
        
        amountTextField.keyboardType = .decimalPad
        
        baseCurrencyButton.setTitle("USD", for: .normal)
        
        bindUI()
    }
    
    func bindUI() {
        
        viewModel.exchangeRates
            .bind(to: tableView.rx.items(
                cellIdentifier: "RateCell",
                cellType: UITableViewCell.self)
            ) { (_, exchangeRate, cell) in
                cell.textLabel?.text = exchangeRate.targetCurrencyCode
                cell.detailTextLabel?.text = String(exchangeRate.value)
            }
            .disposed(by: disposeBag)
        
        viewModel.currencyCode
            .bind(to: baseCurrencyButton.rx.title())
            .disposed(by: disposeBag)
        
        
        
        baseCurrencyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                let vm = SupportedCurrenciesViewModel(
                    baseCurrencyCode: self.viewModel.currencyCode,
                    service: CurrencyService(apiType: CurrencyLayerAPI.self)
                )
                
                let destination = SupportedCurrenciesViewController.createWith(
                    storyboard: R.storyboard.supportedCurrenciesStoryboard(),
                    viewModel: vm
                )
                
                let navigation = UINavigationController(rootViewController: destination)
                self.present(navigation, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

    }

}
