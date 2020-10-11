//
//  APIClient.swift
//
//  Created by Luis Valdés on 13/03/2020.
//

import Foundation

struct APIClient {
    enum Defaults {
        static let successfulStatusCodes = 200..<300
        static let jsonDecoder: JSONDecoder = {
            let decoder = JSONDecoder()
            return decoder
        }()
    }

    let baseURL: String
    let session: URLSession
    let logger: APIClientLoggerApi?
}

extension APIClient: APIClientApi {
    func request<T: Decodable>(_ endpoint: Endpoint, response: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        request(endpoint, response: response, successfulStatusCodes: Defaults.successfulStatusCodes, jsonDecoder: Defaults.jsonDecoder, completion: completion)
    }

    func request<T: Decodable>(_ endpoint: Endpoint, response: T.Type, jsonDecoder: JSONDecoder, completion: @escaping (Result<T, APIError>) -> Void) {
        request(endpoint, response: response, successfulStatusCodes: Defaults.successfulStatusCodes, jsonDecoder: jsonDecoder, completion: completion)
    }

    func request<T: Decodable>(_ endpoint: Endpoint, response: T.Type, successfulStatusCodes: Range<Int>, completion: @escaping (Result<T, APIError>) -> Void) {
        request(endpoint, response: response, successfulStatusCodes: successfulStatusCodes, jsonDecoder: Defaults.jsonDecoder, completion: completion)
    }

    func request<T: Decodable>(_ endpoint: Endpoint,
                               response: T.Type,
                               successfulStatusCodes: Range<Int> = Defaults.successfulStatusCodes,
                               jsonDecoder: JSONDecoder = Defaults.jsonDecoder,
                               completion: @escaping (Result<T, APIError>) -> Void) {
        var request: URLRequest
        do {
            request = try endpoint.urlRequest(baseURL: baseURL)
        } catch {
            return DispatchQueue.main.async {
                completion(.failure(error as? APIError ?? .other(error)))
            }
        }

        logger?.logRequest(request)

        session.dataTask(with: request) { [logger] data, response, error in
            logger?.logResponse(data, response, error)

            let result: Result<T, APIError> = APIClient.mapToResult(jsonDecoder, data, response, error, successfulStatusCodes)

            return DispatchQueue.main.async {
                completion(result)
            }
        }
        .resume()
    }
}

private extension APIClient {
    static func mapToResult<T: Decodable>(_ jsonDecoder: JSONDecoder,
                                                  _ data: Data?,
                                                  _ response: URLResponse?,
                                                  _ error: Error?,
                                                  _ successfulStatusCodes: Range<Int>) -> Result<T, APIError> {
        return Result {
            if let error = error {
                throw APIError.other(error)
            }
            guard let data = data,
                let code = (response as? HTTPURLResponse)?.statusCode else {
                    throw APIError.unexpectedResponse
            }
            guard successfulStatusCodes.contains(code) else {
                throw APIError.httpCode(code, data)
            }
            do {
                let element = try jsonDecoder.decode(T.self, from: data)
                return element
            } catch {
                if T.self == NoResult.self {
                    return NoResult() as! T
                }
                throw APIError.failedDecoding(error)
            }
        }
        .mapError { $0 as! APIError }
    }
}
