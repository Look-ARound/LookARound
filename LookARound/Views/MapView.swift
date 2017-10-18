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
    var locValue: CLLocationCoordinate2D?
    var regionRadius: CLLocationDistance = 1000 // default; allow this to get set in the future
   // var locationManager : CLLocationManager!

    var nameToPlaceMapping = [String : Place]()
    weak var delegate : ARMapViewDelegate?
    
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
    
    init(at center: CLLocationCoordinate2D) {
        self.init()
        self.locValue = center
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
        guard let currentCoordinates = locValue else {
            print("no coordinates yet!")
            return
        }
        centerMapOnLocation(coordinates: currentCoordinates)

        // custom initialization logic -- COMMENT OUT TO TEST NEW UNIFIED LM
//        locationManager = CLLocationManager() // can we access sceneLocationView's location manager instead?
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.distanceFilter = 200
//        locationManager.requestWhenInUseAuthorization()
    }

    func centerMapOnLocation(coordinates: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinates,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        print("centering")
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
    
    // TODO: John what is this method used for? No one's calling it currently.
//    func goToLocation(location: CLLocation) {
//        let span = MKCoordinateSpanMake(0.1, 0.1)
//        let region = MKCoordinateRegionMake(location.coordinate, span)
//        mapView.setRegion(region, animated: false)
//    }
    
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
    
    
    // COMMENT OUT FOR UNIFIED LM
//    func getCurrentLocation() {
//        let locationManager = CLLocationManager()
//
//        // Ask for Authorization from the User.
//        self.locationManager.requestAlwaysAuthorization()
//
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
//    }
//
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        var locValue:CLLocationCoordinate2D = manager.location.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
    
    // MARK: - CLLocationManagerDelegate
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == CLAuthorizationStatus.authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            let span = MKCoordinateSpanMake(0.1, 0.1)
//            let region = MKCoordinateRegionMake(location.coordinate, span)
//            mapView.setRegion(region, animated: false)
//        }
//
//        locValue = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
    
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
