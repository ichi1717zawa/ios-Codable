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
                        self.performSegue(withIdentifier: "FirstLoginSegue", sender: nil)
                        print("Not In database")
                    }else{
                         
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
    @IBOutlet weak var ReceivePostResources: UIButton!
    @IBOutlet weak var LogoutButton: UIButton!
   
    
       let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() == true {GIDSignIn.sharedInstance()?.restorePreviousSignIn() }
       
         
//        print(Auth.auth().currentUser?.email)
//        print(GIDSignIn.sharedInstance()?.currentUser.profile.name)
//         getGoogleGmailDoIdentify()
        
        let db = Firestore.firestore()
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
        
        if GIDSignIn.sharedInstance()?.currentUser != nil{
              LogoutButton.alpha = 1
        
        }
 
        
    }
    
    
  
   
    @IBAction func PostResourcesAction(_ sender: Any) {
 
        if GIDSignIn.sharedInstance()?.currentUser != nil{
            LogoutButton.alpha = 1
            performSegue(withIdentifier: "tabSegue", sender: nil)
            
        }else{
            let alerController = UIAlertController(title: "登入", message: " ", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Google登入", style: .default) { (ok) in
                     print("使用者尚未登入")
                    GoogleLogin.share.SignIn(whichViewVC: self)
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
    
   
    
        
}
    @IBAction func SignOut(_ sender: Any) {
        
        GoogleLogin.share.SignOut(whichViewVC: self, SignOutButton: LogoutButton)
        
//
//        GIDSignIn.sharedInstance()!.signOut()
//         try? Auth.auth().signOut()
        
      
        
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

