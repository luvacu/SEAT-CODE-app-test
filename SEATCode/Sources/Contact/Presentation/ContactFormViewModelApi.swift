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
    var inputName: PublishRelay<String?> { get }
    var inputSurname: PublishRelay<String?> { get }
    var inputEmail: PublishRelay<String?> { get }
    var inputPhoneNumber: PublishRelay<String?> { get }
    var inputDate: PublishRelay<Date> { get }
    var inputDescription: PublishRelay<String?> { get }
}
