//
//  String+Matches.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import Foundation

extension String {
    func matches(regex pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
