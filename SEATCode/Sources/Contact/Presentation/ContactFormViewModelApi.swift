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
    var inputName: BehaviorRelay<String?> { get }
    var inputSurname: BehaviorRelay<String?> { get }
    var inputEmail: BehaviorRelay<String?> { get }
    var inputPhoneNumber: BehaviorRelay<String?> { get }
    var inputDate: BehaviorRelay<Date?> { get }
    var inputDescription: BehaviorRelay<String?> { get }
}
