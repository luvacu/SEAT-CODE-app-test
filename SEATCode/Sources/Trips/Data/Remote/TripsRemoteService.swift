//
//  TripsRemoteService.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import Foundation
import RxSwift

struct TripsRemoteService {
    private let apiClient: APIClientApi
    private let jsonDecoder: JSONDecoder

    init(apiClient: APIClientApi, jsonDecoder: JSONDecoder) {
        self.apiClient = apiClient
        self.jsonDecoder = jsonDecoder
    }
}

extension TripsRemoteService: TripsRemoteServiceApi {
    func trips() -> Single<[TripCodable]> {
        .create { observer -> Disposable in
            self.apiClient.request(.trips(),
                                   response: [TripCodable].self,
                                   jsonDecoder: jsonDecoder) { result in
                switch result {
                case let .success(trips):
                    observer(.success(trips))
                    break
                case let .failure(error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func stopDetails(id: Int) -> Single<StopCodable> {
        .create { observer -> Disposable in
            self.apiClient.request(.stopDetails(id: id),
                                   response: StopCodable.self,
                                   jsonDecoder: jsonDecoder) { result in
                switch result {
                case let .success(stop):
                    observer(.success(stop))
                    break
                case let .failure(error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
