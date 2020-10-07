//
//  TripsViewController.swift
//  SEATCode
//
//  Created by Luis Valdés on 07/10/2020.
//

import UIKit

final class TripsViewController: UIViewController {
    private let viewModel: TripsViewModelApi

    private init?(coder: NSCoder, viewModel: TripsViewModelApi) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TripsViewController {
    static func make(viewModel: TripsViewModelApi) -> TripsViewController {
        makeFromStoryboard {
            TripsViewController(coder: $0, viewModel: viewModel)
        }
    }
}
