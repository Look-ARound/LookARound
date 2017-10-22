//
//  List.swift
//  LookARound
//
//  Created by Siji Rachel Tom on 10/21/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import Foundation

var firebaseListIDKey = "listID"
var firebaseListNameKey = "listName"
var firebaseCreatedByUserIDKey = "createdByUserID"
var firebasePlaceIDArrayKey = "placeIDs"


class List: NSObject {
    var id: UUID!
    var name: String!
    var createdByUserID: UUID!
    var placeIDs = [UUID]()
    
    init(listID : String!, dictionary: [String : AnyObject?]!) {
        self.id = UUID(uuidString: listID)
        self.name = dictionary[firebaseListNameKey] as! String
        
        let userIDString = dictionary[firebaseCreatedByUserIDKey] as! String
        self.createdByUserID = UUID(uuidString: userIDString)
        
        if let placeIDStrings = dictionary[firebasePlaceIDArrayKey] as? [String] {
            for placeStr in placeIDStrings {
                self.placeIDs.append(UUID(uuidString: placeStr)!)
            }
        }
    }
    
    func firebaseRepresentation() -> NSDictionary {
        let dict : NSMutableDictionary
        dict[firebaseListNameKey] = self.name
        dict[firebaseCreatedByUserIDKey] = self.id.uuidString
        
        // Change placeIDs to UUID strings
        var placeIDStrings = [String]()
        for placeID in self.placeIDs {
            placeIDStrings.append(placeID.uuidString)
        }
        
        dict[firebasePlaceIDArrayKey] = placeIDStrings
    }
}
