//
//  TripMapDetails.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import Foundation
import MapKit
import Polyline

struct TripMapDetails {
    let origin: LocationAnnotation
    let destination: LocationAnnotation
    let stops: [LocationAnnotation]
    let route: MKPolyline?

    init(trip: Trip) {
        origin = LocationAnnotation(stopId: nil,
                                    title: "Origin",
                                    latitude: trip.origin.latitude,
                                    longitude: trip.origin.longitude)
        destination = LocationAnnotation(stopId: nil,
                                         title: "Destination",
                                         latitude: trip.destination.latitude,
                                         longitude: trip.destination.longitude)
        stops = trip.stops.map {
            LocationAnnotation(stopId: $0.id, title: nil, latitude: $0.latitude, longitude: $0.longitude)
        }
        route = Polyline(encodedPolyline: trip.route).mkPolyline
    }
}

final class LocationAnnotation: NSObject, MKAnnotation {
    let stopId: Int?
    let title: String?
    let subtitle: String? = nil
    let coordinate: CLLocationCoordinate2D

    init(stopId: Int?, title: String?, latitude: Double, longitude: Double) {
        self.stopId = stopId
        self.title = title
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        super.init()
    }
}
