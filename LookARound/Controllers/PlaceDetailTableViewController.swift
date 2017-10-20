//
//  PlaceDetailTableViewController.swift
//  LookARound
//
//  Created by Ali Mir on 10/15/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@objc protocol PlaceDetailTableViewControllerDelegate {
    @objc optional func getDirections( destLat: Double, destLong: Double )
}

internal class PlaceDetailTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var placeImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var contextLabel: UILabel!
    @IBOutlet private var checkinsCountLabel: UILabel!
    @IBOutlet private var likesCountLabel: UILabel!
    @IBOutlet private var ratingView: HCSStarRatingView!
    @IBOutlet private var placeMapView: MKMapView!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private weak var directionsButton: UIButton!
    
    internal var place: Place?
    var delegate: PlaceDetailTableViewControllerDelegate?
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false        
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        guard let place = place else {
            return
        }
        if let imageURLString = place.picture {
            if let imageURL = URL(string: imageURLString) {
                self.placeImageView.setImageWith(imageURL)
            }
        }
        nameLabel.text = place.name
        checkinsCountLabel.text = "\(place.checkins ?? 0) checkins"
        likesCountLabel.text = "\(place.likes ?? 0) likes"
        ratingView.value = CGFloat(place.rating ?? 0)
        addressLabel.text = place.address
        contextLabel.text = place.context
        
        directionsButton.layer.cornerRadius = directionsButton.frame.size.height * 0.5
        directionsButton.clipsToBounds = true
        
        setupMapView()
    }
    
    private func setupMapView() {
        let annotation = MKPointAnnotation()
        guard let place = place else {
            return
        }
        annotation.coordinate = place.coordinate
        placeMapView.addAnnotation(annotation)
        placeMapView.showAnnotations([annotation], animated: true)
    }
    
    @IBAction func onDirectionsButton(_ sender: Any) {
        delegate?.getDirections?(destLat: (place?.latitude)!, destLong: (place?.longitude)!)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
