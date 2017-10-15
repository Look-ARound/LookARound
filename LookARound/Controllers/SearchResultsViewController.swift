//
//  SearchResultsViewController.swift
//  LookARound
//
//  Created by Angela Yu on 10/13/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var places: [Place]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tableView = tableView else {
            print("no tableview yet")
            return
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        print("first place is \(places[0].name)")
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let places = places else {
            print("empty places")
            return 0
        }
        
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsCell", for: indexPath) as! SearchResultsCell
        
        if let places = places {
            cell.place = places[indexPath.row]
        }
        
        return cell
    }
}
