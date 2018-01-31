//
//  EventsVC.swift
//  Event Management
//
//  Created by DMC1 on 27/12/17.
//  Copyright © 2017 cdac. All rights reserved.
//

import UIKit

class EventsVC: UIViewController {
    
    @IBOutlet weak var eventWed: UIButton!
    
    var typeOfEvent = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    @IBAction func btnAction(_ sender: Any) {
        
        if (sender as AnyObject).tag == 1{
            typeOfEvent = "wedding"
        }else if (sender as AnyObject).tag == 2{
            typeOfEvent = "birthday"
        }else if (sender as AnyObject).tag == 3{
            typeOfEvent = "music concert"
        }else if (sender as AnyObject).tag == 4{
            typeOfEvent = "festival"
        }else if (sender as AnyObject).tag == 5{
            typeOfEvent = "conferences"
        }
        userdefault.setValue(typeOfEvent, forKey: "typeOfEvent")
        userdefault.synchronize()
        performSegue(withIdentifier: "gotoHome", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoHome"{
            _ = segue.destination as? HomeVC
            //destVC?.typeOfEvent = self.typeOfEvent
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
