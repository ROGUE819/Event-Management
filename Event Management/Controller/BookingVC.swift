//
//  BookingVC.swift
//  Event Management
//
//  Created by DMC1 on 18/01/18.
//  Copyright © 2018 cdac. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class BookingVC: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBOutlet weak var bookingTV: UITableView!
    
    
    var eventDate = String()
    var eventId = String()
    var typeOfEvent = String()
    var count = Int()
    
    var eventData = [Any]()
    
    var total = Int()
    
    var totalVeg = Int()
    var totalNonVeg = Int()
    var totalMusic = Int()
    var totalDance = Int()
    var totalTheme = Int()
    
    var qtyVeg = Int()
    var qtyNonVeg = Int()
    var qtyMusic = Int()
    var qtyDance = Int()
    var qtyTheme = Int()
    
    var priceVeg = Int()
    var priceNonVeg = Int()
    var priceMusic = Int()
    var priceDance = Int()
    var priceTheme = Int()
    
    var isMusic: Bool = true
    var isDance: Bool = true
    var isVeg: Bool = true
    var isNonVeg: Bool = true
    var isTheme: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date:NSDate = NSDate()
        datePicker.minimumDate = date as Date
        datePicker.addTarget(self, action: #selector(datePickerValue(_sender:)), for: .valueChanged)
        datePicker.layer.borderWidth = 0.6
        datePicker.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        datePicker.layer.masksToBounds = false
        // Do any additional setup after loading the view.
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Getting data from firebase
    func getData(){
        SVProgressHUD.show()
        
        let dataRef = ref.child("listOfEvents").child(eventId).child("templates").child(typeOfEvent)
        
        dataRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value != nil{
                if let snap = snapshot.value as? JSONStandard{
                    self.eventData.append(snap)
                    self.count = 0
                    for (_ , _) in snap{
                        self.count = self.count + 1
                    }
                    
                    
                    print(self.eventData)
                    self.bookingTV.delegate = self
                    self.bookingTV.dataSource = self
                    self.bookingTV.reloadData()
                    SVProgressHUD.dismiss()
                }
            }
            else{
                //No Data Found Alert
                SVProgressHUD.dismiss()
            }
        })
        
    }
    
    //Events Picker
    func datePickerValue( _sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        eventDate = dateFormatter.string(from: datePicker.date)
        
    
    }
    
    //MARK:- Save Booking
    
    func saveBooking(){
        
        if isInternetAvailable(){
            let numRef = ref.child("listOfEvents").child(eventId).child("ownerNumber")
            numRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                var num = ""//String(describing: snapshot.value as! NSNumber)
                if num.isEmpty{
                    num = ""
                }
                    
                let loginNumber = userdefault.value(forKey: "loginNumber") as! String
                let dataRef = ref.child("bookings").child(loginNumber).child(self.eventId)
                    
                let data = ["customerNumber":loginNumber,"dance":"\(self.qtyDance)","eventId":self.eventId,"eventType":self.typeOfEvent,"music":"\(self.qtyMusic)","veg":"\(self.qtyVeg)","nonVeg":"\(self.qtyNonVeg)","ownerNumber":num,"totalCost":"\(self.total)","eventDateAndTime":self.eventDate,"theme": "\(self.qtyTheme)"]
                    
                dataRef.setValue(data)
                    
                SVProgressHUD.dismiss()
                self.bookingDoneAlert()
                
                
            })
        }
        else{
            self.alertBox(title: appMessages.Error_Title_Message, msg: appMessages.No_Internet_Message)
        }
        
        
    }
    
    func alertBox(title:String,msg:String){
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //MARK:- Booking
    @IBAction func confirmBooking(_ sender: Any) {
        
        let alert = UIAlertController(title: appMessages.Message_Title_Message, message: "Are you sure, you want to confirm your booking ?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            SVProgressHUD.show()
            self.saveBooking()
            
            
        }
        alert.addAction(confirmAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func bookingDoneAlert(){
        let alert = UIAlertController(title: appMessages.Message_Title_Message, message: "Booking done.!", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            self.goBack()
        }
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    func goBack(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    //Switch method
    func switchValueDidChange(_ sender: UISwitch) {
        if sender.tag == 1{
            if (sender.isOn == true){
                isMusic = true
                totalCost.text = String(total + totalMusic)
                total = total + totalMusic
            }
            else{
                isMusic = false
                totalCost.text = String(total - totalMusic)
                total = total - totalMusic
                totalMusic = 0
            }
        }else if sender.tag == 2{
            if (sender.isOn == true){
                isDance = true
                totalCost.text = String(total + totalDance)
                total = total + totalDance
                
            }
            else{
                isDance = false
                totalCost.text = String(total - totalDance)
                total = total - totalDance
                totalDance = 0
            }
        }else if sender.tag == 3{
            if (sender.isOn == true){
                isVeg = true
                totalCost.text = String(total + totalVeg)
                total = total + totalVeg

            }
            else{
                isVeg = false
                totalCost.text = String(total - totalVeg)
                total = total - totalVeg
                totalVeg = 0

            }
        }else if sender.tag == 4{
            if (sender.isOn == true){
                isNonVeg = true
                totalCost.text = String(total + totalNonVeg)
                total = total + totalNonVeg
            }
            else{
                isNonVeg = false
                totalCost.text = String(total - totalNonVeg)
                total = total - totalNonVeg
                totalNonVeg = 0
            }
        }else if sender.tag == 5{
            if (sender.isOn == true){
                isTheme = true
                totalCost.text = String(total + totalTheme)
                total = total + totalTheme
            }
            else{
                isTheme = false
                totalCost.text = String(total - totalTheme)
                total = total - totalTheme
                totalTheme = 0
            }
        }
        bookingTV.reloadData()
    }
    
    //textfield methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let str = "Rs "
        
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if text != ""{
            if textField.tag == 1{
                qtyMusic = Int(text!)!
                totalMusic = priceMusic * qtyMusic
                //total = total + totalMusic
            }
            else if textField.tag == 2{
                qtyDance = Int(text!)!
                totalDance = priceDance * qtyDance
                //total = total + totalDance
            }
            else if textField.tag == 3{
                qtyVeg = Int(text!)!
                totalVeg = priceVeg * qtyVeg
                //total = total + totalVeg
            }
            else if textField.tag == 4{
                qtyNonVeg = Int(text!)!
                totalNonVeg = priceNonVeg * qtyNonVeg
                //total = total + totalNonVeg
            }
            else if textField.tag == 5{
                qtyTheme = Int(text!)!
                totalTheme = priceTheme * qtyTheme
                //total = total + totalTheme
            }
            
            bookingTV.reloadData()
            
            total = totalMusic + totalDance + totalVeg + totalNonVeg + totalTheme
            totalCost.text = str +  String(total)
        }
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    

    @IBAction func backBtn(_ sender: Any) {
        self.goBack()
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


extension BookingVC:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bookingTV.dequeueReusableCell(withIdentifier: "bookingCell", for: indexPath) as! BookingVCCell
        cell.selectionStyle = .none
        let data = eventData[0] as! JSONStandard
        
        cell.qtyTF.tag = indexPath.row + 1
        cell.switchEnable.tag = indexPath.row + 1
        
        cell.switchEnable.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        
        let str1 = " X "
        let eq = " = "
        
        if indexPath.row == 0{
            let eventD = data["music"] as! JSONStandard
            cell.titleLbl.text = (eventD["name"] as? String)?.capitalized
            
            if isMusic{
                cell.qtyTF.isUserInteractionEnabled = true
            }else{
                cell.qtyTF.isUserInteractionEnabled = false
                cell.qtyTF.text = ""
            }
            
            priceMusic = Int((eventD["price"] as? String)!)!
            
            if qtyMusic > 0{
                //totalMusic = priceMusic * qtyMusic
                cell.calcLbl.text =  str1 + String(priceMusic) + eq + String(totalMusic)
            }else{
                cell.calcLbl.text = str1 + "0 = 0"
            }
            return cell
        }
        if indexPath.row == 1{
            
            let eventD = data["dance"] as! JSONStandard
            
            print(eventD)
            
        
            cell.titleLbl.text = (eventD["name"] as? String)?.capitalized
            
            if isDance{
                cell.qtyTF.isUserInteractionEnabled = true
            }else{
                cell.qtyTF.isUserInteractionEnabled = false
                cell.qtyTF.text = ""
            }
            
            priceDance = Int((eventD["price"] as? String)!)!
            print(priceDance)
            if qtyDance > 0{
//                totalDance = priceDance * qtyDance
                cell.calcLbl.text =  str1 + String(priceDance) + eq + String(totalDance)
            }else{
                cell.calcLbl.text = str1 + "0 = 0"
            }
            
            return cell
        }
        if indexPath.row == 2{
            let eventD = data["veg"] as! JSONStandard
            
            cell.titleLbl.text = (eventD["name"] as? String)?.capitalized
            
            
            if isVeg{
                cell.qtyTF.isUserInteractionEnabled = true
            }else{
                cell.qtyTF.isUserInteractionEnabled = false
                cell.qtyTF.text = ""
            }
            priceVeg = Int((eventD["price"] as? String)!)!
            
            if qtyVeg > 0{
//                totalVeg = priceVeg * qtyVeg
                cell.calcLbl.text =  str1 + String(priceVeg) + eq + String(totalVeg)
            }else{
                cell.calcLbl.text = str1 + "0 = 0"
            }
            
            return cell
        }
        if indexPath.row == 3{
            let eventD = data["nonVeg"] as! JSONStandard
            cell.titleLbl.text = (eventD["name"] as? String)?.capitalized
            
            if isNonVeg{
                cell.qtyTF.isUserInteractionEnabled = true
            }else{
                cell.qtyTF.isUserInteractionEnabled = false
                cell.qtyTF.text = ""
            }
            
            priceNonVeg = Int((eventD["price"] as? String)!)!
            
            if qtyMusic > 0{
//                totalNonVeg = priceNonVeg * qtyNonVeg
                cell.calcLbl.text =  str1 + String(priceNonVeg) + eq + String(totalNonVeg)
            }else{
                cell.calcLbl.text = str1 + "0 = 0"
            }
            return cell
            
        }
        if indexPath.row == 4 {
            let eventD = data["images"] as! JSONStandard
            cell.titleLbl.text = (eventD["name"] as? String)?.capitalized
            
            if isTheme{
                cell.qtyTF.isUserInteractionEnabled = true
            }else{
                cell.qtyTF.isUserInteractionEnabled = false
                cell.qtyTF.text = ""
            }
            
            priceTheme = Int((eventD["price"] as? String)!)!
            
            if qtyMusic > 0{
//                totalTheme = priceTheme * qtyTheme
                cell.calcLbl.text =  str1 + String(priceTheme) + eq + String(totalTheme)
            }else{
                cell.calcLbl.text = str1 + "0 = 0"
            }
            return cell
        }
        
        return cell
        
    }

}
