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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("presenting login button")
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .userFriends ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        print("added login button to login storyboard")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func onAroundMe(_ sender: Any) {
        print("fetching places")
        let connection = GraphRequestConnection()
        connection.add(PlaceSearchRequest()) { response, result in
            switch result {
            case .success(let response):
                self.placeLabel.text = response.places[0].name
                self.placeLabel.sizeToFit()
                print("Custom Graph Request Succeeded: \(response)")
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
}

// MARK: - Delegates

