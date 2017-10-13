//
//  PlaceRequest.swift
//  LookARound
//
//  Created by Angela Yu on 10/12/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import Foundation
import FacebookCore
import CoreLocation
import SwiftyJSON

struct MyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        var id: String
        var name: String
        var photoURL: String
        
        init(rawResponse: Any?) {
            // Decode JSON from rawResponse into other properties here.
            let json = JSON(rawResponse!)
            print(json)
            id = json["id"].stringValue
            name = json["name"].stringValue
            photoURL = json["picture"]["data"]["url"].stringValue
            
            print(id)
            print(name)
            print(photoURL)
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name, picture{url}"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}

struct PlaceSearchRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        var places: [Place]
        
        init(rawResponse: Any?) {
            // Decode JSON from rawResponse into other properties here.
            let json = JSON(rawResponse!)
            print(json)
            places = []
            for spot in json["data"].arrayValue {
                let placeID = spot["id"].intValue
                let placeName = spot["name"].stringValue
                let placeLat = spot["location"]["latitude"].double
                let placeLon = spot["location"]["longitude"].double
                let coordinates = CLLocationCoordinate2D(latitude: placeLat!, longitude: placeLon!)
                let placeAddr = spot["location"]["street"].stringValue
                let thisPlace = Place(id: Int64(placeID), name: placeName, location: coordinates, address: placeAddr)
                places.append(thisPlace)
            }
        }
    }
    
    var graphPath = "/search?type=place&center=37.4816734,-122.1556204" //&categories=[\"FOOD_BEVERAGE\",\"FITNESS_RECREATION\",\"SHOPPING_RETAIL\"]"
    var parameters: [String: Any]? = ["fields": "name, about, id, location, context, engagement, checkins, picture, photos, cover"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
    
    /* API response for Angela Yu searching at Builing 20:
     use JSON viewer to collapse and expand tree here https://codebeautify.org/jsonviewer/cb147a70
     */
    
    /* Objective-C version
     FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
     initWithGraphPath:@"/search"
     parameters:@{ @"type": @"place",@"center": @"37.4816734,-122.1556204",@"categories": @"["FOOD_BEVERAGE","FITNESS_RECREATION","SHOPPING_RETAIL"]",@"fields": @"name,about,id,location,context,engagement,checkins,picture,photos,cover",}
     HTTPMethod:@"GET"];
     [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
     // Insert your code here
     }];
     
     Android SDK version
 GraphRequest request = GraphRequest.newGraphPathRequest(
 accessToken,
 "/search",
 new GraphRequest.Callback() {
 @Override
 public void onCompleted(GraphResponse response) {
 // Insert your code here
 }
 });
 
 Bundle parameters = new Bundle();
 parameters.putString("type", "place");
 parameters.putString("center", "37.4816734,-122.1556204");
 parameters.putString("categories", "["FOOD_BEVERAGE","FITNESS_RECREATION","SHOPPING_RETAIL"]");
 parameters.putString("fields", "name,about,id,location,context,engagement,checkins,picture,photos,cover");
 request.setParameters(parameters);
 request.executeAsync();
 */
    
}

