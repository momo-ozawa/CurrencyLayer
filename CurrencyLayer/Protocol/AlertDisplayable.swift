//
//  AlertDisplayable.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/29.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import UIKit

protocol AlertDisplayable {
    func showAlert(title: String?, message: String?, actions: [UIAlertAction])
}

extension AlertDisplayable where Self: UIViewController {

    func showErrorAlert(_ error: APIError) {
        self.showAlert(
            title: "Error",
            message: error.message,
            actions: [UIAlertAction(title: "OK", style: .default)]
        )
    }

    func showAlert(
        title: String?,
        message: String?,
        actions: [UIAlertAction]
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach {
            alert.addAction($0)
        }
        self.present(alert, animated: true, completion: nil)
    }

}
