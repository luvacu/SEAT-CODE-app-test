//
//  StopCodable.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import Foundation

struct StopCodable: Codable {
    let stopTime: Date
    let userName: String
    let paid: Bool
    let price: Double
}

extension StopCodable {
    func toDomain() -> Stop {
        Stop(stopTime: stopTime,
             userName: userName,
             isPaid: paid,
             price: price)
    }
}
