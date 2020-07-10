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
import CryptoKit
import AuthenticationServices

class ChoseAction: UIViewController ,GIDSignInDelegate, CLLocationManagerDelegate, LoginButtonDelegate,UIScrollViewDelegate  {
   
    
 let facebookLoginButton = FBLoginButton(frame: .zero, permissions: [.publicProfile])
     
    @IBOutlet weak var myContentView: UIView!
    @IBOutlet weak var googleLoginBTN: UIButton!
    @IBOutlet weak var facebookLoginBTN: UIButton!
    @IBOutlet weak var appleLoginBTN: UIButton!
    @IBOutlet weak var myscrollview: UIScrollView!
    
    
    
    @IBOutlet weak var startUseApp: UIButton!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var mypageCL: UIPageControl!
    @IBOutlet weak var maskview: UIView!
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: GIDSignInButton?
    @IBOutlet weak var PostResources: UIButton!
    
    let db = Firestore.firestore()
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let locationManager = CLLocationManager()
    
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
//        self.maskview.alpha = 0
//        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() == true {
//            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
//            self.maskview.alpha = 0.5
//            self.activeIndicator.startAnimating()
//        }
//        if let token = AccessToken.current, !token.isExpired{
//        self.performSegue(withIdentifier: "tabSegue", sender: nil)
//
//               }
        if Auth.auth().currentUser != nil{
         
           
            
            self.maskview.alpha = 0
            self.activeIndicator.stopAnimating()
            self.performSegue(withIdentifier: "tabSegue", sender: nil)
        }else{
            self.myscrollview.alpha = 1
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
       
     
    
        
        
        
        if Auth.auth().currentUser != nil{
            myscrollview.alpha = 0
//            self.whiteView.alpha = 0
            self.mypageCL.alpha = 0
          
            self.maskview.alpha = 0.5
            self.activeIndicator.startAnimating()
             
        }else{
            myscrollview.alpha = 1
        }
        
        
        mypageCL.numberOfPages = 3
        myscrollview.delegate = self
         
        facebookLoginButton.delegate = self
        facebookLoginButton.isHidden = true
 
         
        appleSigninSetupView()
    
        locationManager.requestAlwaysAuthorization() //要求權限
        locationManager.delegate = self
//
//
                       
         
         let googleButton = GIDSignInButton()
        
        googleButton.frame.size.width = 255
        googleButton.frame.size.height = 30
//        googleButton.frame.origin.y = self.bottomLine.frame.origin.y - 130
        googleButton.center.x = self.view.center.x
        
        
          let loginButton = FBLoginButton()
        loginButton.delegate = self
        loginButton.frame.size.width = 250
        loginButton.frame.size.height = 35
//        loginButton.frame.origin.y = self.bottomLine.frame.origin.y - 80
        loginButton.center.x = self.view.center.x
        
        
        if #available(iOS 13.0, *) {
            let appleButton = ASAuthorizationAppleIDButton()
//            appleButton.addTarget(self, action: #selector(pressSignInWithAppleButton), for: .touchUpInside)
            appleButton.frame.size.width = 250
                appleButton.frame.size.height = 30
                appleButton.center.x = self.view.center.x
//                appleButton.frame.origin.y  = self.bottomLine.frame.origin.y - 40
//                view.addSubview(appleButton)
        }
    
        
       GIDSignIn.sharedInstance()?.presentingViewController = self
       GIDSignIn.sharedInstance()?.delegate = self
        loginButton.permissions = ["email"]
     
//        view.addSubview(loginButton)
//        view.addSubview(googleButton)
 
      
        googleLoginBTN .layer.cornerRadius = appleLoginBTN.frame.height / 2
          appleLoginBTN .layer.cornerRadius = appleLoginBTN.frame.height / 2
          facebookLoginBTN .layer.cornerRadius = appleLoginBTN.frame.height / 2
        
//        GIDSignIn.sharedInstance()?.presentingViewController = self
        
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
     
    @IBAction func FacebookLoginActionBTN(_ sender: Any) {
        facebookLoginButton.sendActions(for: .touchUpInside)
    }
    @IBAction func AppleLoginActionBTN(_ sender: Any) {
        pressSignInWithAppleButton()
    }
    @IBAction func GoogleLoginActionBTN(_ sender: Any) {
        
//        if GIDSignIn.sharedInstance()?.currentUser != nil{
//            performSegue(withIdentifier: "tabSegue", sender: nil)
//        }else{
            GIDSignIn.sharedInstance()?.signIn()
//             GoogleLogin.share.SignIn(whichViewVC: self)
//            let alerController = UIAlertController(title: "登入", message: " ", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "Google登入", style: .default) { (ok) in
//                print("使用者尚未登入")
//                GoogleLogin.share.SignIn(whichViewVC: self)
//                self.maskview.alpha = 0.5
//                self.activeIndicator.startAnimating()
//            }
//            let cancelaction = UIAlertAction(title: "取消", style: .cancel) { (cancel) in }
//            let apple = UIAlertAction(title: "取消", style: .default) { (cancel) in }
//            let gmail = UIAlertAction(title: "取消", style: .default) { (cancel) in }
//            alerController.addAction(okAction)
//            alerController.addAction(cancelaction)
//            alerController.addAction(apple)
//            alerController.addAction(gmail)
//            //            alerController.isModalInPresentation = true
//            present(alerController,animated: true)
//        }
//        func getGoogleGmailDoIdentify(){
//            let db = Firestore.firestore()
//            let filter: String! = GIDSignIn.sharedInstance()?.currentUser.profile.familyName
//            let predicate: NSPredicate = NSPredicate(format: "user = %@", filter)
//            let a =   db.collection("user").filter(using: predicate)
//            a.getDocuments { (data, error) in
//                if let error = error{
//                    print(error)
//                }else{
//                    for i in data!.documents{
//                        print(i.data()["nickName"])
//                    }
//                }
//            }
//        }
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           let pageNumber = myscrollview.contentOffset.x / scrollView.frame.size.width
             mypageCL.currentPage = Int(pageNumber)
           print(mypageCL.currentPage)
             if mypageCL.currentPage == 1{
                  
             }
         }
    @IBAction func startUseAppAction(_ sender: Any) {
        UIView.animate(withDuration: 1) {
       self.mypageCL.alpha = 0
       self.myscrollview.alpha = 0
//       self.whiteView.alpha = 0
       self.startUseApp.alpha = 0
        }
       
    }
    //MARK: -> FACEBOOK登入
   func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {  print(error.localizedDescription);  return }
    
    
    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? " ")
    Auth.auth().signIn(with: credential) { (authResult, error) in
        guard let authResult = authResult else {return}
        
        self.db.collection("user").whereField("uid", isEqualTo: authResult.user.uid).getDocuments { (data, error) in
            if   data?.isEmpty == true {
         
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
    
    func checkUserData(authResult:AuthDataResult){
        self.db.collection("user").whereField("uid", isEqualTo: authResult.user.uid).getDocuments { (data, error) in
                       if   data?.isEmpty == true {
                           self.maskview.alpha = 0.5
                           self.activeIndicator.startAnimating()
                           self.FirstSignUp()
                           print("Not In database")
                       }else{
                           print(Auth.auth().currentUser?.uid)
                           self.maskview.alpha = 0.5
                           self.activeIndicator.startAnimating()
                           self.performSegue(withIdentifier: "tabSegue", sender: nil)
                           print("user IN database")
                       }
        }
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
                    self.maskview.alpha = 0.5
                    self.activeIndicator.startAnimating()
                    self.FirstSignUp()
                    print("Not In database")
                }else{
                    print(Auth.auth().currentUser?.uid)
                    self.maskview.alpha = 0.5
                    self.activeIndicator.startAnimating()
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
  
    @IBOutlet weak var bottomLine: UIImageView!
    
    
    
    
    //MARK: -> Apple登入
           func appleSigninSetupView() {
               if #available(iOS 13.0, *) {
                   //使用ASAuthorizationAppleIDButton創建SignInwithApple的Button
//                   let appleButton = ASAuthorizationAppleIDButton()
                    
//                   appleButton.translatesAutoresizingMaskIntoConstraints = false
//                   appleButton.addTarget(self, action: #selector(pressSignInWithAppleButton), for: .touchUpInside)
//                appleButton.frame.size.height = 30
//                appleButton.frame.size.width = 180
//                appleButton.center.x = self.view.center.x
//                appleButton.frame.origin.y  = 400
                
                   //設定ASAuthorizationAppleIDButton的Frame，並疊加至storyboard上的View
//                   view.addSubview(appleButton)
                   
//                   NSLayoutConstraint.activate([
//                       appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.bounds.height / 3),
//                       appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
//                       appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
//                   ])
               } else {
                   // Fallback on earlier versions
               }
           }
           
           // 點擊SignInwithApple按鈕後，請求授權
            func pressSignInWithAppleButton() {
               if #available(iOS 13.0, *) {
                   //建立取得使用者資訊的請求
                   let provider = ASAuthorizationAppleIDProvider()
                   let request = provider.createRequest()
                   request.requestedScopes = [.fullName, .email]
                   
                   //用來實作登入成功、失敗的邏輯，來告知ASAuthorizationController該呈現在哪個 Window 上
                   let controller = ASAuthorizationController(authorizationRequests: [request])
                   controller.delegate = self
                   controller.presentationContextProvider = self
                   controller.performRequests()
                
                startSignInWithAppleFlow()
               }
           }
        
           // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
           private func randomNonceString(length: Int = 32) -> String {
             precondition(length > 0)
             let charset: Array<Character> =
                 Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
             var result = ""
             var remainingLength = length

             while remainingLength > 0 {
               let randoms: [UInt8] = (0 ..< 16).map { _ in
                 var random: UInt8 = 0
                 let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                 if errorCode != errSecSuccess {
                   fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                 }
                 return random
               }

               randoms.forEach { random in
                 if remainingLength == 0 {
                   return
                 }

                 if random < charset.count {
                   result.append(charset[Int(random)])
                   remainingLength -= 1
                 }
               }
             }

             return result
           }



           // Unhashed nonce.
           private var currentNonce: String?

           @available(iOS 13, *)
           func startSignInWithAppleFlow() {
            self.maskview.alpha = 0.5
            self.activeIndicator.startAnimating()
             let nonce = randomNonceString()
             currentNonce = nonce
             let appleIDProvider = ASAuthorizationAppleIDProvider()
             let request = appleIDProvider.createRequest()
             request.requestedScopes = [.fullName, .email]
             request.nonce = sha256(nonce)

             let authorizationController = ASAuthorizationController(authorizationRequests: [request])
             authorizationController.delegate = self
             authorizationController.presentationContextProvider = self
             authorizationController.performRequests()
           }

           @available(iOS 13, *)
           private func sha256(_ input: String) -> String {
             let inputData = Data(input.utf8)
             let hashedData = SHA256.hash(data: inputData)
             let hashString = hashedData.compactMap {
               return String(format: "%02x", $0)
             }.joined()

             return hashString
           }
     
        
    }

    //MARK: -ASAuthorizationControllerDelegate
    //Apple login
    extension ChoseAction: ASAuthorizationControllerDelegate {
        
        @available(iOS 13.0, *)
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            
            
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                // Initialize a Firebase credential.
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                
                // Sign in with Firebase.
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    guard let authResult = authResult else {return}
                    if (error != nil) {
                        // Error. If error.code == .MissingOrInvalidNonce, make sure
                        // you're sending the SHA256-hashed nonce as a hex string with
                        // your request to Apple.
                        print(error?.localizedDescription ?? "")
                        return
                    }
                    self.checkUserData(authResult: authResult)
                    print("Apple登入成功")
                    // User is signed in to Firebase with Apple.
                    // ...
//                    self.maskview.alpha = 0
//                    self.activeIndicator.stopAnimating()
//                    self.performSegue(withIdentifier: "tabSegue", sender: nil)
                }
            }
        }
        
        // 授權失敗
        @available(iOS 13.0, *)
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("something  happened", error .localizedDescription)
        }
    }

    //告知 ASAuthorizationController 該呈現在哪個 Window 上
    extension ChoseAction: ASAuthorizationControllerPresentationContextProviding {
        @available(iOS 13.0, *)
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return view.window!
        }
    }


 
 
