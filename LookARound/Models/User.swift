//
//  User.swift
//  LookARound
//
//  Created by Angela Yu on 10/9/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit

class User: NSObject {
    // MARK: - Properties
    var name: String
    var username: String
    var profileImageURL: String?
    
    // MARK: - Init
    init(dictionary: NSDictionary) {
        name = "Jordan Doe"
        username = "jordandoe"
        profileImageURL = "https://imageog.flaticon.com/icons/png/512/23/23957.png"
    }
}
