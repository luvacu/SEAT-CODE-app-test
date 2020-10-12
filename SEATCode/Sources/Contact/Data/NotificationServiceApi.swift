//
//  NotificationServiceApi.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import Foundation
import RxSwift

// sourcery: AutoMockable
protocol NotificationServiceApi {
    func updateBadge(number: Int) -> Completable
}
