//
//  FilterUtilities.swift
//  LookARound
//
//  Created by Siji Rachel Tom on 10/14/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

public enum FilterCategory : Int {
    case Food_Beverage
    case Fitness_Recreation
    case Arts_Entertainment
    case Categories_Total_Count // We use this enum's position to modify the list of filters in the Filters view.
    case Education
    case Hotel_Loding
    case Medical_Health
    case Shopping_Retail
    case Travel_Transportation
}

public func FilterCategoryDisplayString(category : FilterCategory) -> String {
    var categoryStr : String = ""
    
    switch category {
    case .Arts_Entertainment:
        categoryStr = "Arts & Entertainment"
    case .Education:
        categoryStr = "Education"
    case .Fitness_Recreation:
        categoryStr = "Fitness & Recreation"
    case .Food_Beverage:
        categoryStr = "Food & Beverage"
    case .Hotel_Loding:
        categoryStr = "Hotel & Lodging"
    case .Medical_Health:
        categoryStr = "Health"
    case .Shopping_Retail:
        categoryStr = "Retail"
    case .Travel_Transportation:
        categoryStr = "Travel & Transportation"
    case .Categories_Total_Count:
        break
    }
    
    return categoryStr
}

public func FilterCategorySearchString(category : FilterCategory) -> String {
    var categoryStr : String = ""
    
    switch category {
    case .Arts_Entertainment:
        categoryStr = "ARTS_ENTERTAINMENT"
    case .Education:
        categoryStr = "EDUCATION"
    case .Fitness_Recreation:
        categoryStr = "FITNESS_RECREATION"
    case .Food_Beverage:
        categoryStr = "FOOD_BEVERAGE"
    case .Hotel_Loding:
        categoryStr = "HOTEL_LODGING"
    case .Medical_Health:
        categoryStr = "MEDICAL_HEALTH"
    case .Shopping_Retail:
        categoryStr = "SHOPPING_RETAIL"
    case .Travel_Transportation:
        categoryStr = "TRAVEL_TRANSPORTATION"
    case .Categories_Total_Count:
        break
    }
    
    return categoryStr
}
