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
        // TODO
    }
}
