//
//  HomeVCModel.swift
//  Event Management
//
//  Created by DMC1 on 15/01/18.
//  Copyright © 2018 cdac. All rights reserved.
//

import Foundation

class HomeVCModel{

    private var title      :String
    private var about      :String
    private var rating     :String
    private var review     :String
    private var eventImage :String
    
    init(title:String,about:String,rating:String,review:String,eImage:String) {
        self.title      = title
        self.about      = about
        self.rating     = rating
        self.review     = review
        self.eventImage = eImage
    }
    
}
