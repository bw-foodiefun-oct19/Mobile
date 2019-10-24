//
//  ExperienceTableViewCell.swift
//  FoodieFun
//
//  Created by John Kouris on 10/23/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class ExperienceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var dateVisitedLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var itemNameLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    var experience: Experience? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        restaurantName.text = experience?.restaurantName
        dateFormatter.dateFormat = "MM-dd-yyy"
        itemNameLabel.text = experience?.itemName
        let dateVisited = dateFormatter.string(from: experience?.dateVisited ?? Date())
        dateVisitedLabel.text = dateVisited
        self
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
