//
//  StopDetails.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import Foundation

struct StopDetails {
    let description: String

    init(stop: Stop) {
        let date: String = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: stop.stopTime)
        }()
        let money: String? = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "EUR"
            return formatter.string(from: NSNumber(value: stop.price))
        }()
        description = "\(stop.userName) \(stop.isPaid ? "paid" : "did not pay") \(money ?? "") on \(date)"
    }
}
