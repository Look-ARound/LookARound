//
//  AnnotationNode.swift
//  LookARound
//
//  Created by Angela Yu on 10/17/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import CoreLocation

class AnnotationNode: LocationAnnotationNode {
    var place: Place?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(location: CLLocation?, image: UIImage) {
        super.init(location: location, image: image)
    }
    
    public init(location: CLLocation?, image: UIImage, place: Place) {
        super.init(location: location, image: image)
        self.place = place
    }
}
