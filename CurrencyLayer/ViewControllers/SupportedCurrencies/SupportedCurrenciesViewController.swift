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

final class SupportedCurrenciesViewController: UIViewController {

    private let disposeBag = DisposeBag()

    var viewModel: SupportedCurrenciesViewModel!
    var dependency: Dependency!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = SupportedCurrenciesViewModel(
            input: (
                baseCurrencyCode: dependency.currencyCode,
                currencySelected: tableView.rx.modelSelected(Currency.self).asSignal(),
                cancelTap: cancelBarButton.rx.tap.asSignal()
            ),
            service: CurrencyService(
                API: CurrencyAPI.shared,
                realmStore: CurrencyRealmStore.shared,
                localStore: CurrencyLocalStore.shared
            ),
            wireframe: SupportedCurrenciesWireframe(for: self)
        )

        setupUI()
        bindUI()
    }

    func setupUI() {
        self.title = "Supported Currencies"
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

        viewModel.currenciesError
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(error)
            })
            .disposed(by: disposeBag)
    }

}

extension SupportedCurrenciesViewController: StoryboardInstantiatable {

    static var storyboard: UIStoryboard {
        return R.storyboard.supportedCurrenciesStoryboard()
    }

    struct Dependency {
        let currencyCode: BehaviorRelay<String>
    }

    func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

}

extension SupportedCurrenciesViewController: AlertDisplayable {}
