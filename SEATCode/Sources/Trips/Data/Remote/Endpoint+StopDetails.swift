//
//  Endpoint+StopDetails.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import Foundation

extension Endpoint {
    static func stopDetails(id: Int) -> Endpoint {
        return Endpoint(path: "api/stops/\(id)",
                        method: .get,
                        headers: nil,
                        queryParams: nil,
                        body: nil)
    }
}
