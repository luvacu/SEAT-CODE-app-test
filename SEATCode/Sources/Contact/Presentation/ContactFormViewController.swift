//
//  ContactFormViewController.swift
//  SEATCode
//
//  Created by Luis Valdés on 12/10/2020.
//

import UIKit
import RxSwift

final class ContactFormViewController: UITableViewController {
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var surnameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var phoneTextField: UITextField!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var descriptionTextView: UITextView!
    private let disposeBag = DisposeBag()
    private let viewModel: ContactFormViewModelApi

    private init?(coder: NSCoder, viewModel: ContactFormViewModelApi) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupBinding()
    }
}

extension ContactFormViewController {
    static func make(viewModel: ContactFormViewModelApi) -> ContactFormViewController {
        makeFromStoryboard {
            ContactFormViewController(coder: $0, viewModel: viewModel)
        }
    }
}

private extension ContactFormViewController {
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: nil,
                                                            action: nil)
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(to: viewModel.didTapSaveButton)
            .disposed(by: disposeBag)
    }

    func setupBinding() {
        viewModel.title
            .drive(rx.title)
            .disposed(by: disposeBag)

        viewModel.isSaveButtonEnabled
            .drive(navigationItem.rightBarButtonItem!.rx.isEnabled)
            .disposed(by: disposeBag)

        nameTextField.rx.text
            .bind(to: viewModel.inputName)
            .disposed(by: disposeBag)
        surnameTextField.rx.text
            .bind(to: viewModel.inputSurname)
            .disposed(by: disposeBag)
        emailTextField.rx.text
            .bind(to: viewModel.inputEmail)
            .disposed(by: disposeBag)
        phoneTextField.rx.text
            .bind(to: viewModel.inputPhoneNumber)
            .disposed(by: disposeBag)
        datePicker.rx.date
            .bind(to: viewModel.inputDate)
            .disposed(by: disposeBag)
        descriptionTextView.rx.text
            .bind(to: viewModel.inputDescription)
            .disposed(by: disposeBag)
    }
}
