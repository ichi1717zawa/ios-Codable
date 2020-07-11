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
  
        PhoneAuthProvider.provider().verifyPhoneNumber(mytextField.text!, uiDelegate: nil) { (verificationID, error) in
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
      let credential = PhoneAuthProvider.provider().credential(
      withVerificationID: verificationID,
      verificationCode: code.text!)
        print("credential\(credential)")
        Auth.auth().signIn(with: credential) { (user, error) in
            if let  error = error{
                print(error.localizedDescription)
            }
            print(user?.additionalUserInfo?.username)
            print(user?.additionalUserInfo?.providerID)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
