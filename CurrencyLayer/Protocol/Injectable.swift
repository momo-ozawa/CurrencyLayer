//
//  Injectable.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/28.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Foundation

protocol Injectable {
    associatedtype Dependency = Void
    func inject(_ dependency: Dependency)
}

extension Injectable where Dependency == Void {
    func inject(_ dependency: Dependency) {}
}
