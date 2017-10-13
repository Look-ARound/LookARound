//
//  Annotation.swift
//  LookARound
//
//  Created by Angela Yu on 10/11/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var about: String?
    var address: String?
    var rating: Int?

    
    init(place: Place?) {
        if let place = place {
            self.title = place.name
            self.about = place.about
            self.coordinate = place.location
        } else {
            self.coordinate = CLLocationCoordinate2D(latitude: 37.4816734, longitude: -122.1556204)
        }
        
        super.init()
    }
    
    var subtitle: String? {
        return about
    }
}
