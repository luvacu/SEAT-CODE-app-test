//
//  MKMapView+ClearOverlays.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import MapKit

extension MKMapView {
    func clearOverlays() {
        removeOverlays(overlays)
    }
}
