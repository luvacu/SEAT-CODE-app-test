//
//  TripsViewModel.swift
//  SEATCode
//
//  Created by Luis Valdés on 07/10/2020.
//

import Foundation
import RxSwift
import RxCocoa

struct TripsViewModel {
    private let repository: TripsRepositoryApi

    init(repository: TripsRepositoryApi) {
        self.repository = repository
    }
}

extension TripsViewModel: TripsViewModelApi {
    var title: Driver<String> {
        .just("Trips")
    }

    var trips: Driver<[TripDetails]> {
        repository.trips()
            .map {
                $0.map(TripDetails.init(trip:))
            }
            .asDriver(onErrorJustReturn: [])
    }
}
