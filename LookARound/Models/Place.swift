//
//  Place.swift
//  LookARound
//
//  Created by Angela Yu on 10/12/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import CoreLocation

enum Categories: String {
    case artsEntertainment = "ARTS_ENTERTAINMENT"
    case education = "EDUCATION"
    case fitnessRecreation = "FITNESS_RECREATION"
    case foodBeverage = "FOOD_BEVERAGE"
    case hotelLodging = "HOTEL_LODGING"
    case medicalHealth = "MEDICAL_HEALTH"
    case shoppingRetail = "SHOPPING_RETAIL"
    case travelTransportation = "TRAVEL_TRANSPORTATION"
}

class Place: NSObject {
    var id: Int64
    var name: String
    var location: CLLocationCoordinate2D
    var address: String
    var about: String?
    var categories: [Categories]?
    var picture: String?
    var context_count: Int?
    var context: String?
    var checkins: Int?
    var likes: Int?
    var rating: Int?

    init(id: Int64, name: String, location: CLLocationCoordinate2D, address: String) {
        self.id = id
        self.name = name
        self.location = location
        self.address = address
    }

}
