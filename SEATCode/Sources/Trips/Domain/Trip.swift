//
//  Trip.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import Foundation

struct Trip {
    enum Status {
        case ongoing
        case scheduled
        case finalized
        case cancelled
    }
    let driverName: String
    let description: String
    let status: Status
    let startTime: Date
    let endTime: Date
    let route: String
    let origin: Location
    let destination: Location
    let stops: [Location]
}
