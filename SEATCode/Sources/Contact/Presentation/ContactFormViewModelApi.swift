//
//  ContactFormViewModelApi.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import Foundation
import RxSwift
import RxCocoa

// sourcery: AutoMockable
protocol ContactFormViewModelApi {
    var title: Driver<String> { get }
    var isSaveButtonEnabled: Driver<Bool> { get }
    var didTapSaveButton: PublishRelay<Void> { get }
}
