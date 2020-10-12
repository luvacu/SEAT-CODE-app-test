//
//  IssuesLocalServiceApi.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import Foundation
import RxSwift

// sourcery: AutoMockable
protocol IssuesLocalServiceApi {
    func store(issue: IssueCodable) -> Completable
    func numberOfIssues() -> Single<Int>
}
