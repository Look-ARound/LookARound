//
//  SearchResultsCell.swift
//  LookARound
//
//  Created by Angela Yu on 10/13/17.
//  Copyright © 2017 LookARound. All rights reserved.
//

import UIKit
import AFNetworking

class SearchResultsCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var contextLabel: UILabel!
    @IBOutlet weak var engagementLabel: UILabel!
    @IBOutlet weak var checkinsLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    var place: Place! {
        didSet {
            nameLabel.text = place.name
            aboutLabel.text = place.about
            contextLabel.text = place.context
            engagementLabel.text = place.engagement
            if let checkinCount = place.checkins {
                checkinsLabel.text = String(checkinCount)
            }

            if let urlString = place.thumbnail {
                if let url = URL(string: urlString) {
                    pictureImageView.setImageWith(url)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.LABrand.accent.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
