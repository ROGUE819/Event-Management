//
//  AdminLoginVC.swift
//  Event Management
//
//  Created by DMC1 on 23/01/18.
//  Copyright © 2018 cdac. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AdminLoginVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if isInternetAvailable(){
            SVProgressHUD.show()
            //Validate for empty
            if mobileTF.text != "" && passwordTF.text != ""{
                if valideMobile(mobileStr: mobileTF.text!) == true{
                    //To check user is register or not
                    let userReg = ref.child("adminRegistration").child(mobileTF.text!)
                    
                    userReg.observeSingleEvent(of: .value, with: { (snapshot) in
                        //checking if data is there or not
                        if let snap = snapshot.value as? NSDictionary{
                            let mobile = snap["mobileNumber"] as? String
                            let password = snap["password"] as? String
                            if  mobile == self.mobileTF.text && password == self.passwordTF.text{
                                
                                userdefault.setValue(mobile, forKey: "adminLoginNumber")
                                userdefault.setValue("true", forKey: "isAdminLogin")
                                userdefault.synchronize()
                                self.performSegue(withIdentifier: "gotoAdminHome", sender: nil)
                                self.emptyTF()
                                SVProgressHUD.dismiss()
                            }
                            else{
                                
                                self.alertBox(title: appMessages.Error_Title_Message, msg: appMessages.Mobile_Password_Error_Message)
                            }
                        }else{
                            
                            self.alertBox(title: appMessages.Error_Title_Message, msg: appMessages.Number_NotRegister_Message)
                        }
                    })
                }
                else{
                    //error for mobile
                    
                    alertBox(title: appMessages.Error_Title_Message, msg: appMessages.Mobile_Error_Message)
                }
            }
            else{
                //Error
                
                alertBox(title: appMessages.Error_Title_Message, msg: appMessages.Empty_Field_Message)
            }
        }
        else{
            alertBox(title: appMessages.Error_Title_Message, msg: appMessages.No_Internet_Message)
        }
        
        
    }
    
    //Empty text field
    func emptyTF(){
        mobileTF.text = ""
        passwordTF.text = ""
    }
    
    //ALert box
    func alertBox(title:String,msg:String){
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func register(_ sender: Any) {
        performSegue(withIdentifier: "gotoAdminReg", sender: nil)
    }
    //For Text Field .... Action for return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    //When touch outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
