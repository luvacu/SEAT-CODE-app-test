//
//  NotificationService.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import UIKit
import UserNotifications
import RxSwift

struct NotificationService {
    private let application: UIApplication
    private let userNotificationCenter: UNUserNotificationCenter

    init(application: UIApplication, userNotificationCenter: UNUserNotificationCenter) {
        self.application = application
        self.userNotificationCenter = userNotificationCenter
    }
}

extension NotificationService: NotificationServiceApi {
    func updateBadge(number: Int) -> Completable {
        Completable.create { observer -> Disposable in
            self.userNotificationCenter.requestAuthorization(options: .badge) { granted, error in
                if let error = error {
                    observer(.error(error))
                    return
                }
                guard granted else {
                    observer(.error(AnyError.error))
                    return
                }
                observer(.completed)
            }
            return Disposables.create()
        }
        .observeOn(MainScheduler.instance)
        .andThen(Completable.deferred {
            self.application.applicationIconBadgeNumber = number
            return Completable.empty()
        })
    }
}
