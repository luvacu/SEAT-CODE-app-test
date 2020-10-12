//
//  IssuesRepositoryApi.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import Foundation
import RxSwift

// sourcery: AutoMockable
protocol IssuesRepositoryApi {
    func store(issue: Issue) -> Single<Int>
}
