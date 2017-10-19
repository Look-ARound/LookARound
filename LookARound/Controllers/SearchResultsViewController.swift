//
//  SearchResultsViewController.swift
//  LookARound
//
//  Created by Angela Yu on 10/13/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource {
    @IBOutlet private var tableView: UITableView!
    
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
        
        let likeSortButton = UIBarButtonItem(title: "Visits", style: .plain, target: self, action: #selector(sortByCheckins))
        let friendsSortButton = UIBarButtonItem(title: "Friends", style: .plain, target: self, action: #selector(sortByFriends))
        navigationItem.rightBarButtonItems = [likeSortButton, friendsSortButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let tableView = tableView else {
            print("still no tableview yet")
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
    
    @objc private func sortByCheckins() {
        places = sortPlaces(places: places, by: .checkins)
        tableView.reloadData()
        let indexPath = NSIndexPath(row: 0, section: 0) as IndexPath
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @objc private func sortByFriends() {
        places = sortPlaces(places: places, by: .friends)
        tableView.reloadData()
        let indexPath = NSIndexPath(row: 0, section: 0) as IndexPath
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
