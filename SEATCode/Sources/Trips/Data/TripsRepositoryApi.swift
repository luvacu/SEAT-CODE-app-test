//
//  TripsRepositoryApi.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import Foundation
import RxSwift

// sourcery: AutoMockable
protocol TripsRepositoryApi {
    func trips() -> Single<[Trip]>
    func stopDetails(id: Int) -> Single<Stop>
}
