//
//  FilterViewController.swift
//  LookARound
//
//  Created by Siji Rachel Tom on 10/14/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import FacebookCore

protocol FilterViewControllerDelegate : NSObjectProtocol {
    func filterViewController(_filterViewController: FilterViewController, didSelectCategories categories: [FilterCategory])
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum SectionType : Int {
        case filters = 0
        case login
    }
    
    @IBOutlet weak var filterTableView: UITableView!
    weak var delegate : FilterViewControllerDelegate?
    var mapView: MapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        filterTableView.delegate = self
        filterTableView.dataSource = self        
        
        filterTableView.estimatedRowHeight = 100
        filterTableView.rowHeight = UITableViewAutomaticDimension
        
        filterTableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 1st section: filters
        // 2nd section: log in rows, if the user isn't already logged in
        var numSections = 1
        
        if AccessToken.current == nil {
            // User is not logged in
            numSections = 2
        }
        
        return numSections
    }
    
    func numRows(forSection section: SectionType) -> Int {
        switch section {
        case .filters:
            return FilterCategory.Categories_Total_Count.rawValue
        case .login:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows(forSection: SectionType(rawValue: section)!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell
        
        if (indexPath.section == SectionType.filters.rawValue) {
            cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
            (cell as! FilterCell).filterNameLabel.text = FilterCategoryDisplayString(category: FilterCategory(rawValue: indexPath.row)!)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "LoginCell", for: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == SectionType.filters.rawValue {
            let category = FilterCategory(rawValue: indexPath.row)!
            self.delegate?.filterViewController(_filterViewController: self,
                                                didSelectCategories: [category])
            dismiss(animated: true, completion: nil)
        } else {
            // Push login screen
            showLoginScreen()
        }
    }
    
    func showLoginScreen() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginViewController.mapView = mapView
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
