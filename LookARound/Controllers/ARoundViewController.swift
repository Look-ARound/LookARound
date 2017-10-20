//
//  ARoundViewController.swift
//  LookARound
//
//  Created by John Nguyen on 10/12/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import SceneKit
import MapKit
import CoreLocation
import ARKit

@available(iOS 11.0, *)
class ARoundViewController: UIViewController, SceneLocationViewDelegate, FilterViewControllerDelegate, ARMapViewDelegate, PlaceDetailTableViewControllerDelegate {
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet var contentView: UIView!
    
    var mapView: MapView!
    let sceneLocationView = SceneLocationView()
    var locationNodes = [AnnotationNode]()
    var currentLocation: CLLocation! {
        didSet {
            currentCoordinates = currentLocation.coordinate
        }
    }
    var currentCoordinates: CLLocationCoordinate2D?
    
    var mapTop: NSLayoutConstraint!
    var mapBottom: NSLayoutConstraint!
    
    var adjustNorthByTappingSidesOfScreen = true
    var centerMapOnUserLocation: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.shared.locationManager = sceneLocationView.locationManager
        
        addARScene()
        initMap()
        
        performFirstSearch()
        
        // Set up the UI elements as per the app theme
        prepButtonsWithARTheme(buttons: [filterButton, mapButton])
        
    }
    
    func prepButtonsWithARTheme(buttons : [UIButton]) {
        for button in buttons {
            button.setTitleColor(UIColor.LABrand.primary, for: .normal)
            button.layer.cornerRadius = button.frame.size.height * 0.5
            button.clipsToBounds = true
            button.alpha = 0.6
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sceneLocationView.run()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneLocationView.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 2D Map setup
    func initMap()
    {
        guard let coordinates = currentCoordinates else {
            print("not ready for search - no coordinates!")
            return
        }
        //mapView = MapView(at: coordinates)
        mapView = MapView()
        mapView.alpha = 0.9
        mapView.delegate = self
        sceneLocationView.locationManager.delegate = mapView
        
        view.insertSubview(mapView, at: 1)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapTop = mapView.topAnchor.constraint(equalTo: view.centerYAnchor)
        mapTop.isActive = true
        mapView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        mapBottom = mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        mapBottom.isActive = true

        // Move mapView offscreen (below view)
        self.view.layoutIfNeeded() // Do this, otherwise frame.height will be incorrect
        mapTop.constant = mapView.frame.height
        mapBottom.constant = mapView.frame.height
    }
    
    // MARK: - AR scene setup
    func addARScene() {
        view.insertSubview(sceneLocationView, at: 0)
        
        sceneLocationView.translatesAutoresizingMaskIntoConstraints = false
        sceneLocationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        sceneLocationView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        sceneLocationView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        sceneLocationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        //sceneLocationView.showAxesNode = true
        sceneLocationView.locationDelegate = self
        //sceneLocationView.locationEstimateMethod = .mostRelevantEstimate
        sceneLocationView.locationEstimateMethod = .coreLocationDataOnly
        
        guard let initialLocation = sceneLocationView.currentLocation() else {
            print("couldn't get current location!")
            return
        }
        currentLocation = initialLocation
        
        // Add a Tap Gesture Recognizer to detect taps on AnnotationNodes in AR
        sceneLocationView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.addTarget(self, action: #selector(sceneTapped(recognizer:)))
        sceneLocationView.gestureRecognizers = [tapRecognizer]
        
        performFirstSearch()
    }
    
    func performFirstSearch() {
        let categories = [FilterCategory.Food_Beverage, FilterCategory.Shopping_Retail,
                          FilterCategory.Arts_Entertainment, FilterCategory.Travel_Transportation,
                          FilterCategory.Fitness_Recreation]

        guard let coordinates = currentCoordinates else {
            print("not ready for search - no coordinates!")
            return
        }
        PlaceSearch().fetchPlaces(with: categories, location: coordinates, success: { [weak self] (places: [Place]?) in
            if let places = places {
                self?.addPlaces(places: places)
                self?.mapView.addPlaces(places: places)
            }
        }) { (error: Error) in
            print("Error fetching places with updated filters. Error: \(error)")
        }
    }
    
    func refreshPins(withCategories categories: [FilterCategory]) {
        
        removeExistingPins()
        
        // Add new pins
        guard let coordinates = currentCoordinates else {
            print("not ready for search - no coordinates!")
            return
        }
        PlaceSearch().fetchPlaces(with: categories, location: coordinates, success: { [weak self] (places: [Place]?) in
            if let places = places {
                self?.addPlaces(places: places)
                self?.mapView.addPlaces(places: places)
            }
        }) { (error: Error) in
            print("Error fetching places with updated filters. Error: \(error)")
        }
    }
    
    func addPlaces( places: [Place] )
    {
        var delta = 0
        print( "* places.count=\(places.count)")
        for index in 0..<places.count {
            let place = places[index]
            
            let name = place.name
            let idName = String(place.id)
            let pinName = "pin"
            
            let pinCoordinate = place.coordinate
            let pinLocation = place.location // CLLocation(coordinate: pinCoordinate, altitude: CLLocationDistance(50 + delta))
            
            let origImage = UIImage(named: pinName)!
            let pinImage =  origImage.addText(name as NSString, atPoint: CGPoint(x: 15, y: 0), textColor:nil, textFont:UIFont.systemFont(ofSize: 26))
            
            let pinLocationNode = AnnotationNode(location: pinLocation, image: pinImage, place: place)
            pinLocationNode.annotationNode.name = idName
            
            // Setting this to false for testing in suburbs where pins are widely spread out
            // Change this to true to test overlay on actual buildings in a downtown
            pinLocationNode.scaleRelativeToDistance = false
            
            locationNodes.append(pinLocationNode)
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode)
            
            delta += 10
            if (index % 5) == 0 {
                delta = 0
            }
        }
    }
    
    func removeExistingPins() {
        // Remove existing pins from 3D AR view
        for (index, currentLocationNode) in locationNodes.enumerated() {
            sceneLocationView.removeLocationNode(locationNode: currentLocationNode)
        }
        locationNodes.removeAll()
        
        // Remove pins from 2D map
        mapView.removeAnnotations()
        
    }
    
    // MARK: - Button interactions
    @IBAction func onMapButton(_ sender: Any) {
        slideMap()
    }
    
    func isMapHidden() -> Bool {
        return !(self.mapBottom?.constant == 0)
    }
    
    func slideMap() {
        // Slide map up/down from bottom
        let distance = self.mapBottom?.constant == 0 ? mapView.frame.height : 0
        self.mapBottom?.constant = distance
        self.mapTop?.constant = distance
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func onFilterButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Filter", bundle: nil)
        let filterNVC = storyboard.instantiateViewController(withIdentifier: "FilterNavigationControllerID") as! UINavigationController
        
        let filterVC = filterNVC.topViewController as! FilterViewController
        filterVC.delegate = self
        guard let coordinates = currentCoordinates else {
            print("not ready for filters - no coordinates!")
            return
        }
        filterVC.coordinates = coordinates
        
        present(filterNVC, animated: true, completion: nil)
    }
    
    @objc func sceneTapped(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneLocationView)
        
        let hitResults = sceneLocationView.hitTest(location, options: nil)
        if hitResults.count > 0 {
            let result = hitResults[0]
            let resultnode = result.node
            guard let nodeName = resultnode.name else {
                print("node has no name")
                return
            }
            guard let tappedNode = locationNodes.filter({ $0.annotationNode.name == nodeName }).first else {
                print("could not find the annotationNode")
                return
            }
            guard let tappedPlace = tappedNode.place else {
                print("no place attached to node")
                return
            }
            showDetailVC(forPlace: tappedPlace)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            if touch.view != nil {
                if (mapView == touch.view! ||
                    mapView.recursiveSubviews().contains(touch.view!)) {
                    centerMapOnUserLocation = false
                } else {
                    
                    let location = touch.location(in: self.view)
                    
                    if location.x <= 40 && adjustNorthByTappingSidesOfScreen {
                        print("left side of the screen")
                        sceneLocationView.moveSceneHeadingAntiClockwise(degrees: 10)
                    } else if location.x >= view.frame.size.width - 40 && adjustNorthByTappingSidesOfScreen {
                        print("right side of the screen")
                        sceneLocationView.moveSceneHeadingClockwise(degrees: 10)
                    } else {
                        /*
                        let image = UIImage(named: "pin")!
                        let annotationNode = LocationAnnotationNode(location: nil, image: image)
                        annotationNode.scaleRelativeToDistance = true
                        sceneLocationView.addLocationNodeForCurrentPosition(locationNode: annotationNode)
                         */
                    }
                }
            }
        }
    }
    
    // MARK: - FilterViewControllerDelegate
    func filterViewController(_filterViewController: FilterViewController, didSelectCategories categories: [FilterCategory]) {

        refreshPins(withCategories: categories)
    }
    
    // MARK: - ARMapViewDelegate
    func mapView(mapView: MapView, didSelectPlace place: Place) {
        showDetailVC(forPlace: place)
    }
    
    func getDirections(destLat: Double, destLong: Double) {
        if isMapHidden() {
            slideMap()
        }
        mapView.getDirections( source: (LocationService.shared.getCurrentLocation()?.coordinate)!, dest: CLLocationCoordinate2D(latitude: destLat, longitude: destLong))
    }
    
    func showDetailVC(forPlace place: Place) {
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let detailNVC = storyboard.instantiateViewController(withIdentifier: "DetailNavigationController") as! UINavigationController
        
        let detailVC = detailNVC.topViewController as! PlaceDetailTableViewController
        detailVC.place = place
        detailVC.delegate = self
        
        present(detailNVC, animated: true, completion: nil)
    }
    
    // MARK: - SceneLocationViewDelegate
    
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        // DDLogDebug("add scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        // DDLogDebug("remove scene location estimate, position: \(position), location: \(location.coordinate), accuracy: \(location.horizontalAccuracy), date: \(location.timestamp)")
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
        
    }

}

// MARK: - Extensions

extension DispatchQueue {
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: execute)
    }
}

extension UIView {
    func recursiveSubviews() -> [UIView] {
        var recursiveSubviews = self.subviews
        
        for subview in subviews {
            recursiveSubviews.append(contentsOf: subview.recursiveSubviews())
        }
        
        return recursiveSubviews
    }
}

extension SceneLocationView {
    ///Moves the scene heading clockwise by "degrees" degree
    ///Intended for correctional purposes
    public func moveSceneHeadingClockwise( degrees: Float ) {
        sceneNode?.eulerAngles.y -= Float(degrees ).degreesToRadians
    }
    
    ///Moves the scene heading anti-clockwise by "degrees" degree
    ///Intended for correctional purposes
    public func moveSceneHeadingAntiClockwise( degrees: Float ) {
        sceneNode?.eulerAngles.y += Float(degrees).degreesToRadians
    }
}

extension UIImage {
    
    func addText(_ drawText: NSString, atPoint: CGPoint, textColor: UIColor?, textFont: UIFont?) -> UIImage {
        
        // Setup the font specific variables
        var _textColor: UIColor
        if textColor == nil {
            _textColor = UIColor.yellow
        } else {
            _textColor = textColor!
        }
        
        var _textFont: UIFont
        if textFont == nil {
            _textFont = UIFont.systemFont(ofSize: 20)
            //_textFont = UIFont(name: "Helvetica-Bold", size: 15.0)
        } else {
            _textFont = textFont!
        }
        
        // Setup the image context using the passed image
        UIGraphicsBeginImageContext(size)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        
        let attributes = [
            NSAttributedStringKey.font:  _textFont,
            NSAttributedStringKey.foregroundColor: _textColor,
            NSAttributedStringKey.strokeWidth: -1,
            NSAttributedStringKey.strokeColor: UIColor.black] as [NSAttributedStringKey : Any]
        
        // Put the image into a rectangle as large as the original image
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // Create a point within the space that is as bit as the image
        let rect = CGRect(x: atPoint.x, y: atPoint.y, width: size.width, height: size.height)
        
        // Draw the text into an image
        //drawText.draw(in: rect, withAttributes: textFontAttributes)
        drawText.draw(in: rect, withAttributes: attributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
        
    }
}

