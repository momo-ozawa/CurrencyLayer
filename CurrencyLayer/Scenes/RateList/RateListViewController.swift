//
//  RateListViewController.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/24.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import RxSwift
import UIKit

class RateListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private var viewModel = RateListViewModel()

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var baseCurrencyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RateCell")
        bindUI()
    }
    
    func bindUI() {
        viewModel.rates.asDriver()
            .drive(onNext: { [weak self] rate in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

}

extension RateListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rates.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RateCell")!
        let rate = viewModel.rates.value[indexPath.row]
        cell.textLabel?.text = "\(rate.code): \(rate.exchangeRateValue)"
        return cell
    }
}

extension RateListViewController: UITableViewDelegate {
    
}
