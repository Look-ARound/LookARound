//
//  List.swift
//  LookARound
//
//  Created by Siji Rachel Tom on 10/21/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import Foundation

class List: NSObject {
    var id: UUID!
    var name: String!
    var createdByUserID: UUID!
    var placeIDs = [UUID]()
    
    init(listID : String!, dictionary: [String : AnyObject?]!) {
        self.id = UUID(uuidString: listID)
        self.name = dictionary["listName"] as! String
        
        let userIDString = dictionary["createdByUserID"] as! String
        self.createdByUserID = UUID(uuidString: userIDString)
        
        if let placeIDStrings = dictionary["placeIDs"] as? [String] {
            for placeStr in placeIDStrings {
                self.placeIDs.append(UUID(uuidString: placeStr)!)
            }
        }
    }
}
