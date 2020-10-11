//
//  TripsRemoteServiceApi.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import Foundation
import RxSwift

// sourcery: AutoMockable
protocol TripsRemoteServiceApi {
    func trips() -> Single<[TripCodable]>
}
