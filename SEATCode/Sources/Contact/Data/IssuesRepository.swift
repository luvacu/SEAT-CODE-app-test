//
//  IssuesRepository.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import Foundation
import RxSwift

struct IssuesRepository {
    private let local: IssuesLocalServiceApi

    init(local: IssuesLocalServiceApi) {
        self.local = local
    }
}

extension IssuesRepository: IssuesRepositoryApi {
    func store(issue: Issue) -> Single<Int> {
        .deferred {
            let codable = IssueCodable(userName: issue.userName,
                                       userSurname: issue.userSurname,
                                       userEmail: issue.userEmail,
                                       userPhoneNumber: issue.userPhoneNumber,
                                       date: issue.date,
                                       description: issue.description)
            return local.store(issue: codable)
                .andThen(local.numberOfIssues())
        }
    }
}
