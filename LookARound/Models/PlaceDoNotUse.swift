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

class PlaceDoNotUse: MKPlacemark {
    /* Inherited properties:
         name: String
         coordinate: CLLocationCoordinate2D (latitude: , longitude:)
         location: CLLocation (has more than coordinate, like floor, altitude, accuracy)
         postalAddress: CNPostalAddress
         country: String
         areasOfInterest: [String]?
         timeZone: TimeZone
     */
    var idTuple: (idType: idType, id: Int64)
    var about: String?
    var categories: Categories?
    var photoURL: String?
    var checkins: Int?
    var rating: Int?
    
    // USAGE: let newPlace = Place(idType: .fb, id: 895790720471601, coordinate: (67.39438425015, -122.348495), dictionary: [:])
    init(idType: idType, idNum: Int64, coordinate: CLLocationCoordinate2D, dictionary: NSDictionary) {
        idTuple = (.fb, 895790720471601) // will be idTuple = (idType, idNum)
        super.init(coordinate: coordinate)
        about = "Facebook Building 20"
        categories = Categories.shoppingRetail
        photoURL = "https://scontent.fsnc1-1.fna.fbcdn.net/v/t1.0-1/p160x160/11091327_10153107797145155_1584955392381521389_n.jpg?oh=e4efdc696b90628db5a15d8f9c2154fb&oe=5A3D6BAB"
        checkins = 32817
        rating = 5
    }
    
    convenience init(idType: idType, idNum: Int64, latitude: CLLocationDegrees, longitude: CLLocationDegrees,
                     dictionary: NSDictionary) {
        self.init(idType: idType, idNum: idNum, coordinate: CLLocationCoordinate2D(latitude: latitude,
                                                                       longitude: longitude), dictionary: dictionary)
    }
    
    required init?(coder aDecoder: NSCoder) {
        idTuple = (.fb, 895790720471601) // will be idTuple = (idType, idNum)
        super.init(coder: aDecoder)
    }
}
