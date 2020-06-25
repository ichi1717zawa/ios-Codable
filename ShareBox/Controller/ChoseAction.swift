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
import FBSDKLoginKit

class ChoseAction: UIViewController ,GIDSignInDelegate, CLLocationManagerDelegate, LoginButtonDelegate  {
   
    
 
    

    
    
    @IBOutlet weak var maskview: UIView!
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: GIDSignInButton?
    @IBOutlet weak var PostResources: UIButton!
    
    let db = Firestore.firestore()
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let locationManager = CLLocationManager()
    
 
    
 
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.maskview.alpha = 0
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() == true {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            self.maskview.alpha = 0.5
            self.activeIndicator.startAnimating()
        }
        if let token = AccessToken.current, !token.isExpired{
        self.performSegue(withIdentifier: "tabSegue", sender: nil)
                   
               }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.maskview.alpha = 0
        self.activeIndicator.stopAnimating()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad() 
//
         
        print("user\(Auth.auth().currentUser?.uid)")
         print(Auth.auth().currentUser?.displayName)
        locationManager.requestAlwaysAuthorization() //要求權限
        locationManager.delegate = self
//
//
        GIDSignIn.sharedInstance()?.delegate = self
      
          let loginButton = FBLoginButton()
         loginButton.delegate = self
        
        loginButton.frame.origin.y = self.view.frame.origin.y + 200
        loginButton.frame.origin.x = self.view.frame.width / 3
        loginButton.permissions = ["email"]
        view.addSubview(loginButton)
        
        //檢查FB登入狀態
        if let token = AccessToken.current, !token.isExpired{
 self.performSegue(withIdentifier: "tabSegue", sender: nil)
            
        }
      
       
       
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
            guard let uid = Auth.auth().currentUser?.uid else {return}
            self.db.collection("user").document("\(uid)").setData(
                ["nickName":alletAction.textFields![0].text ?? "N/A",
                 "phoneNumber":alletAction.textFields![1].text ?? "N/A",
                 "byuserKeyGmail":alletAction.textFields![2].text ?? "N/A",
                 "Gmail":Auth.auth().currentUser?.email ?? "NoEmail",
                 "uid":Auth.auth().currentUser?.uid ?? "N/A"
                ]
            ) { (error) in  }
            self.signUpDone()
        }
        alletAction.addAction(okAction)
        present(alletAction,animated: true)
        
    }
    func signUpDone(){
        let doneSignUpAction = UIAlertController(title: "註冊完成", message:  nil , preferredStyle: .alert)
        let doneSignupAction = UIAlertAction(title: "Go!", style: .default) { (done) in
            self.performSegue(withIdentifier: "tabSegue", sender: nil)
        }
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
    
 //MARK: -> FACEBOOK登入
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {  print(error.localizedDescription);  return }
        
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
//            guard let authResult = authResult else {return}
            print(Auth.auth().currentUser?.uid)
            self.db.collection("user").whereField("uid", isEqualTo: authResult?.user.uid).getDocuments { (data, error) in
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
        }
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if auth.currentUser == nil{
                print("登出完畢")
                
            }else{
                print("登入完畢")
                print(user?.uid)
                
            }
        }
     }
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("登出完畢")
    }
    
 //MARK: -> GOOGLE登入
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
         if let error = error{
            print("登入錯誤\(error)")
        ; return  }
        
         guard let authentication = user.authentication else { return }
         let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
         Auth.auth().signIn(with: credential) { (authResult, error) in
             if let error = error {
                print("\(error)")
                return }
            
            
            print(authResult?.user.email)
            print(authResult?.user.uid)
            self.db.collection("user").whereField("uid", isEqualTo: authResult?.user.uid).getDocuments { (data, error) in
                if   data?.isEmpty == true {
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
}
 
