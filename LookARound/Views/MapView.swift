//
//  MapView.swift
//  LookARound
//
//  Created by John Nguyen on 10/14/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "MapView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
            
            // custom initialization logic
  
    }
}
