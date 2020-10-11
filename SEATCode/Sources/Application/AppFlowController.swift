//
//  AppFlowController.swift
//  SEATCode
//
//  Created by Luis Valdés on 07/10/2020.
//

import UIKit
import RxSwift

final class AppFlowController: UIViewController {
    private let container: DependencyContainer
    private let disposeBag = DisposeBag()
    private let embeddedNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()

    init(container: DependencyContainer) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var childForStatusBarStyle: UIViewController? {
        return embeddedNavigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        add(child: embeddedNavigationController)
        showTrips()
    }
}

private extension AppFlowController {
    func showTrips() {
        let viewModel = TripsViewModel(repository: container.resolve(TripsRepositoryApi.self))
        let viewController = TripsViewController.make(viewModel: viewModel)
        embeddedNavigationController.viewControllers = [viewController]

        viewModel.didTapReportButton
            .subscribe { [weak self] _ in
                self?.showContactForm()
            }
            .disposed(by: disposeBag)
    }

    func showContactForm() {
        let viewModel = ContactFormViewModel()
        let viewController = ContactFormViewController.make(viewModel: viewModel)
        embeddedNavigationController.present(UINavigationController(rootViewController: viewController),
                                             animated: true)
    }
}
