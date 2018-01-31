//
//  RatingCell.swift
//  Event Management
//
//  Created by DMC1 on 20/01/18.
//  Copyright © 2018 cdac. All rights reserved.
//

import UIKit

class RatingCell: UITableViewCell {

    @IBOutlet weak var ratingBar: UISlider!
    @IBOutlet weak var ratingLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
