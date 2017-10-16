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
import ARKit
import ARCL
import CoreLocation

@available(iOS 11.0, *)
class ARoundViewController: UIViewController, SceneLocationViewDelegate, FilterViewControllerDelegate {
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var mapView: MapView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mapBottom: NSLayoutConstraint!
    @IBOutlet weak var mapTop: NSLayoutConstraint!
    
    let sceneLocationView = SceneLocationView()
    var filterCategories : [FilterCategory]!
    
    var adjustNorthByTappingSidesOfScreen = true
    var centerMapOnUserLocation: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addARScene()

        // Set up the UI elements as per the app theme
        prepButtonsWithARTheme(buttons: [filterButton, mapButton, friendsButton])
        
        // Set up default filter categories for inital launch
        filterCategories = [FilterCategory.Food_Beverage, FilterCategory.Fitness_Recreation]
        
        initMap()
    }
    
    func prepButtonsWithARTheme(buttons : [UIButton]) {
        for button in buttons {
            button.setTitleColor(UIColor.LABrand.primary, for: .normal)
            button.layer.cornerRadius = friendsButton.frame.size.height * 0.5
            button.clipsToBounds = true
            button.alpha = 0.6
        }
    }

    
    func initMap()
    {
        mapView.alpha = 0.9
        // Move mapView offscreen (below view)
        self.view.layoutIfNeeded() // Do this, otherwise frame.height will be incorrect
        mapTop.constant = mapView.frame.height
        mapBottom.constant = mapView.frame.height
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneLocationView.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addARScene() {
        view.insertSubview(sceneLocationView, at: 0)
        
        sceneLocationView.translatesAutoresizingMaskIntoConstraints = false
        sceneLocationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        sceneLocationView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        sceneLocationView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        sceneLocationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        sceneLocationView.locationDelegate = self
        
        sceneLocationView.locationEstimateMethod = .coreLocationDataOnly
        //sceneLocationView.showAxesNode = true
        sceneLocationView.locationDelegate = self
        //sceneLocationView.locationEstimateMethod = .mostRelevantEstimate
        sceneLocationView.locationEstimateMethod = .coreLocationDataOnly
    }
    
    func addPlaces( places: [Place] )
    {
        var delta = 0
        print( "* places.count=\(places.count)")
        for index in 0..<places.count {
            let place = places[index]
            
            let name = place.name
            let pinName = "pin_home"
            
            let pinCoordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            let pinLocation = CLLocation(coordinate: pinCoordinate, altitude: CLLocationDistance(50 + delta))
            
            let origImage = UIImage(named: pinName)!
            let pinImage =  origImage.addText(name as! NSString, atPoint: CGPoint(x: 15, y: 0), textColor:nil, textFont:UIFont.systemFont(ofSize: 26))
            
            var pinLocationNode = LocationAnnotationNode(location: pinLocation, image: pinImage)
            
            pinLocationNode.scaleRelativeToDistance = false
            
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode)
            
            delta += 10
            if (index % 5) == 0 {
                delta = 0
            }
        }
    }
    
    @IBAction func onMapButton(_ sender: Any) {
        
        // Slide map up/down from bottom
        let distance = self.mapBottom?.constant == 0 ? mapView.frame.height : 0
        self.mapBottom?.constant = distance
        self.mapTop?.constant = distance
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func onFriendsButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginNavigationController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
        
        let loginViewController = loginNavigationController.topViewController as! LoginViewController
        loginViewController.mapView = mapView
        loginViewController.completionHandler = { places in
            print( "* places.count=\(places.count)")
            self.addPlaces( places: places )
        }
        
        present(loginNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func onFilterButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Filter", bundle: nil)
        let filterNVC = storyboard.instantiateViewController(withIdentifier: "FilterNavigationControllerID") as! UINavigationController
        
        let filterVC = filterNVC.topViewController as! FilterViewController
        filterVC.delegate = self
        
        present(filterNVC, animated: true, completion: nil)
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
        filterCategories = categories
        PlaceSearch().fetchPlaces(with: filterCategories, location: self.mapView.locValue, success: { [weak self] (places: [Place]?) in
            if let places = places {
                self?.addPlaces(places: places)
                self?.mapView.addPlaces(places: places)
            }
        }) { (error: Error) in
            print("Error fetching places with updated filters. Error: \(error)")
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
    ///Moves the scene heading clockwise by 1 degree
    ///Intended for correctional purposes
    public func moveSceneHeadingClockwise( degrees: Float ) {
        sceneNode?.eulerAngles.y -= Float(degrees ).degreesToRadians
    }
    
    ///Moves the scene heading anti-clockwise by 1 degree
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

