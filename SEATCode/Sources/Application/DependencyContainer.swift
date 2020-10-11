//
//  DependencyContainer.swift
//  SEATCode
//
//  Created by Luis Valdés on 07/10/2020.
//

import Foundation
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
    }

    func registerRepositories(_ container: Container) {
        container.register(TripsRepositoryApi.self) {
            TripsRepository(remote: $0.resolve(TripsRemoteServiceApi.self)!)
        }
    }
}
