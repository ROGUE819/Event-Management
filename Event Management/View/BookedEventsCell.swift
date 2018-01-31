//
//  BookedEventsCell.swift
//  Event Management
//
//  Created by DMC1 on 24/01/18.
//  Copyright © 2018 cdac. All rights reserved.
//

import UIKit

class BookedEventsCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
  
    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var ownerNumber: UILabel!
    @IBOutlet weak var danceCell: UILabel!
    @IBOutlet weak var musicCell: UILabel!
    @IBOutlet weak var vegCell: UILabel!
    @IBOutlet weak var nonVegCell: UILabel!
    @IBOutlet weak var themeCell: UILabel!
    @IBOutlet weak var totalCost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = 0.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
