//
//  Configuration.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import Foundation

enum Configuration {
    static var baseURL: String {
        let apiBaseURL: String = value(for: "API_BASE_URL")
        return "https://" + apiBaseURL + "/"
    }
}

private extension Configuration {
    static func value<T>(for key: String) -> T {
        guard let value = Bundle.main.infoDictionary?[key] else {
            fatalError("Missing \(key) constant in config file")
        }
        guard let typedValue = value as? T else {
            fatalError("Failed casting \(value) to expected type \(T.self)")
        }
        return typedValue
    }
}
