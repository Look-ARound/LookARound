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
    // var location: CLLocationCoordinate2D // Deprecated
    var latitude: Double
    var longitude: Double
    var address: String?
    var about: String?
    var categories: [Categories]?
    var picture: String? = ""
    var contextCount: Int?
    var context: String?
    var checkins: Int?
    var likes: Int?
    var engagement: String?
    var rating: Int?

    init(id: Int64, name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }

}
