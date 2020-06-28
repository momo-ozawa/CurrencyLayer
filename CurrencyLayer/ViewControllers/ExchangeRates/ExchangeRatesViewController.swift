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

final class ExchangeRatesViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    var viewModel: ExchangeRatesViewModel!

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var baseCurrencyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ExchangeRatesViewModel(
            input: (
                amount: amountTextField.rx.text.orEmpty.asDriver(),
                baseCurrencyTap: baseCurrencyButton.rx.tap.asSignal()
            ),
            service: CurrencyService(
                API: CurrencyAPI.shared,
                realmStore: CurrencyRealmStore.shared,
                localStore: CurrencyLocalStore.shared
            ),
            wireframe: ExchangeRatesWireframe(for: self)
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
    }

}

extension ExchangeRatesViewController: StoryboardInstantiatable {
    
    static var storyboard: UIStoryboard {
        return R.storyboard.exchangeRatesStoryboard()
    }
    
}

