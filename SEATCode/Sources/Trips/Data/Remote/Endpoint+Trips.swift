//
//  Endpoint+Trips.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import Foundation

extension Endpoint {
    static func trips() -> Endpoint {
        return Endpoint(path: "api/trips",
                        method: .get,
                        headers: nil,
                        queryParams: nil,
                        body: nil)
    }
}
