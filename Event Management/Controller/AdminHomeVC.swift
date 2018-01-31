//
//  AdminHomeVC.swift
//  Event Management
//
//  Created by DMC1 on 23/01/18.
//  Copyright © 2018 cdac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class AdminHomeVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate ,UITextFieldDelegate{

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var aboutTF: UITextField!
    
    
    @IBOutlet weak var bDanceTF: UITextField!
    @IBOutlet weak var bMusicTF: UITextField!
    @IBOutlet weak var bVegTF: UITextField!
    @IBOutlet weak var bNonvegTF: UITextField!
    @IBOutlet weak var bThemeTF: UITextField!
    
    @IBOutlet weak var wDanceTF: UITextField!
    @IBOutlet weak var wMusicTF: UITextField!
    @IBOutlet weak var wVegTF: UITextField!
    @IBOutlet weak var wNonvegTF: UITextField!
    @IBOutlet weak var wThemeTF: UITextField!
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    
    let imagePicker = UIImagePickerController()
    var imageData:Data!
    var myTag = String()
    
    var image1 = String()
    var image2 = String()
    var image3 = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        image1 = ""
        image2 = ""
        image3 = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Image Picker Method and Button
    
    @IBAction func uploadCompanyImage(_ sender: Any) {
        myTag = "1"
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadBday(_ sender: Any) {
        myTag = "2"
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func uploadWed(_ sender: Any) {
        myTag = "3"
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //If user have picked image then getting that image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            SVProgressHUD.show()
            //profileImage.image = pickedImage
            let data = UIImageJPEGRepresentation(pickedImage, 0.3)
            
            imageData = data
            
            var imageName = String()
            
            
            let key = ref.childByAutoId().key
            if myTag == "1"{
                imageName = "eventImage/" + "image\(key)" + ".jpg"
                image1 = imageName
                imageView1.kf.indicatorType = .activity
                imageView1.image = pickedImage
                //imageView1.kf.setImage(with: nil, placeholder:UIImage(named: "demoImage.jpg") , options: nil, progressBlock: nil, completionHandler: nil)
                
                
            }else if myTag == "2"{
                imageName = "eventImage/" + "image\(key)" + ".jpg"
                image2 = imageName
                imageView2.image = pickedImage
            }
            else if myTag == "3"{
                imageName = "eventImage/" + "image\(key)" + ".jpg"
                image3 = imageName
                imageView3.image = pickedImage
            }
            
            
            if self.imageData==nil{
                imageName = ""
            }
            else{
                self.uploadImageToFirebaseStorage(storageData: self.imageData, imageName: imageName)
            }
            
            
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
            let dowmloadURL = metadata.downloadURL()!
            print("THE UPLOAD IS SUCCESS")
            if self.myTag == "1"{
               
                self.image1 = "\(dowmloadURL)"
            }else if self.myTag == "2"{
               
                self.image2 = "\(dowmloadURL)"
            }
            else if self.myTag == "3"{
                
                self.image3 = "\(dowmloadURL)"
            }
            SVProgressHUD.dismiss()
            print("The URL IS")
            print(dowmloadURL)
        }
        //Progress Bar
        uploadTask.observe(.progress) { (snapshot) in
            guard let progress = snapshot.progress else{ return }
            print(progress.fractionCompleted)
        }
        
    }
    
    //MARK:- Save the data!
    @IBAction func saveData(_ sender: Any) {
        
        SVProgressHUD.show()

        let keys = ref.childByAutoId().key
        
        let dataREF = ref.child("listOfEvents").child(keys)
        
        
        
        
        let temp =
            ["birthday":[
                "dance":
                    ["name":"dance","price":self.bDanceTF.text!]
                ,
             
             "music":
                    ["name":"music","price":self.bMusicTF.text!]
                ,
                
                "veg":
                    ["name":"veg","price":self.bVegTF.text!]
                ,
                
                "nonVeg":
                ["name":"nonVeg","price":self.bNonvegTF.text!]
                ,
                
                "images":
                ["name":"Theme","price":self.bThemeTF.text!,"image":image2]
                
         ] , "wedding":[
                "dance":
                    ["name":"dance","price":self.wDanceTF.text!]
                ,
                
                "music":
                    ["name":"music","price":self.wMusicTF.text!]
                ,
                
                "veg":
                    ["name":"veg","price":self.wVegTF.text!]
                ,
                
                "nonVeg":
                    ["name":"nonVeg","price":self.wNonvegTF.text!]
                ,
                
                "images":
                    ["name":"Theme","price":self.wThemeTF.text!,"image":image3]
            
                ]
        ]
        
        let oNumber = userdefault.value(forKey: "adminLoginNumber") as! String
        let data = ["birthday":"on","wedding":"on","about":self.aboutTF.text!,"name":self.nameTF.text!,"datePosted":"","companyPic":"\(image1)","eventId":keys,"multiBooking":"yes","ownerNumber":oNumber,"rating":"0.0","review":"0","templates":temp] as JSONStandard
        
        dataREF.setValue(data)
        
        dismissSv()
        //var timer = Timer()
        
        //timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(dismissSv), userInfo: nil, repeats: false)
        
        
    }
    
    //MARK:- logout and Make Empty
    func dismissSv(){
        makeEmpty()
        SVProgressHUD.dismiss()
    }
    
    
    func makeEmpty(){
        
         nameTF.text    = ""
         aboutTF.text   = ""
        
         bDanceTF.text  = ""
         bMusicTF.text  = ""
         bVegTF.text    = ""
         bNonvegTF.text = ""
         bThemeTF.text  = ""
        
         wDanceTF.text  = ""
         wMusicTF.text  = ""
         wVegTF.text    = ""
         wNonvegTF.text = ""
         wThemeTF.text  = ""
        
         imageView1.image = UIImage(named: "")
         imageView2.image = UIImage(named: "")
         imageView3.image = UIImage(named: "")
    }
    
    @IBAction func logout(_ sender: Any) {
        //adminLogout
        let alert = UIAlertController(title: appMessages.Message_Title_Message, message: "Logout?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) {
            UIAlertAction in
            
            userdefault.setValue(nil, forKey: "isAdminLogin")
            userdefault.synchronize()
            self.performSegue(withIdentifier: "adminLogout", sender: nil)
            
            
        }
        alert.addAction(confirmAction)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
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

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
