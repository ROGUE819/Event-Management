//
//  HomeVC.swift
//  Event Management
//
//  Created by DMC1 on 27/12/17.
//  Copyright © 2017 cdac. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class HomeVC: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var typeOfEvent = String() //To Get From list of event VC
    var homeData = [Any]()
    
    @IBOutlet weak var eventTypeLbl: UILabel!
    
    var pickerView = UIPickerView()
    var pickerBgView = UIView()
    var pickerViewElement = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        homeTableView.separatorStyle = .none
        
        pickerUI()
        typeOfEvent = userdefault.value(forKey: "typeOfEvent") as! String
        eventTypeLbl.text = typeOfEvent
        print("The Type Of Event is : " + typeOfEvent)
        if isInternetAvailable(){
            getData(filterEvent: typeOfEvent)
        }else{
            alertBox(title: appMessages.Error_Title_Message, msg: appMessages.No_Internet_Message)
        }
    }
    
    //MARK:- PIckerView UI And Setting
    func pickerUI(){
        pickerBgView.frame = CGRect(x: 0, y: self.view.frame.height - 150, width: self.view.frame.width, height: 150)
        pickerBgView.backgroundColor = myColor.lightGreypv
        
        let doneBtn = UIButton()
        doneBtn.frame = CGRect(x: self.view.frame.width - 70, y: 0, width: 70, height: 30)
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.addTarget(self, action: #selector(doneBtnAction(sender:)), for: .touchUpInside)
        doneBtn.setTitleColor(myColor.appColor, for: .normal)
        doneBtn.titleLabel?.textAlignment = .right
        
        pickerView.frame = CGRect(x: 0, y: 30, width: self.view.frame.width, height: 120)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerViewElement = ["none","wedding","birthday","music concert","conferences"]
        
        let lineView = UIView()
        lineView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1)
        lineView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        
        
        self.view.addSubview(pickerBgView)
        pickerBgView.addSubview(pickerView)
        pickerBgView.addSubview(doneBtn)
        //pickerBgView.addSubview(lineView)
        
        
        pickerBgView.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:- Getting data from firbase
    //Getting data from firebase
    func getData(filterEvent:String){
        SVProgressHUD.show()
        let refData = ref.child("listOfEvents")
        refData.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if (snapshot.value != nil) {
                if let data = snapshot.value as? JSONStandard{
                    //self.homeData = data
                    self.homeData.removeAll()
                    for (_,value) in data{
                        let val = value as! NSDictionary
                        if val[self.typeOfEvent] as? String == "on"{
                                self.homeData.append(val)
                        }
                        
                    }
                }
                print(self.homeData)
                self.homeTableView.delegate = self
                self.homeTableView.dataSource = self
                self.homeTableView.reloadData()
                SVProgressHUD.dismiss()
            }
            else{
                SVProgressHUD.dismiss()
                print("Error In Fetching Data from Firebase")
            }
            
        })
    }
    
    //MARK:- Alert , DoneButton , Filter Button
    @IBAction func filterActionBtn(_ sender: Any) {
        
        pickerView.reloadAllComponents()
        pickerBgView.isHidden = false
        
    }
    //Done Button Action Action
    func doneBtnAction(sender: UIButton!){
        pickerBgView.isHidden = true
        
        if isInternetAvailable(){
            if typeOfEvent == "none"{
                alertBox(title: appMessages.Error_Title_Message, msg: "Please select event.")
            }
            else{
                eventTypeLbl.text = typeOfEvent
                getData(filterEvent: typeOfEvent)
            }
            
        }else{
            alertBox(title: appMessages.Error_Title_Message, msg: appMessages.No_Internet_Message)
        }
        
    }
    
    //ALert box
    func alertBox(title:String,msg:String){
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func listOfBookedEvents(_ sender: Any) {
        performSegue(withIdentifier: "gotoBookedEvents", sender: nil)
    }
    
    
    
    
    //MARK:- Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoDetailVC"{
            let destVC = segue.destination as? DetailVC
            destVC?.typeOfEvent = self.typeOfEvent
        }
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

//MARK:- Extension For Table Views
extension HomeVC: UITableViewDelegate,UITableViewDataSource {
    //MARK:- Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if homeData.count == 0{
            return 1
        }
        return homeData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if homeData.count == 0{
            let cell = homeTableView.dequeueReusableCell(withIdentifier: "NoData", for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let errorLbl = UILabel()
            errorLbl.frame = CGRect(x: 20, y: self.view.frame.height / 2 - 10 - 64, width: self.view.frame.width - 40, height: 20)
            errorLbl.text = "No data found."
            errorLbl.textAlignment = .center
            errorLbl.textColor = myColor.lightGrey
            errorLbl.font = UIFont(name: fontName, size: 15)
            cell.addSubview(errorLbl)
            return cell
        }
        
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeVCCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        let data = homeData[indexPath.row] as! NSDictionary
        cell.titleLbl.text  = data["name"] as? String
        cell.aboutLbl.text  = data["about"] as? String
        cell.ratingLbl.text = (data["rating"] as? String)! + " Rating"
        cell.reviewLbl.text = (data["review"] as? String)! + " Reviews"
        let url = URL(string: data["companyPic"] as! String)
        cell.eventImage.kf.setImage(with: url, placeholder: UIImage(named: "demoImage.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if homeData.count == 0{
            return self.view.frame.height
        }
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dataDic = homeData[indexPath.row] as! JSONStandard
        //print(dataDic)
        let id = dataDic["eventId"] as! String
        //print(id!)
        userdefault.setValue(id, forKey: "eventId")
        userdefault.synchronize()
        
        performSegue(withIdentifier: "gotoDetailVC", sender: nil)
    }
}

//MARK:- Extension For Picker Views Methods

extension HomeVC: UIPickerViewDelegate,UIPickerViewDataSource{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerViewElement.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewElement[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerViewElement[row])
        typeOfEvent = pickerViewElement[row]
        userdefault.setValue(typeOfEvent, forKey: "typeOfEvent")
        userdefault.synchronize()
    }

}


