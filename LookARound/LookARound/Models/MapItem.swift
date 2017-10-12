//
//  MapItem.swift
//  LookARound
//
//  Created by Angela Yu on 10/11/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import MapKit

class MapItem: MKMapItem {
    /* Inherited properties:
     placemark: MKPlacemark
     isCurrentLocation: Bool is this the map item for user's current location?
     name: String?
     phoneNumber: String?
     url: URL?
     timeZone: TimeZone?
     */
    var place: Place?
    
    init(place: Place) {
        self.place = place
        super.init(placemark: place)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
