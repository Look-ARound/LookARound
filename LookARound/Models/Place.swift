//
//  Place.swift
//  LookARound
//
//  Created by Angela Yu on 10/12/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

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

internal class Place: NSObject {
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
    
    init?(json: JSON) {
        // TODO Guard against json not having required values
        id = Int64(json["id"].intValue)
        name = json["name"].stringValue
        latitude = json["location"]["latitude"].doubleValue
        longitude = json["location"]["longitude"].doubleValue
        address = json["address"].stringValue
        about = json["about"].stringValue
        picture = json["picture"]["data"]["url"].stringValue
        context = json["context"]["friends_who_like"]["summary"]["social_sentence"].stringValue
        contextCount = json["context"]["friends_who_like"]["summary"]["total_count"].intValue
        checkins = json["checkins"].intValue
        engagement = json["engagement"]["social_sentence"].stringValue
        likes = json["engagement"]["count"].intValue
    }
}
