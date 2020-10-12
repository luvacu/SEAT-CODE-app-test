//
//  TripsViewModelTests.swift
//  SEATCodeTests
//
//  Created by Luis Valdés on 07/10/2020.
//

import XCTest
import SwiftyMocky
import RxSwift
import RxCocoa
import RxTest
@testable import SEATCode

final class TripsViewModelTests: XCTestCase {
    private var sut: TripsViewModel!
    private var repositoryMock: TripsRepositoryApiMock!
    private var testScheduler: TestScheduler!
    private var disposeBag: DisposeBag!


    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        testScheduler = TestScheduler(initialClock: 0)
        repositoryMock = TripsRepositoryApiMock()
        sut = TripsViewModel(repository: repositoryMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        repositoryMock = nil
        testScheduler = nil
        disposeBag = nil
    }

    func testTrips() throws {
        let tripStub = Trip.dummy()
        Given(repositoryMock, .trips(willReturn: .just([tripStub])))
        let observer = testScheduler.createObserver([TripDetails].self)

        sut.trips
            .drive(observer)
            .disposed(by: disposeBag)
        testScheduler.start()

        let expectedEvents = Recorded.events(
            .next(0, [TripDetails(trip: tripStub)]),
            .completed(0)
        )
        XCTAssertEqual(observer.events, expectedEvents)
        Verify(repositoryMock, .trips())
    }
}

private extension Trip {
    static func dummy() -> Trip {
        .init(driverName: "driver",
              description: "bla",
              status: .finalized,
              startTime: Date.distantPast,
              endTime: Date(),
              route: "",
              origin: Location(id: nil, address: nil, latitude: 10.0, longitude: 4.28),
              destination: Location(id: nil, address: nil, latitude: 11.0, longitude: 5.28),
              stops: [])
    }
}
