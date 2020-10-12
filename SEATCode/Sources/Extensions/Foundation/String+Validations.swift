//
//  String+Validations.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import Foundation

extension String {
    var isValidNameOrSurname: Bool {
        !isEmpty
    }

    var isValidEmail: Bool {
        let pattern = "^[A-Za-z0-9._%\\-+]{1,256}+@{1}+[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}+(\\.[A-Za-z]{2,6})+(\\.[A-Za-z]{2,})*$"
        return matches(regex: pattern)
    }

    var isValidPhoneNumber: Bool {
        matches(regex: "[0-9]{9}")
    }
}
