//
//  BookingVCCell.swift
//  Event Management
//
//  Created by DMC1 on 20/01/18.
//  Copyright © 2018 cdac. All rights reserved.
//

import UIKit

class BookingVCCell: UITableViewCell {
    
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var switchEnable: UISwitch!
    @IBOutlet weak var qtyTF: UITextField!
    @IBOutlet weak var calcLbl: UILabel!
    
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
