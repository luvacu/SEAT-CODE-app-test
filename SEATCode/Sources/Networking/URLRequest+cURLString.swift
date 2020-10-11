//
//  URLRequest+cURLString.swift
//
//  Created by Luis Valdés on 19/03/2020.
//

import Foundation

/// Source: http://gentlebytes.com/blog/2018/02/28/request-debugging/
extension URLRequest {
    var cURLString: String {
        var result = "curl -k "

        if let method = httpMethod {
            result += "-X \(method) \\\n"
        }

        if let headers = allHTTPHeaderFields {
            for (header, value) in headers {
                result += "-H \"\(header): \(value)\" \\\n"
            }
        }

        if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
            result += "-d '\(string)' \\\n"
        }

        if let url = url {
            result += url.absoluteString
        }

        return result
    }
}
