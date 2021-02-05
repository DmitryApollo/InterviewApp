//
//  LocationViewModel.swift
//  InterviewApp
//
//  Created by Дмитрий on 05/02/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation
import MapKit

protocol LocationViewModelProtocol {
    var locationDidChanges: ((Bool, Error?) -> Void)? { get set }
    var location: Location { get set }
    var userAnnotation: MKAnnotation? { get set }
    
    init(location: Location)
    func setUserLocation()
}

final class LocationViewModel: LocationViewModelProtocol {
    var locationDidChanges: ((Bool, Error?) -> Void)?
    var location: Location
    
    var userAnnotation: MKAnnotation? {
        didSet {
            self.locationDidChanges!(true, nil)
        }
    }
    
    init(location: Location) {
        self.location = location
    }
    
    func setUserLocation() {
        let userAnnotation = MKPointAnnotation()
        userAnnotation.title = location.city
        userAnnotation.subtitle = location.country
        userAnnotation.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        self.userAnnotation = userAnnotation
    }
}

