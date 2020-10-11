//
//  TripCodable.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import Foundation

struct TripCodable: Codable {
    let driverName: String
    let description: String
    let status: TripStatusCodable
    let startTime: Date
    let endTime: Date
    let route: String
    let origin: LocationCodable
    let destination: LocationCodable
    let stops: [NilOnFail<LocationCodable>]
}

extension TripCodable {
    func toDomain() -> Trip {
        Trip(driverName: driverName,
             description: description,
             status: status.toDomain(),
             startTime: startTime,
             endTime: endTime,
             route: route,
             origin: origin.toDomain(),
             destination: destination.toDomain(),
             stops: stops.compactMap { $0.wrappedValue?.toDomain() })
    }
}

enum TripStatusCodable: String, Codable {
    case ongoing
    case scheduled
    case finalized
    case cancelled
}

extension TripStatusCodable {
    func toDomain() -> Trip.Status {
        switch self {
        case .ongoing: return .ongoing
        case .scheduled: return .scheduled
        case .finalized: return .finalized
        case .cancelled: return .cancelled
        }
    }
}

struct LocationCodable: Codable {
    let id: Int?
    let address: String?
    let point: PointCodable
}

extension LocationCodable {
    func toDomain() -> Location {
        Location(id: id,
                 address: address,
                 latitude: point.latitude,
                 longitude: point.longitude)
    }
}

struct PointCodable: Codable {
    enum CodingKeys: String, CodingKey {
        case latitude = "_latitude"
        case longitude = "_longitude"
    }
    let latitude: Double
    let longitude: Double

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}
