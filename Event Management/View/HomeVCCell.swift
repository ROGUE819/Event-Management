//
//  HomeVCCell.swift
//  Event Management
//
//  Created by DMC1 on 27/12/17.
//  Copyright © 2017 cdac. All rights reserved.
//

import UIKit

class HomeVCCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var reviewLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = 0.5
        
        eventImage.layer.cornerRadius = self.eventImage.frame.width / 2
        eventImage.layer.masksToBounds = true
        eventImage.backgroundColor = myColor.lightGreypv
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
