//
//  TripsRepository.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import Foundation
import RxSwift

struct TripsRepository {
    private let remote: TripsRemoteServiceApi

    init(remote: TripsRemoteServiceApi) {
        self.remote = remote
    }
}

extension TripsRepository: TripsRepositoryApi {
    func trips() -> Single<[Trip]> {
        remote.trips()
            .map { $0.map { $0.toDomain() } }
    }

    func stopDetails(id: Int) -> Single<Stop> {
        remote.stopDetails(id: id)
            .map { $0.toDomain() }
    }
}
