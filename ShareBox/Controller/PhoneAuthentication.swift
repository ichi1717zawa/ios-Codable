//
//  PhoneAuthentication.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/7/11.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import FirebaseAuth
class PhoneAuthentication: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var code: UITextField!
    @IBOutlet weak var mytextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()  
        code.delegate = self
        mytextField.delegate = self
        print(Auth.auth().currentUser?.phoneNumber)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
              return true
    }
    
    @IBAction func send(_ sender: Any) {
        PhoneAuthProvider.provider().verifyPhoneNumber("+886\(mytextField.text!)", uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            print("error\(error.localizedDescription)")
            return
          }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            print("login")
          // Sign in using the verificationID and the code sent to the user
          // ...
        }
    }

    @IBAction func 登入(_ sender: Any) {
        
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")!
//        let prefs = UserDefaults.standard
//        let keyValue = prefs.string(forKey:"authVerificationID")
//        prefs.removeObject(forKey:"authVerificationID")
        UserDefaults.standard.removeObject(forKey: "authVerificationID")
        
        print(verificationID)
      let credential = PhoneAuthProvider.provider().credential(
      withVerificationID: verificationID,
      verificationCode: code.text!)
        print("credential\(credential)")
      
       
         
        print(verificationID)
          // Sign in using the verificationID and the code sent to the user
          // ...
        
//        Auth.auth().signIn(with: credential) { (user, error) in
//            if let  error = error{
//                print(error.localizedDescription)
//            }
//
//
//             print("登入後的帳號\(Auth.auth().currentUser?.uid)")
//        }
    }
 //eRBOqZDgxEn7mD1o4ImD-_:APA91bGMd8HjApnsOHhOaQXThPCXTlkGEv4e_YRg_OihYwyMski0BekqY0zuL-BiYPDGLB-zISUQ-9dqVCMUN8kIR2POqBhYNzaSPy60pejZSU6pR2gc8uRxyTQJA3KmxoVpdRuhmz7o
    
    //
    @IBAction func pushnotificationAciton(_ sender: Any) {
        PushNotificationSender().sendPushNotification(to: "eRBOqZDgxEn7mD1o4ImD-_:APA91bGMd8HjApnsOHhOaQXThPCXTlkGEv4e_YRg_OihYwyMski0BekqY0zuL-BiYPDGLB-zISUQ-9dqVCMUN8kIR2POqBhYNzaSPy60pejZSU6pR2gc8uRxyTQJA3KmxoVpdRuhmz7o", title: "蘇蘇", body: "您好,請問商品現在還在嗎？", badgeValue: 0)
    }
    
}

