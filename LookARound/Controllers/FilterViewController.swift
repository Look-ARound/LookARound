//
//  FilterViewController.swift
//  LookARound
//
//  Created by Siji Rachel Tom on 10/14/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate : NSObjectProtocol {
    func filterViewController(_filterViewController: FilterViewController, didSelectCategories categories: [FilterCategory])
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var filterTableView: UITableView!
    weak var delegate : FilterViewControllerDelegate?
    
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
        cell.filterNameLabel.text = FilterCategoryDisplayString(category: FilterCategory(rawValue: indexPath.row)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let category = FilterCategory(rawValue: indexPath.row)!
        self.delegate?.filterViewController(_filterViewController: self,
                                            didSelectCategories: [category])
        
        dismiss(animated: true, completion: nil)
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
