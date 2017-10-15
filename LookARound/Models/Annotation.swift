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

    
    init(placemark: Placemark?) {
        if let placemark = placemark {
            self.title = placemark.place?.name
            self.coordinate = placemark.coordinate
            self.about = placemark.place?.about
        } else {
            self.coordinate = CLLocationCoordinate2D(latitude: 37.4816734, longitude: -122.1556204)
            self.title = ""
            self.about = ""
        }
        
        super.init()
    }
    
    var subtitle: String? {
        return about
    }
}
