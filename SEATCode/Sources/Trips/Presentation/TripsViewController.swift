//
//  TripsViewController.swift
//  SEATCode
//
//  Created by Luis Valdés on 07/10/2020.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

final class TripsViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    @IBOutlet private var tableView: UITableView! {
        didSet {
        }
    }
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    private let disposeBag = DisposeBag()
    private let viewModel: TripsViewModelApi

    private init?(coder: NSCoder, viewModel: TripsViewModelApi) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
}

extension TripsViewController {
    static func make(viewModel: TripsViewModelApi) -> TripsViewController {
        makeFromStoryboard {
            TripsViewController(coder: $0, viewModel: viewModel)
        }
    }
}

private extension TripsViewController {
    func setupBinding() {
        viewModel.title
            .drive { [weak self] title in
                self?.title = title
            }
            .disposed(by: disposeBag)
        viewModel.trips
            .do(onNext: { [weak self] _ in
                self?.activityIndicator.isHidden = true
            })
            .drive(tableView.rx.items(cellIdentifier: "TripCell", cellType: TripCell.self)) { _, trip, cell  in
                cell.configure(trip: trip)
            }
            .disposed(by: disposeBag)
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                print("selected \(indexPath)")
            })
            .disposed(by: disposeBag)
    }
}

extension TripsViewController: MKMapViewDelegate {

}
