//
//  DetailOfDetailVC.swift
//  Event Management
//
//  Created by DMC1 on 28/12/17.
//  Copyright © 2017 cdac. All rights reserved.
//

import UIKit

class DetailOfDetailVC: UIViewController{
    
    var type = String()
    var aboutData  = String()
    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if type == "1"{
            nameLbl.text = "About"
        }
        else{
            aboutData = ""
            
        }
        
        //aboutData = "Event management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivalsEvent management is the application of project management to the creation and development of large scale events such as festivals"
        
        makeUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Programatically Making UI And assigning values and properties
    func makeUI(){
        //ScrollView
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.isPagingEnabled = true
        
        let font = UIFont(name: "Helvetica", size: 12)!
        let width = self.view.frame.width
        let height = heightForView(text: aboutData, font: font, width: width - 40)
        //View
        let subView = UIView()
        subView.frame = CGRect(x: 10, y: 10, width: width - 20 , height: height + 20)
        subView.backgroundColor = UIColor.white
        subView.layer.shadowColor = UIColor.lightGray.cgColor
        subView.layer.shadowRadius = 10
        subView.layer.shadowOpacity = 0.5
        subView.layer.shadowOffset = CGSize(width: 1, height: 1)
        subView.layer.masksToBounds = false
        
        //Label
        let dataLbl = UILabel()
        dataLbl.frame = CGRect(x: 10, y: 10, width: subView.frame.width - 20 , height: height)
        dataLbl.text = aboutData
        dataLbl.numberOfLines = 0
        dataLbl.font = font
        dataLbl.textColor = UIColor.black
        dataLbl.textAlignment = NSTextAlignment.justified
        //dataLbl.backgroundColor = UIColor.red
        
        //Setting Content Size
        scrollView.contentSize = CGSize(width: width, height: height + 110)
        
        //adding scrollView
        self.view.addSubview(scrollView)
        scrollView.addSubview(subView)
        subView.addSubview(dataLbl)
        
    }
    //To FInd Dynamic Height
    func heightForView(text:String,font:UIFont,width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    @IBAction func backBtn(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
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
