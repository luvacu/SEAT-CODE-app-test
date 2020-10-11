//
//  APIClientApi.swift
//
//  Created by Luis Valdés on 08/05/2020.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidInput
    case httpCode(Int, Data?)
    case failedDecoding(Error)
    case failedMappingToDomain
    case unexpectedResponse
    case timeout
    case other(Error)
}

protocol APIClientApi {
    var baseURL: String { get }
    func request<T: Decodable>(_ endpoint: Endpoint, response: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
    func request<T: Decodable>(_ endpoint: Endpoint, response: T.Type, jsonDecoder: JSONDecoder, completion: @escaping (Result<T, APIError>) -> Void)
    func request<T: Decodable>(_ endpoint: Endpoint, response: T.Type, successfulStatusCodes: Range<Int>, completion: @escaping (Result<T, APIError>) -> Void)
    func request<T: Decodable>(_ endpoint: Endpoint, response: T.Type, successfulStatusCodes: Range<Int>, jsonDecoder: JSONDecoder, completion: @escaping (Result<T, APIError>) -> Void)
}
