//
//  IssuesLocalService.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import Foundation
import RxSwift

struct IssuesLocalService {
    private enum Constants {
        static let keysPrefix = "Issue_"
    }
    private let storage: UserDefaults
    private let jsonEncoder: JSONEncoder

    init(storage: UserDefaults, jsonEncoder: JSONEncoder) {
        self.storage = storage
        self.jsonEncoder = jsonEncoder
    }
}

extension IssuesLocalService: IssuesLocalServiceApi {
    func store(issue: IssueCodable) -> Completable {
        .deferred {
            guard let data = try? self.jsonEncoder.encode(issue) else {
                return Completable.error(AnyError.error)
            }
            let key = Constants.keysPrefix + String(describing: Date())
            self.storage.set(data, forKey: key)
            self.storage.synchronize()
            return Completable.empty()
        }
    }

    func numberOfIssues() -> Single<Int> {
        .deferred {
            let count = self.storage.dictionaryRepresentation().keys
                .filter { $0.hasPrefix(Constants.keysPrefix) }
                .count
            return .just(count)
        }
    }
}

enum AnyError: Error {
    case error
}
