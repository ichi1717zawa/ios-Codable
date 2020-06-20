//
//  ChoseAction.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/24.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import CoreData
import CoreLocation

class ChoseAction: UIViewController ,GIDSignInDelegate, CLLocationManagerDelegate  {
    @IBOutlet weak var maskview: UIView!
    
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.maskview.alpha = 0
                               self.activeIndicator.stopAnimating()
        
    }

    let db = Firestore.firestore()
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{print("登入錯誤\(error)"); return  }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
             Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error { print("\(error)");  return }
                guard let authResultEmail = authResult?.user.email else {return}
//                let authResultEmail = "qweqwe"
                print(authResult?.user.email)

                self.db.collection("user").whereField("Gmail", isEqualTo: authResultEmail).getDocuments { (data, error) in
                    if   data?.isEmpty == true {
//                        self.performSegue(withIdentifier: "FirstLoginSegue", sender: nil)
//                        self.maskview.alpha = 0
                        self.FirstSignUp()
                        print("Not In database")
                    }else{
                        print(Auth.auth().currentUser?.uid)
                         self.performSegue(withIdentifier: "tabSegue", sender: nil)
                        print("user IN database")
                    }

                        for i in data!.documents{
                            print(i.data()["nickName"])
                        }
                    }
//                if CoredataShare.share.myContextCount() == 0{
//                    self.performSegue(withIdentifier: "FirstLoginSegue", sender: nil)
//                    self.navigationController?.navigationBar.alpha = 0
//                }

                 print("身份驗證完成")
//                    ChatList.share.loginCall()
             }
                 Auth.auth().addStateDidChangeListener { (auth, user) in
                    if auth.currentUser == nil{
                         print("登出完畢")

                    }else{
                         print("登入完畢")

                    }

          }
    }
    
    @IBOutlet weak var signInButton: GIDSignInButton?
    @IBOutlet weak var PostResources: UIButton!
   
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.maskview.alpha = 0
               if GIDSignIn.sharedInstance()?.hasPreviousSignIn() == true {
                GIDSignIn.sharedInstance()?.restorePreviousSignIn()
                self.maskview.alpha = 0.5
                 self.activeIndicator.startAnimating()
        }
        
    }
       let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad() 
        
//        let cacheURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("CloudKit").appendingPathComponent("50943AB7-D39D-44C3-9308-956ED6B50390.01c0978ce2db7a8997756143f682dbe2133a957ee1")
//        print(cacheURL)
//
//        let imageData = NSData(contentsOf: cacheURL)
        
         
        
 
       
        //        print(Auth.auth().currentUser?.email)
//        print(GIDSignIn.sharedInstance()?.currentUser.profile.name)
//         getGoogleGmailDoIdentify()
        
//        let db = Firestore.firestore()
//        guard let filter = GIDSignIn.sharedInstance()!.currentUser.profile.email else {return}
//        print(filter)
          
//           let predicate: NSPredicate = NSPredicate(format: "Gmail = %@", filter)
//        db.collection("user").filter(using: predicate).getDocuments { (data, error) in
//            guard let data = data else {return}
//            for i in data.documents{
//                db.collection("user").document("\(i.documentID)").getDocument { (data, error) in
//                    if let data = data{
//                        print(data.data()!["Gmail"])
//                        print(data.data()!["nickName"])
//                    }
//                }
//            }
//        }
         
//          guard let filter = GIDSignIn.sharedInstance()!.currentUser.profile.email else {return}
//        db.collection("user").whereField("Gmail", isEqualTo: filter).getDocuments { (data, error) in
//            for i in data!.documents{
//                print(i.documentID)
//            }
//        }
        
//           a.getDocuments { (data, error) in
//               if let error = error{
//                   print(error)
//               }else{
//                   for i in data!.documents{
//                       print(i.data()["nickName"])
//                   }
//
//
//               }
//           }
      locationManager.requestAlwaysAuthorization() //要求權限
          locationManager.delegate = self
        
       
        GIDSignIn.sharedInstance()?.delegate = self
        
     
 
        
    }
    
    func FirstSignUp(){
        let alletAction = UIAlertController(title: "感謝您使用 我OK送給您", message: "第一次使用請填寫以下資訊,謝謝", preferredStyle: .alert)
        alletAction.addTextField { (UITextField) in}
        alletAction.addTextField { (UITextField) in}
        alletAction.addTextField { (UITextField) in}
        let nickNameTextField = alletAction.textFields![0] as UITextField
        nickNameTextField.placeholder = "暱稱(必填)"
        let phoneNumberTextField = alletAction.textFields![1] as UITextField
        phoneNumberTextField.placeholder = "手機號碼(必填)"
        let emailTextField = alletAction.textFields![2] as UITextField
        emailTextField.placeholder = "信箱(必填)"
        let okAction = UIAlertAction(title: "ok", style: .default) { (ok) in
           self.db.collection("user").document("\(GIDSignIn.sharedInstance()!.currentUser!.profile.name!)").setData(
            ["nickName":alletAction.textFields![0].text ?? "N/A",
             "phoneNumber":alletAction.textFields![1].text ?? "N/A",
             "byuserKeyGmail":alletAction.textFields![2].text ?? "N/A",
             "Gmail":Auth.auth().currentUser?.email ?? "NoEmail"
            ]
           ) { (error) in  }
            self.signUpDone()
        }
        alletAction.addAction(okAction)
        present(alletAction,animated: true)
        
    }
    func signUpDone(){
        let doneSignUpAction = UIAlertController(title: "註冊完成", message:  nil , preferredStyle: .alert)
        let doneSignupAction = UIAlertAction(title: "Go!", style: .default, handler: nil)
        doneSignUpAction.addAction(doneSignupAction)
        present(doneSignUpAction,animated: true)
    }
    
  
   
    @IBAction func PostResourcesAction(_ sender: Any) {
 
        if GIDSignIn.sharedInstance()?.currentUser != nil{
         
            performSegue(withIdentifier: "tabSegue", sender: nil)
      
            
        }else{
            let alerController = UIAlertController(title: "登入", message: " ", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Google登入", style: .default) { (ok) in
                     print("使用者尚未登入")
                    GoogleLogin.share.SignIn(whichViewVC: self)
                    self.maskview.alpha = 0.5
                     self.activeIndicator.startAnimating()
                }
            let cancelaction = UIAlertAction(title: "取消", style: .cancel) { (cancel) in }
            let apple = UIAlertAction(title: "取消", style: .default) { (cancel) in }
            let gmail = UIAlertAction(title: "取消", style: .default) { (cancel) in }
            alerController.addAction(okAction)
            alerController.addAction(cancelaction)
            alerController.addAction(apple)
            alerController.addAction(gmail)
//            alerController.isModalInPresentation = true
            present(alerController,animated: true)
          
    
   
    
        
}

    
    func getGoogleGmailDoIdentify(){
        
        let db = Firestore.firestore()
        let filter: String! = GIDSignIn.sharedInstance()?.currentUser.profile.familyName
        let predicate: NSPredicate = NSPredicate(format: "user = %@", filter)
      let a =   db.collection("user").filter(using: predicate)
        a.getDocuments { (data, error) in
            if let error = error{
                print(error)
            }else{
                for i in data!.documents{
                    print(i.data()["nickName"])
                }
            }
        }
    }
   
     
    }
}

