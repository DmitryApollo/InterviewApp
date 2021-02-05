//
//  LocationViewController.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {

    var viewModel: LocationViewModelProtocol!
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        prepareViewModelObserver()
        viewModel.setUserLocation()
    }
    
    private func setUpUI() {
        view.backgroundColor = .black
        setUpTableView()
    }
    
    private func prepareViewModelObserver() {
        viewModel.locationDidChanges = { [weak self] (finished, error) in
            guard let self = self else { return }
            if let _ = error {
                return
            }
            
            if finished {
                guard let annotation = self.viewModel.userAnnotation else { return }
                self.mapView.addAnnotation(annotation)
                self.mapView.centerCoordinate = annotation.coordinate
            }
        }
    }
}

extension LocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}

extension LocationViewController {
    private func setUpTableView() {
        view.addSubview(mapView)
        
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.topMargin, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: mapView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        
        view.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
}
