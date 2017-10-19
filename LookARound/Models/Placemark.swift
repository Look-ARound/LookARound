//
//  Place.swift
//  LookARound
//
//  Created by Angela Yu on 10/9/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

enum idType {   // If Facebook doesn't have a good Place object, use OSM or Yelp to source the data
    case fb     // Facebook
    case osm    // OpenStreetMaps
    case yelp   // Yelp
}

class Placemark: MKPlacemark {
    /* Inherited properties:
         name: String
         coordinate: CLLocationCoordinate2D (latitude: , longitude:)
         location: CLLocation (has more than coordinate, like floor, altitude, accuracy)
         postalAddress: CNPostalAddress
         country: String
         areasOfInterest: [String]?
         timeZone: TimeZone
     */
    var place: Place?
    
    init(place: Place) {
        let coordinate = place.coordinate
        self.place = place
        super.init(coordinate: coordinate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
