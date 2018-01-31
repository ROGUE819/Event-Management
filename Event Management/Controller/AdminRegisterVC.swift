//
//  AdminRegisterVC.swift
//  Event Management
//
//  Created by DMC1 on 24/01/18.
//  Copyright © 2018 cdac. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AdminRegisterVC: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
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
    
    //Making all the text field empty
    func makeTFEmpty(){
        nameTF.text = ""
        emailTF.text = ""
        mobileTF.text = ""
        passwordTF.text = ""
        
    }
   
    @IBAction func registerBtn(_ sender: Any) {
        if isInternetAvailable(){
            SVProgressHUD.show()
            
            //If All the text field are filled
            if nameTF.text != "" && emailTF.text != "" && mobileTF.text != "" && passwordTF.text != ""{
                
                //Validating mobile and email
                let isEMail =  validateEmail(emailStr: emailTF.text!)
                let isMobile = valideMobile(mobileStr: mobileTF.text!)
                print(isMobile)
                
                if isEMail == true && isMobile == true{
                    
                    //TODO
                    //Code to check wheather number already exist or not
                    let userReg = ref.child("adminRegistration").child(mobileTF.text!)
                    userReg.observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        //Error for already register.
                        if (snapshot.value as? NSDictionary) != nil{
                            self.makeTFEmpty()
                            self.alertBox(title: appMessages.Message_Title_Message, msg: appMessages.Number_Already_Register_Message)
                        }else{
                            
                            let key = self.mobileTF.text!
                            let data = ["userName":self.nameTF.text!,"mobileNumber":self.mobileTF.text!,"email":self.emailTF.text!,"password":self.passwordTF.text!]
                            
                            
                            ref.child("adminRegistration").child(key).setValue(data)
                            self.makeTFEmpty()
                            self.alertBox(title: appMessages.Message_Title_Message, msg: appMessages.Success_Registration_Message)
                            self.goBack()
                        }
                        
                    })
                }
                else{
                    if isEMail == false && isMobile == true{
                        //Invalid Email Error
                        alertBox(title: appMessages.Error_Title_Message, msg: appMessages.Email_Error_Message)
                    }
                    else if isEMail == true && isMobile == false{
                        //Invalid Mobile Error
                        alertBox(title: appMessages.Error_Title_Message, msg: appMessages.Mobile_Error_Message)
                    }
                    else if isEMail == false && isMobile == false{
                        //Invalid Email and Mobile Error
                        alertBox(title: appMessages.Error_Title_Message, msg: appMessages.Email_And_Mobile_Error_Message)
                    }
                }
            }
            else{
                //ALert that the field are empty
                alertBox(title: appMessages.Error_Title_Message, msg: appMessages.Empty_Field_Message)
            }
        }
        else{
            alertBox(title: appMessages.Error_Title_Message, msg: appMessages.No_Internet_Message)
        }
    }
    
    //MARK:- Alert , Validate , Textfield functions
    func alertBox(title:String,msg:String){
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

    
    
    func goBack(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        goBack()
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
