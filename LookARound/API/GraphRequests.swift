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

struct PlaceSearch {
    func fetchPlaces(with categories:[FilterCategory], success: @escaping ([Place]?)->(), failure: @escaping (Error)->()) -> Void {
        var request = PlaceSearchRequest()
        request.graphPath = graphPathString(categories: categories)
        
        let searchConnection = GraphRequestConnection()
        searchConnection.add(request) { (response, result: GraphRequestResult) in
            switch result {
            case .success(let response):
                success(response.places)
            case .failed(let error):
                failure(error)
            }
        }
        searchConnection.start()
    }
}

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

func graphPathString(categories : [FilterCategory]) -> String {
    var categoriesStr = ""
    for category in categories {
        categoriesStr += "%22\(FilterCategorySearchString(category: category))%22,"
    }
    let graphPath = "/search?type=place&center=37.4816734,-122.1556204&categories=[" + categoriesStr + "]"
    
    return graphPath
}

struct PlaceSearchRequest: GraphRequestProtocol {
    
    /* API response for Angela Yu searching at Builing 20:
     use JSON viewer to collapse and expand tree here https://codebeautify.org/jsonviewer/cb147a70
     */
    var graphPath = graphPathString(categories: [FilterCategory.Food_Beverage, FilterCategory.Fitness_Recreation])
    var parameters: [String: Any]? = ["fields": "name, about, id, location, context, engagement, checkins, picture, cover"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
    
    typealias Response = PlaceSearchResponse
}

struct PlaceSearchResponse: GraphResponseProtocol {
    var places: [Place]
    
    init(rawResponse: Any?) {
        // Decode JSON from rawResponse into other properties here.
        let json = JSON(rawResponse!)
        // print(json)
        places = []
        for spot in json["data"].arrayValue {
            let placeID = spot["id"].intValue
            let placeName = spot["name"].stringValue
            let placeLat = spot["location"]["latitude"].double
            let placeLon = spot["location"]["longitude"].double
            let coordinates = CLLocationCoordinate2D(latitude: placeLat!, longitude: placeLon!)
            let placeAddr = spot["location"]["street"].stringValue
            
            let thisPlace = Place(id: Int64(placeID), name: placeName, location: coordinates, address: placeAddr)
            
            thisPlace.about = spot["about"].stringValue
            thisPlace.picture = spot["picture"]["data"]["url"].stringValue
            thisPlace.context = spot["context"]["friends_who_like"]["summary"]["social_sentence"].stringValue
            thisPlace.checkins = spot["checkins"].intValue
            places.append(thisPlace)
        }
    }
}
    
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

