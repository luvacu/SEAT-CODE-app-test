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
    private let nameRelay = PublishRelay<String?>()
    private let surnameRelay = PublishRelay<String?>()
    private let emailRelay = PublishRelay<String?>()
    private let phoneNumberRelay = PublishRelay<String?>()
    private let dateRelay = PublishRelay<Date>()
    private let descriptionRelay = PublishRelay<String?>()

}

extension ContactFormViewModel: ContactFormViewModelApi {
    var title: Driver<String> {
        .just("Contact Form")
    }

    var isSaveButtonEnabled: Driver<Bool> {
        let mandatoryFieldsAreValid = Observable.combineLatest([
            nameRelay.map { $0?.isValidNameOrSurname ?? false },
            surnameRelay.map { $0?.isValidNameOrSurname ?? false },
            emailRelay.map { $0?.isValidEmail ?? false },
            dateRelay.map { $0 <= Date() },
            descriptionRelay.map { ($0?.count ?? 0) <= 200 },
        ]) { validations in
            validations.allSatisfy { $0 == true }
        }
        let optionalFieldsAreEmptyOrValid = phoneNumberRelay
            .map { input in
                guard let input = input,
                      !input.isEmpty else {
                    return true
                }
                return input.isValidPhoneNumber
            }
            .startWith(true)
        return Observable.combineLatest([mandatoryFieldsAreValid, optionalFieldsAreEmptyOrValid]) { validations in
            validations.allSatisfy { $0 == true }
        }
        .startWith(false)
        .asDriver(onErrorJustReturn: false)
    }

    var didTapSaveButton: PublishRelay<Void> {
        onSaveButtonTapped
    }

    var inputName: PublishRelay<String?> {
        nameRelay
    }

    var inputSurname: PublishRelay<String?> {
        surnameRelay
    }

    var inputEmail: PublishRelay<String?> {
        emailRelay
    }

    var inputPhoneNumber: PublishRelay<String?> {
        phoneNumberRelay
    }

    var inputDate: PublishRelay<Date> {
        dateRelay
    }

    var inputDescription: PublishRelay<String?> {
        descriptionRelay
    }
}
