////
////  FirstLoginInit.swift
////  ShareBox
////
////  Created by 廖逸澤 on 2020/5/27.
////  Copyright © 2020 廖逸澤. All rights reserved.
////
//
//import UIKit
//import Firebase
//import GoogleSignIn
//class FirstLoginInit: UIViewController ,UITextFieldDelegate {
//
//    var db = Firestore.firestore()
//    @IBOutlet weak var NickNametextField: UITextField!
//    @IBOutlet weak var LocationtextField: UITextField!
//    @IBOutlet weak var phoneNumberTextField: UITextField!
//    var share = CoredataShare.share
//    var nickName : [String:Any] = [:]
//    var userLocation : [String:Any] = [:]
//    var phoneNumber : [String:Any] = [:]
//    var googleGmail : [String:Any] = [:]
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        NickNametextField.delegate = self
////        LocationtextField.delegate = self
//        phoneNumberTextField.delegate = self
//        
//    }
//    
//
// 
//    @IBAction func done(_ sender: Any) {
// 
//        let information = UserInfomation(context: share.myContext)
//        information.nickname = NickNametextField.text ?? "N/A"
////        information.userLocation = LocationtextField.text ?? "N/A"
//        information.phoneNumber = phoneNumberTextField.text ?? "N/A"
//        share.saveData()
//        self.navigationController?.popViewController(animated: true)
////        nickName = ["nickName":information.nickname]
////        userLocation = ["userLocation":information.userLocation]
////        phoneNumber = ["phoneNumber":information.phoneNumber]
////        googleGmail = ["googleGmail":Auth.auth().currentUser!.email as Any]
//        FirebaseCreateUserInformation(nickName: information.nickname, userLocation: information.userLocation, phoneNumber: information.phoneNumber, googleGmail: Auth.auth().currentUser?.email ?? "NoEmail")
//    }
//    
//    
//    func FirebaseCreateUserInformation(nickName : String , userLocation:String , phoneNumber:String , googleGmail:String){
//        
//        self.db.collection("user").document("\(GIDSignIn.sharedInstance()!.currentUser!.profile.name!)").setData(
//                    ["nickName":nickName,
//                    "phoneNumber":phoneNumber,
//                    "Gmail":googleGmail]
//                        ) { (error) in  }
//        
//        }
//    
//    
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    
//}
