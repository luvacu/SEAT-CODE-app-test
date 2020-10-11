//
//  ContactFormViewModel.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import Foundation
import RxSwift
import RxCocoa

struct ContactFormViewModel {
    private let onSaveButtonTapped = PublishRelay<Void>()

}

extension ContactFormViewModel: ContactFormViewModelApi {
    var title: Driver<String> {
        .just("Contact Form")
    }

    var isSaveButtonEnabled: Driver<Bool> {
        .just(true)
    }

    var didTapSaveButton: PublishRelay<Void> {
        onSaveButtonTapped
    }
}
