//
//  CurrencyAPI.swift
//  CurrencyLayer
//
//  Created by Momo Ozawa on 2020/06/24.
//  Copyright © 2020 Momo Ozawa. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

protocol CurrencyAPIProtocol {
    func getQuotes() -> Observable<Quotes>
    func getCurrencies() -> Observable<Currencies>
}

// MARK: - API Errors

enum APIError: Error {
    case responseError(ErrorDetail)
    case connectionError
    case unknownError

    var message: String {
        switch self {
        case .responseError(let errorDetail):
            return errorDetail.info
        case .connectionError:
            return "Please check your internet connection"
        case .unknownError:
            return "Unknown error occured"
        }
    }
}

struct CurrencyLayerError: Error, Decodable {
    let error: ErrorDetail
}

struct ErrorDetail: Decodable {
    let code: Int
    let info: String
}

// MARK: - Currency API

class CurrencyAPI: CurrencyAPIProtocol {

    static let shared = CurrencyAPI()

    private init() {}

    func getQuotes() -> Observable<Quotes> {
        return request(urlRequest: CurrencyLayerRouter.quotes)
    }

    func getCurrencies() -> Observable<Currencies> {
        return request(urlRequest: CurrencyLayerRouter.currencies)
    }

    private func request<T>(urlRequest: URLRequestConvertible) -> Observable<T> where T: Decodable {
        return Observable.create { observer in

            let request = AF.request(urlRequest)
            request.responseJSON { response in

                guard let data = response.data else {
                    observer.onError(APIError.connectionError)
                    return
                }

                do {
                    if let obj = try? JSONDecoder().decode(T.self, from: data) {
                        observer.onNext(obj)
                        observer.onCompleted()
                    } else {
                        let currencyLayerError = try JSONDecoder().decode(CurrencyLayerError.self, from: data)
                        observer.onError(APIError.responseError(currencyLayerError.error))
                    }
                } catch {
                    observer.onError(APIError.unknownError)
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }

}
