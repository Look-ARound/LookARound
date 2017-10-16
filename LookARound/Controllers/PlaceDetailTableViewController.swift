//
//  PlaceDetailTableViewController.swift
//  LookARound
//
//  Created by Ali Mir on 10/15/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import MapKit

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
    
    internal var place: Place?
    
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
        setupMapView()
    }
    
    private func setupMapView() {
        let annotation = MKPointAnnotation()
        guard let place = place else {
            return
        }
        annotation.coordinate = place.location
        placeMapView.addAnnotation(annotation)
        placeMapView.showAnnotations([annotation], animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
