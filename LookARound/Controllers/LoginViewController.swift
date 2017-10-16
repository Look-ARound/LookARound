//
//  LoginViewController.swift
//  LookARound
//
//  Created by Angela Yu on 10/12/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import AFNetworking

class LoginViewController: UIViewController, LoginButtonDelegate {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var placeLabel: UILabel!
    @IBOutlet private var placeImageView: UIImageView!
    @IBOutlet private var placeContextLabel: UILabel!
    
    var mapView: MapView!
    var places: [Place]?
    var completionHandler: (([Place]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("presenting login button")
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .userFriends ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        print("added login button to login storyboard")
        
    }

    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("login")
        AppEventsLogger.log("Login")
        
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("logout")
        AppEventsLogger.log("Logout")
    }

    @IBAction func onAboutMe(_ sender: Any) {
        print("fetching me")
        print("accessToken: \(String(describing: AccessToken.current))")
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            switch result {
            case .success(let response):
                self.nameLabel.text = response.name
                self.nameLabel.sizeToFit()
                let url = URL(string: response.photoURL)
                self.profileImageView.setImageWith(url!)
                print("Custom Graph Request Succeeded: \(response)")
                print("My facebook id is \(response.id)")
                print("My name is \(response.name)")
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    // Sample code for calling a place search to request an array of places near you
    @IBAction func onAroundMe(_ sender: Any) {
        print("fetching places")
        let categories = [FilterCategory.Food_Beverage, FilterCategory.Fitness_Recreation]
        
         PlaceSearch().fetchPlaces(with: categories, location: mapView.locValue, success: { (places : [Place]?) in
            if let places = places {
                self.placeLabel.text = places[1].name
                self.placeLabel.sizeToFit()
                let url = URL(string: places[1].picture!)
                self.placeImageView.setImageWith(url!)
                self.placeContextLabel.text = places[1].context
                self.placeContextLabel.sizeToFit()
                self.places = places
                self.performSegue(withIdentifier: "results", sender: self)
                // print("Custom Graph Request Succeeded: \(response)")
                self.completionHandler?(places)
            }
            //self.dismiss(animated: true, completion: nil )
        }) { (error: Error) in
            print("Custom Graph Request Failed: \(error)")
        }
 
    }
    
    // MARK: - Navigation
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "results" {
            let destinationVC = segue.destination as! SearchResultsViewController
            
            if let places = self.places {
                print("attaching places")
                destinationVC.places = places
                // TODO Angela Calling viewDidLoad directly is not encouraged in iOS. For this particular use case, maybe you could reload the tableview in viewWillAppear? Another option would be to reload it in the setter of the places ivar. (Assuming that's what you're trying to do, else we should chat)
                destinationVC.viewDidLoad()
            }
        }
    }
}

// MARK: - Delegates

