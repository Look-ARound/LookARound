//
//  DatabaseRequests.swift
//  LookARound
//
//  Created by Siji Rachel Tom on 10/21/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import Foundation
import Firebase

class DatabaseRequests {
    var ref: DatabaseReference = Database.database().reference()
    var fetchedOnce : Bool = false
    var allLists = [List]()
    
    func fetchCurrentUserLists(success: @escaping ([List]?)->(), failure: @escaping (Error)->()) -> Void {
        var currentUserLists = [List]()
        
        ProfileRequest().fetchCurrentUserID(success: { (userID: UUID) in
            // Get all lists
            // Filter by those created by userID
            self.fetchAllLists(completion: { (lists: [List]) -> () in
                for list in lists {
                    if list.createdByUserID == userID {
                        currentUserLists.append(list)
                    }
                }
                success(currentUserLists)
            })
        }, failure: { (error: Error) in
            print("Could not get UserID. Error: \(error)")
        })
    }
    
    func fetchAllLists(completion: (([List])->())!) -> Void {
        if fetchedOnce {
            completion(self.allLists)
            return
        }
        
        ref.child("lists").observe(DataEventType.value) { (dataSnapshot: DataSnapshot) in
            if let listDicts = dataSnapshot.value as? [String : AnyObject?] {
                for (listIDStr, listDict) in listDicts {
                    let newList = List(listID: listIDStr, dictionary: listDict as! [String : AnyObject?])
                    self.allLists.append(newList)
                }
            }
            
            completion(self.allLists)
        }
    }
}

