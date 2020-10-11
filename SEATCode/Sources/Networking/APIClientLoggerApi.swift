//
//  APIClientLoggerApi.swift
//
//  Created by Luis Valdés on 08/05/2020.
//

import Foundation

protocol APIClientLoggerApi {
    func logRequest(_ request: URLRequest)
    func logResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?)
}
