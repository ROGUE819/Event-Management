//
//  RegisterVC.swift
//  Event Management
//
//  Created by DMC1 on 27/12/17.
//  Copyright © 2017 cdac. All rights reserved.
//  Mohit

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class RegisterVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    var imageData:Data!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Image Picker Method and Button
    //This is image picker methods..
    @IBAction func addImageBtn(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //If user have picked image then getting that image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = pickedImage
            let data = UIImageJPEGRepresentation(pickedImage, 0.5)
            
            imageData = data
            
        }
        dismiss(animated: true, completion: nil)
    }
    //IF cancel pressed
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:-FIREBASE Method for Uploading image
    func uploadImageToFirebaseStorage(storageData:Data,imageName:String){
        let uploadRef = storageRef.child(imageName)
        
        let uploadTask = uploadRef.putData(storageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else{
                return
            }
            _ = metadata.downloadURL()
            print("THE UPLOAD IS SUCCESS")
            SVProgressHUD.dismiss()
            
            //print(downloadURL!)
        }
        //Progress Bar
        uploadTask.observe(.progress) { (snapshot) in
            guard let progress = snapshot.progress else{ return }
            print(progress.fractionCompleted)
        }
        
    }
    
    
    
    //MARK:- Registration Button
    @IBAction func registerAction(_ sender: Any) {
        
        if isInternetAvailable(){
            SVProgressHUD.show()
            
            //If All the text field are filled
            if usernameTF.text != "" && mobileTF.text != "" && emailTF.text != "" && passwordTF.text != ""{
                
                //Validating mobile and email
                let isEMail =  validateEmail(emailStr: emailTF.text!)
                let isMobile = valideMobile(mobileStr: mobileTF.text!)
                print(isMobile)
                
                if isEMail == true && isMobile == true{
                    
                    //TODO
                    //Code to check wheather number already exist or not
                    let userReg = ref.child("userRegistration").child(mobileTF.text!)
                    userReg.observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        //Error for already register.
                        if (snapshot.value as? NSDictionary) != nil{
                            self.makeTFEmpty()
                            self.alertBox(title: appMessages.Message_Title_Message, msg: appMessages.Number_Already_Register_Message)
                        }else{
                            //Register if number does not exit
                            var imageName:String = "profileImage/" + self.mobileTF.text! + ".jpg"
                            if self.imageData==nil{
                                imageName = ""
                            }
                            else{
                                self.uploadImageToFirebaseStorage(storageData: self.imageData, imageName: imageName)
                            }
                            
                            let key = self.mobileTF.text!
                            let data = ["userName":self.usernameTF.text!,"mobileNumber":self.mobileTF.text!,"email":self.emailTF.text!,"password":self.passwordTF.text!,"profileImage":imageName]
                            
                            
                            ref.child("userRegistration").child(key).setValue(data)
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
    
    
    //Validate Email
    func validateEmail(emailStr:String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    //Making all the text field empty
    func makeTFEmpty(){
        usernameTF.text = ""
        mobileTF.text = ""
        emailTF.text = ""
        passwordTF.text = ""
        profileImage.image = UIImage(named: "Background Image")
    }
    
    //Terms and Condition Action
    @IBAction func termsBtnAction(_ sender: Any) {
    }
    func goBack(){
        _ = navigationController?.popViewController(animated: true)
    }
    //Back Button Action
    @IBAction func backBtn(_ sender: Any) {
        goBack()
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
