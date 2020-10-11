//
//  TripsViewModelApi.swift
//  SEATCode
//
//  Created by Luis Valdés on 07/10/2020.
//

import Foundation
import RxSwift
import RxCocoa

// sourcery: AutoMockable
protocol TripsViewModelApi {
    var title: Driver<String> { get }
    var trips: Driver<[TripDetails]> { get }
    var selectedTripMapDetails: Driver<TripMapDetails> { get }
    var selectedStopDetails: Observable<StopDetails> { get }
    var didSelectTripIndex: PublishRelay<Int> { get }
    var didSelectStopId: PublishRelay<Int> { get }
}
