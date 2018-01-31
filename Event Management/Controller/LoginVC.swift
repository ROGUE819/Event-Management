//
//  LoginVC.swift
//  Event Management
//
//  Created by DMC1 on 26/12/17.
//  Copyright © 2017 cdac. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var adminLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isInternetAvailable(){
            print("Ooooo Yeh")
        }
        else{
            print("Shit")
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Action For login Button
    @IBAction func loginAction(_ sender: Any) {
        
        if isInternetAvailable(){
            SVProgressHUD.show()
            //Validate for empty
            if mobileTF.text != "" && passwordTF.text != ""{
                if valideMobile(mobileStr: mobileTF.text!) == true{
                    //To check user is register or not
                    let userReg = ref.child("userRegistration").child(mobileTF.text!)
                    
                    userReg.observeSingleEvent(of: .value, with: { (snapshot) in
                        //checking if data is there or not
                        if let snap = snapshot.value as? NSDictionary{
                            let mobile = snap["mobileNumber"] as? String
                            let password = snap["password"] as? String
                            if  mobile == self.mobileTF.text && password == self.passwordTF.text{
                                
                                userdefault.setValue(mobile, forKey: "loginNumber")
                                
                                userdefault.setValue("true", forKey: "isLogin")
                                userdefault.synchronize()
                                self.performSegue(withIdentifier: "gotoEvents", sender: nil)
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
    
    
    //Action For Registration Button
    @IBAction func registerAction(_ sender: Any) {
        performSegue(withIdentifier: "gotoRegister", sender: nil)
    }
    
    @IBAction func adminLoginAction(_ sender: Any) {
        performSegue(withIdentifier: "gotoAdminLogin", sender: nil)
    }
    
    
    //Action For Organization Button
    @IBAction func organizationLoginAction(_ sender: Any) {
        
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
