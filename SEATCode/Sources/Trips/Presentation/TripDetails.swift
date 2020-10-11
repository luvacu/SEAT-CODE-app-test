//
//  TripViewDescription.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import UIKit

struct TripDetails {
    let name: String
    let driverName: String
    let status: String
    let duration: String

    init(trip: Trip) {
        name = trip.description
        driverName = trip.driverName
        status = {
            switch trip.status {
            case .ongoing:
                return "Ongoing"
            case .scheduled:
                return "Scheduled"
            case .finalized:
                return "Finalized"
            case .cancelled:
                return "Cancelled"
            }
        }()
        duration = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute]
            formatter.unitsStyle = .full
            let dateString = formatter.string(from: trip.startTime, to: trip.endTime)
            return dateString ?? "––"
        }()
    }
}
