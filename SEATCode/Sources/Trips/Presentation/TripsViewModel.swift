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
    private let selectTripRelay = PublishRelay<Int>()
    private let currentTrips = BehaviorRelay<[Trip]>(value: [])
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
            .do(onSuccess: { trips in
                self.currentTrips.accept(trips)
            })
            .map {
                $0.map(TripDetails.init(trip:))
            }
            .asDriver(onErrorJustReturn: [])
    }

    var selectedTripMapDetails: Driver<TripMapDetails> {
        selectTripRelay
            .withLatestFrom(currentTrips) { index, trips in
                trips[index]
            }
            .map { TripMapDetails(trip: $0) }
            .asDriver { error in
                fatalError("Relays never send errors")
            }
    }

    var selectTripIndex: PublishRelay<Int> {
        selectTripRelay
    }
}
