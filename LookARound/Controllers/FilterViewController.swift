//
//  FilterViewController.swift
//  LookARound
//
//  Created by Siji Rachel Tom on 10/14/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit

public enum FilterCategory : Int {
    case Arts_Entertainment = 0
    case Education
    case Fitness_Recreation
    case Food_Beverage
    case Hotel_Loding
    case Medical_Health
    case Shopping_Retail
    case Travel_Transportation
    case Categories_Total_Count
}

public func FilterCategoryString(category : FilterCategory) -> String {
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

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var filterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        filterTableView.delegate = self
        filterTableView.dataSource = self        
        
        filterTableView.estimatedRowHeight = 100
        filterTableView.rowHeight = UITableViewAutomaticDimension
        
        filterTableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterCategory.Categories_Total_Count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.filterNameLabel.text = FilterCategoryString(category: FilterCategory(rawValue: indexPath.row)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
