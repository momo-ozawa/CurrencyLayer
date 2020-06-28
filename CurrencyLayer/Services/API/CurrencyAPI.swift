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

// MARK: - API errors

enum Errors: Error {
    case responseError(ErrorDetail)
    case connectionError
}

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
                    observer.onError(Errors.connectionError)
                    return
                }
                
                do {
                    if let obj = try? JSONDecoder().decode(T.self, from: data) {
                        observer.onNext(obj)
                        observer.onCompleted()
                    } else {
                        let apiError = try JSONDecoder().decode(APIError.self, from: data)
                        observer.onError(Errors.responseError(apiError.error))
                    }
                } catch let error {
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}
