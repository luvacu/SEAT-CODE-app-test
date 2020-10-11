//
//  TripCell.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import UIKit

final class TripCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var driverLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!

    func configure(trip: TripDetails) {
        titleLabel.text = trip.name
        driverLabel.text = trip.driverName
        statusLabel.text = trip.status
        durationLabel.text = trip.duration
    }
}
