//
//  DetailVC.swift
//  Event Management
//
//  Created by DMC1 on 28/12/17.
//  Copyright © 2017 cdac. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import Kingfisher
//import FirebaseStorageUI



class DetailVC: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var detailTV: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var eventId = String()
    var typeOfEvent = String()
    var eventData = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (userdefault.value(forKey: "eventId") != nil){
            eventId = userdefault.value(forKey: "eventId") as! String
        }
        self.getData()
        self.updateRating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func updateRating(){
        let dataRef = ref.child("listOfEvents").child(eventId)
        
        //dataRef.observeSingleEvent(of: .value, with: { (snapshot) in
        dataRef.observe(.value, with: { (snapshot) in
            if snapshot.value != nil{
                if let data = snapshot.value as? JSONStandard{
                    //code goes here
                    if let ratingIds = data["ratingIds"] as? JSONStandard{
                        var counter = 0
                        var avg = 0.0
                        print(ratingIds)
                        for (_,value) in ratingIds{
                            counter = counter + 1
                            let val = Double(value as! String)
                            avg = avg +  val!
                        }
                        
                        avg = avg / Double(counter)
                        let review = String(counter)
                        let rating = String(Float(avg))
                        dataRef.updateChildValues(["rating":rating,"review":review])
                        
                    }
                }
                else{
                    print("No data found")
                }
                
            }
            else{
                print("Error in fetching event detain in DeatilVC")
                SVProgressHUD.dismiss()
            }
        })
    }
    
    
    //Getting data from firebase for particular event
    func getData(){
        SVProgressHUD.show()
        let dataRef = ref.child("listOfEvents").child(eventId)
        
        dataRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value != nil{
                if let data = snapshot.value as? JSONStandard{
                    self.eventData.append(data)
                }
                print(self.eventData)
                let data = self.eventData[0] as! JSONStandard
                self.titleLbl.text = data["name"] as? String
                self.detailTV.delegate = self
                self.detailTV.dataSource = self
                self.detailTV.reloadData()
                SVProgressHUD.dismiss()
                
            }
            else{
                print("Error in fetching event detain in DeatilVC")
                SVProgressHUD.dismiss()
            }
        })
        
    }
    
    
    //MARK:- TableViews Methods
    //number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    //cellfor row at index ie., Table data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTV.dequeueReusableCell(withIdentifier: "detailVCCell", for: indexPath)
        cell.selectionStyle = .none
        
        let data = eventData[0] as! JSONStandard
        print(data)
        //Image
        if indexPath.row == 0{
            let imageView = UIImageView()
            imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
            
            
            let url = URL(string: data["companyPic"] as! String)
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "demoImage.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
            
            imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            imageView.contentMode = .scaleAspectFill
            cell.addSubview(imageView)
        }
        //About tab
        else if indexPath.row == 1{
            //background View
            let aboutView = UIView()
            aboutView.frame = CGRect(x: 5, y: 5, width: self.view.frame.width - 10, height: 90)
            aboutView.backgroundColor = UIColor.white
            aboutView.layer.shadowColor = UIColor.lightGray.cgColor
            aboutView.layer.shadowRadius = 10
            aboutView.layer.shadowOpacity = 0.5
            aboutView.layer.shadowOffset = CGSize(width: 1, height: 1)
            aboutView.layer.masksToBounds = false
            
            //about Label
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: self.view.frame.width - 20, height: 20))
            label.text = "About"
            label.font = UIFont(name: "Helvetica", size: 15)
            label.textColor = UIColor.black
            
            //Line View
            let lineView = UIView(frame: CGRect(x: 10, y: 20, width: self.view.frame.width - 30, height: 0.7))
            lineView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
            
            //about label Description
            let descLbl = UILabel(frame: CGRect(x: 10, y: 21, width: self.view.frame.width - 20 - 20, height: 69))
            descLbl.text = data["about"] as? String
            descLbl.textColor = UIColor.black.withAlphaComponent(0.7)
            descLbl.font = UIFont(name: "Helvetica", size: 12)
            descLbl.numberOfLines = 4
            descLbl.textAlignment = NSTextAlignment.justified
            
            //Arrow image
            let aImage = UIImageView(frame: CGRect(x: self.view.frame.width - 20, y: 40, width: 8, height: 13))
            aImage.image = UIImage(named: "Disclosure Indicator")
            
            //Adding SubView
            cell.addSubview(aboutView)
            aboutView.addSubview(label)
            aboutView.addSubview(lineView)
            aboutView.addSubview(descLbl)
            aboutView.addSubview(aImage)
        }
        //Image view (For template views)
        else if indexPath.row == 2{
            let templateIV = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
            //templateIV.image = UIImage(named: "demoImage.jpg")
            var urlString = ""
            let temp = data["templates"] as? JSONStandard
            if let type = temp?[typeOfEvent] as? JSONStandard{
                if let img = type["images"] as? JSONStandard{
                    urlString = img["image"] as! String
                }
            }
            
            
            let url = URL(string: urlString)
            templateIV.kf.setImage(with: url, placeholder: UIImage(named: "demoImage.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
            templateIV.contentMode = .scaleAspectFit
            cell.addSubview(templateIV)
        }
        //Rating bar
        else if indexPath.row == 3{
            
            var rVal = "0"
            
            if let ratingIds = data["ratingIds"] as? JSONStandard{
                let number = userdefault.value(forKey: "loginNumber") as! String
                if ratingIds[number] != nil{
                    rVal = ratingIds[number] as! String
                }
            }
            
            
            
            
            let ratingSlider = UISlider()
            ratingSlider.frame = CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: 20)
            ratingSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
            ratingSlider.minimumValue = Float(0)
            ratingSlider.maximumValue = Float(5)
            
            ratingSlider.value = Float(rVal)!
            cell.addSubview(ratingSlider)
            return cell
            
            
            
            
            
            //return ratingCell
            
            
            
        }
        return cell
    }
    //height of cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            return 150
        }
        else if indexPath.row == 1{
            return 100
        }
        else if indexPath.row == 2{
            return 200
        }
        else if indexPath.row == 3{
            return 50
            
        }
        return 100
    }
    
    //Selecting Table Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            
        }
        else if indexPath.row == 1{
            performSegue(withIdentifier: "gotoDetailDVC", sender: nil)
        }
        else if indexPath.row == 2{
            
        }
        else if indexPath.row == 3{
            
        }
    }
    
    
    func sliderChanged(_ sender: UISlider){
        let value = sender.value * 10.0
        let number = userdefault.value(forKey: "loginNumber") as! String
        let dataRef = ref.child("listOfEvents").child(eventId).child("ratingIds")//.child(number)
        
        
        //dataRef.setValue(["rating":value])
        let val = String(Float(value))
        dataRef.updateChildValues([number:val])
    }
    
    
    @IBAction func bookingAction(_ sender: Any) {
        performSegue(withIdentifier: "gotoBookingVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let data = eventData[0] as! JSONStandard
        if segue.identifier == "gotoDetailDVC" {
            let data = eventData[0] as! JSONStandard
            let destVC = segue.destination as! DetailOfDetailVC
            destVC.type = "1"
            destVC.aboutData = data["about"] as! String
        }
        
        if segue.identifier == "gotoBookingVC"{
            let destVC = segue.destination as! BookingVC
            destVC.eventId = data["eventId"] as! String
            destVC.typeOfEvent = self.typeOfEvent
        }
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
