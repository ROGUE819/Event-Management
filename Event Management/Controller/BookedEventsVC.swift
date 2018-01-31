//
//  BookedEventsVC.swift
//  Event Management
//
//  Created by DMC1 on 24/01/18.
//  Copyright © 2018 cdac. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class BookedEventsVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var bookedEventsTV: UITableView!
    
    var eventList = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(){
        SVProgressHUD.show()
        let number = userdefault.value(forKey:"loginNumber") as? String
        
        let dataREF = ref.child("bookings").child(number!)
        dataREF.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value != nil{
                
                if let data = snapshot.value as? JSONStandard{
                    for (_ ,val) in data{
                        self.eventList.append(val)
                    }
                    print(self.eventList)
                }
                SVProgressHUD.dismiss()
                self.bookedEventsTV.delegate = self
                self.bookedEventsTV.dataSource = self
                self.bookedEventsTV.reloadData()
            }
            else{
                //error
            }
        })
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventList.count == 0{
            return 1
        }else{
            return eventList.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if eventList.count == 0{
            let cell = bookedEventsTV.dequeueReusableCell(withIdentifier: "NoData", for: indexPath)
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
        else{
            let cell = bookedEventsTV.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BookedEventsCell
            
            let data = eventList[indexPath.row] as? JSONStandard
            
            cell.eventType.text = data!["eventType"] as? String
            cell.dateAndTime.text = data!["eventDateAndTime"] as? String
            cell.ownerNumber.text = data!["ownerNumber"] as? String
            let dance = data!["dance"] as? String
            cell.danceCell.text =  "Dance: " + dance!
            
            let music = data!["music"] as? String
            cell.musicCell.text = "Music: " + music!
            
            let veg = data!["veg"] as? String
            cell.vegCell.text = "Veg: " + veg!
            
            let nonVeg = data!["nonVeg"] as? String
            cell.nonVegCell.text = "NonVeg: " + nonVeg!
            
            let theme = data!["theme"] as? String
            cell.themeCell.text = "Theme: " + theme!
            
            let cost = data!["totalCost"] as? String
            cell.totalCost.text = "Total cost: " + cost!
            
            return cell
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if eventList.count == 0{
            return self.view.frame.height
        }
        return 175
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
