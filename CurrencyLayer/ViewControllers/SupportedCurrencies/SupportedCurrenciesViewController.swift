//
//  SupportedCurrenciesViewController.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/24.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class SupportedCurrenciesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: SupportedCurrenciesViewModel!
    var wireframe: SupportedCurrenciesWireframe!
    
    static func createWith(storyboard: UIStoryboard,
                           viewModel: SupportedCurrenciesViewModel) -> SupportedCurrenciesViewController {
        guard let viewController = storyboard.instantiateInitialViewController() as? SupportedCurrenciesViewController else {
            fatalError("Failed to instantiate ViewController")
        }
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    func bindUI() {
        
        viewModel.currencies
            .bind(to: tableView.rx.items(
                cellIdentifier: "CurrencyCell",
                cellType: UITableViewCell.self)
            ) { [weak self] (_, currency, cell) in
                guard let self = self else { return }
                cell.textLabel?.text = currency.code
                cell.detailTextLabel?.text = currency.name
                cell.accessoryType = self.viewModel.baseCurrencyCode.value == currency.code ? .checkmark : .none
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Currency.self)
            .subscribe(onNext: { [weak self] currency in
                guard let self = self else { return }
                self.viewModel.baseCurrencyCode.accept(currency.code)
                //guard let presentingVC = self.presentingViewController as? ExchangeRatesViewController else { return }
                //presentingVC.baseCurrencyButton.setTitle(currency.code, for: .normal)
                self.navigationController?.dismiss(animated: true, completion: nil)

            })
            .disposed(by: disposeBag)
        
        cancelBarButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

    }

}
