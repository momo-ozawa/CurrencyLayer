//
//  CurrencyListViewController.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/24.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import RxSwift
import UIKit

class CurrencyListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    private var viewModel = CurrencyListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CurrencyCell")
        bindUI()
    }
    
    func bindUI() {
        viewModel.currencies.asDriver()
            .drive(onNext: { [weak self] currency in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

}

extension CurrencyListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currencies.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell")!
        let currency = viewModel.currencies.value[indexPath.row]
        cell.textLabel?.text = "\(currency.code): \(currency.name)"
        return cell
    }
    
}

extension CurrencyListViewController: UITableViewDelegate {
    
}
