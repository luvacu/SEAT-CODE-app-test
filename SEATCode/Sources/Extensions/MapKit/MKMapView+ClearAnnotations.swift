//
//  MKMapView+ClearAnnotations.swift
//  SEATCode
//
//  Created by Luis Valdés on 11/10/2020.
//

import MapKit

extension MKMapView {
    func clearAnnotations() {
        removeAnnotations(annotations)
    }
}
