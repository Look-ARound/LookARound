//
//  LocationService.swift
//  LookARound
//
//  Created by John Nguyen on 10/20/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import CoreLocation

class LocationService {
    static let shared = LocationService()
    var locationManager: LocationManager?

    func getCurrentLocation() -> CLLocation? {
        return locationManager?.currentLocation
    }
    
    func getCurrentCoordinates() -> CLLocationCoordinate2D? {
        return getCurrentLocation()?.coordinate
    }

}
