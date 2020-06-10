//
//  GoogleLogin.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/25.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import GoogleSignIn

class GoogleLogin    {
    
    
  private init(){}
  static let share = GoogleLogin()
    
    
      
        
        
    func SignIn ( whichViewVC:UIViewController   ){
        
      
      GIDSignIn.sharedInstance()?.presentingViewController = whichViewVC
      GIDSignIn.sharedInstance()?.signIn()
      
      
        
    }
    
    func SignOut(whichViewVC:UIViewController,SignOutButton:UIButton){
         
        GIDSignIn.sharedInstance()?.presentingViewController = whichViewVC
        do
        {
           try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
        SignOutButton.alpha = 0
        }catch{
            assertionFailure("\(error)")
        }
       
    }
    
    
  
}
