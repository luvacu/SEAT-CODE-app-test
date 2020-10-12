//
//  DependencyContainer.swift
//  SEATCode
//
//  Created by Luis Valdés on 07/10/2020.
//

import Foundation
import UIKit
import UserNotifications
import Swinject

struct DependencyContainer {
    private let container = Container()
    private let jsonDecoder: JSONDecoder = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()

    func resolve<T>(_ type: T.Type) -> T {
        if let instance = container.synchronize().resolve(type) {
            return instance
        } else {
            registerDependencies(in: container)
            return container.synchronize().resolve(type)!
        }
    }

    func resolve<T, Arg1>(_ type: T.Type, argument: Arg1) -> T {
        if let instance = container.synchronize().resolve(type, argument: argument) {
            return instance
        } else {
            registerDependencies(in: container)
            return container.synchronize().resolve(type)!
        }
    }

    func clear() {
        container.resetObjectScope(.graph)
        container.resetObjectScope(.container)
    }
}

private extension DependencyContainer {
    func registerDependencies(in container: Container) {
        registerFoundation(container)
        registerServices(container)
        registerRepositories(container)
    }

    func registerFoundation(_ container: Container) {
        container.register(URLSessionConfiguration.self) { _ in
            URLSessionConfiguration.default
        }
        container.register(URLSession.self) {
            URLSession(configuration: $0.resolve(URLSessionConfiguration.self)!)
        }
        container.register(UserDefaults.self) { _ in
            UserDefaults.standard
        }
        container.register(UIApplication.self) { _ in
            UIApplication.shared
        }
        container.register(UNUserNotificationCenter.self) { _ in
            UNUserNotificationCenter.current()
        }
    }

    func registerServices(_ container: Container) {
        #if DEBUG
            container.register(APIClientLoggerApi.self) { _ in
                APIClientLogger()
            }
        #endif
        container.register(APIClientApi.self) {
            APIClient(baseURL: Configuration.baseURL,
                      session: $0.resolve(URLSession.self)!,
                      logger: $0.resolve(APIClientLoggerApi.self))
        }
        container.register(TripsRemoteServiceApi.self) {
            TripsRemoteService(apiClient: $0.resolve(APIClientApi.self)!,
                               jsonDecoder: jsonDecoder)
        }
        container.register(IssuesLocalServiceApi.self) {
            IssuesLocalService(storage: $0.resolve(UserDefaults.self)!,
                               jsonEncoder: JSONEncoder())
        }
        container.register(NotificationServiceApi.self) {
            NotificationService(application: $0.resolve(UIApplication.self)!,
                                userNotificationCenter: $0.resolve(UNUserNotificationCenter.self)!)
        }
    }

    func registerRepositories(_ container: Container) {
        container.register(TripsRepositoryApi.self) {
            TripsRepository(remote: $0.resolve(TripsRemoteServiceApi.self)!)
        }
        container.register(IssuesRepositoryApi.self) {
            IssuesRepository(local: $0.resolve(IssuesLocalServiceApi.self)!)
        }
    }
}
