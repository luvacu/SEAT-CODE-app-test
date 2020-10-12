//
//  IssueCodable.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import Foundation

struct IssueCodable: Codable {
    let userName: String
    let userSurname: String
    let userEmail: String
    let userPhoneNumber: String?
    let date: Date
    let description: String
}
