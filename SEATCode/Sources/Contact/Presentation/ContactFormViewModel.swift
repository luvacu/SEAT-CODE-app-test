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
    private let nameRelay = BehaviorRelay<String?>(value: nil)
    private let surnameRelay = BehaviorRelay<String?>(value: nil)
    private let emailRelay = BehaviorRelay<String?>(value: nil)
    private let phoneNumberRelay = BehaviorRelay<String?>(value: nil)
    private let dateRelay = BehaviorRelay<Date?>(value: nil)
    private let descriptionRelay = BehaviorRelay<String?>(value: nil)
    private let disposeBag = DisposeBag()
    private let repository: IssuesRepositoryApi
    private let notificationService: NotificationServiceApi

    init(repository: IssuesRepositoryApi, notificationService: NotificationServiceApi) {
        self.repository = repository
        self.notificationService = notificationService
        subscribeToSaveButtonTap()
    }

    func subscribeToSaveButtonTap() {
        onSaveButtonTapped
            .flatMap { _ -> Completable in
                guard let name = self.nameRelay.value,
                      let surname = self.surnameRelay.value,
                      let email = self.emailRelay.value,
                      let date = self.dateRelay.value,
                      let description = self.descriptionRelay.value else {
                    return Completable.empty()
                }
                let issue = Issue(userName: name,
                                  userSurname: surname,
                                  userEmail: email,
                                  userPhoneNumber: self.phoneNumberRelay.value,
                                  date: date,
                                  description: description)
                return self.repository.store(issue: issue)
                    .flatMapCompletable { issuesCount in
                        self.notificationService.updateBadge(number: issuesCount)
                    }
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
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
            dateRelay.map { ($0 ?? Date.distantFuture) <= Date() },
            descriptionRelay.map { text in
                guard let description = text,
                      !description.isEmpty else {
                    return false
                }
                return description.count <= 200
            },
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

    var inputName: BehaviorRelay<String?> {
        nameRelay
    }

    var inputSurname: BehaviorRelay<String?> {
        surnameRelay
    }

    var inputEmail: BehaviorRelay<String?> {
        emailRelay
    }

    var inputPhoneNumber: BehaviorRelay<String?> {
        phoneNumberRelay
    }

    var inputDate: BehaviorRelay<Date?> {
        dateRelay
    }

    var inputDescription: BehaviorRelay<String?> {
        descriptionRelay
    }
}
