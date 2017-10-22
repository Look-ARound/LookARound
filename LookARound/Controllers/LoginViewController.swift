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
import CoreLocation

class LoginViewController: UIViewController, LoginButtonDelegate {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var placeLabel: UILabel!
    @IBOutlet private var placeImageView: UIImageView!
    @IBOutlet private var placeContextLabel: UILabel!
    
    var coordinates: CLLocationCoordinate2D!
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
        ProfileRequest().fetchCurrentUser(success: { (user : User) in
            self.nameLabel.text = user.name
            self.nameLabel.sizeToFit()
            if let url = URL(string: user.profileImageURL!) {
                self.profileImageView.setImageWith(url)
            }
            print("Custom Graph Request Succeeded")
            print("My facebook id is \(user.id)")
            print("My name is \(user.name)")
        }) { (error: Error) in
            print("Custom Graph Request Failed: \(error)")
        }
    }
    
    // Sample code for calling a place search to request an array of places near you
    @IBAction func onAroundMe(_ sender: Any) {
        print("fetching places")
        let categories = [FilterCategory.Food_Beverage, FilterCategory.Shopping_Retail,
                          FilterCategory.Arts_Entertainment, FilterCategory.Travel_Transportation,
                          FilterCategory.Fitness_Recreation]
        
        PlaceSearch().fetchPlaces(with: categories, location: coordinates, success: { (places : [Place]?) in
            if let places = places {
                print("placecount = \(places.count)")
                self.placeLabel.text = places[1].name
                self.placeLabel.sizeToFit()
                if let url = URL(string: places[1].thumbnail!) {
                    self.placeImageView.setImageWith(url)
                }
                self.placeContextLabel.text = places[1].context
                self.placeContextLabel.sizeToFit()
                self.places = places
                self.performSegue(withIdentifier: "results", sender: self)
                // print("Custom Graph Request Succeeded: \(response)")
                self.completionHandler?(places)
            }
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
            }
        }
    }
}

// MARK: - Delegates

