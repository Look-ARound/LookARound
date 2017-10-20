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

class MapView: UIView {

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
    
    func removeDirections() {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
    }
    
    func getDirections( source: CLLocationCoordinate2D, dest: CLLocationCoordinate2D ) {
        removeDirections()
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: dest, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.add(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
}

// MARK: - Delegates
extension MapView: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let name = annotation.title {
                if let place = nameToPlaceMapping[name!] {
                    self.delegate?.mapView(mapView: self, didSelectPlace: place)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
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
