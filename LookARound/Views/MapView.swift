//
//  MapView.swift
//  LookARound
//
//  Created by John Nguyen on 10/14/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import MapKit

protocol ARMapViewDelegate : NSObjectProtocol {
    func mapView(mapView : MapView, didSelectPlace place: Place)
}

class MapView: UIView, MKMapViewDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    var regionRadius: CLLocationDistance = 1000 // default; allow this to get set in the future

    var nameToPlaceMapping = [String : Place]()
    weak var delegate : ARMapViewDelegate?
    var hasCenteredMap = false

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
        
        // set mapview's delegate
        mapView.delegate = self
    }

    func centerMapOnLocation(coordinates: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinates,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addPlaces( places: [Place] ) {
        for index in 0..<places.count {
            let place = places[index]
            
            let name = place.name
            let pinLocation = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            
            nameToPlaceMapping[name] = place
            addAnnotationAtCoordinate(coordinate: pinLocation, title: name )
        }
    }
    
    // add an Annotation with a coordinate: CLLocationCoordinate2D
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, title: String ) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
    
    func removeAnnotations()
    {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let name = annotation.title {
                if let place = nameToPlaceMapping[name!] {
                    self.delegate?.mapView(mapView: self, didSelectPlace: place)
                }
            }
        }
    }
}

extension MapView: LocationManagerDelegate {
    func locationManagerDidUpdateLocation(_ locationManager: LocationManager, location: CLLocation) {
        if !hasCenteredMap {
            centerMapOnLocation(coordinates: location.coordinate)
            hasCenteredMap = true
        }
    }
    func locationManagerDidUpdateHeading(_ locationManager: LocationManager, heading: CLLocationDirection, accuracy: CLLocationDirection) {
    }
}
