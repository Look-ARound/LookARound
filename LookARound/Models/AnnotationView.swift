//
//  AnnotationView.swift
//  LookARound
//
//  Created by Angela Yu on 10/11/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import MapKit

class AnnotationView: MKAnnotationView {

    /* Inherited properties:
     annotation: MKAnnotation -> coordinate, title, subtitle
     reuseIdentifier: String?
     displayPriority: MKFeatureDisplayPriority
     collisionMode: MKAnnotationViewCollisionMode
     image: UIImage?
     centerOffset: CGPoint
     calloutOffset: CGPoint
     leftCalloutAccessoryView: UIView?
     rightCalloutAccessoryView: UIView?
     detailCalloutAccessoryView: UIView?
     leftCalloutOffset: CGPoint
     rightCalloutOffset: CGPoint
    */
    var annotationLA: Annotation?   // has coordinate, title, subtitle, address, and rating
    
    init(annotation: Annotation?, reuseIdentifer: String?) {
        if let annotation = annotation {
            annotationLA = annotation
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifer)
        } else {
            super.init()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
