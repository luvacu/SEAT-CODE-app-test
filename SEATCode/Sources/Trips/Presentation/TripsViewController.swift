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
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.didSelectTripIndex.accept(indexPath.row)
            })
            .disposed(by: disposeBag)

        viewModel.selectedTripMapDetails
            .drive { [weak self] tripMapDetails in
                self?.showTripInMap(tripMapDetails)
            }
            .disposed(by: disposeBag)

        viewModel.selectedStopDetails
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] stopDetails in
                self?.showPopup(message: stopDetails.description)
            }
            .disposed(by: disposeBag)
    }

    func showTripInMap(_ tripMapDetails: TripMapDetails) {
        mapView.clearAnnotations()
        mapView.clearOverlays()
        mapView.showAnnotations([tripMapDetails.origin, tripMapDetails.destination] + tripMapDetails.stops, animated: true)
        if let polyline = tripMapDetails.route {
            mapView.addOverlay(polyline, level: .aboveRoads)
        }
    }

    func showPopup(message: String) {
        let alert = UIAlertController(title: "Stop", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension TripsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .red
        renderer.lineWidth = 3
        return renderer
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let locationAnnotation = view.annotation as? LocationAnnotation,
              let stopId = locationAnnotation.stopId else {
            return
        }
        viewModel.didSelectStopId.accept(stopId)
    }
}
