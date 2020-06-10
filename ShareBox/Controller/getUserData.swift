//
//  getUserData.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/10.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation

import GoogleSignIn
import Firebase

class getUserData{
      
    let db = Firestore.firestore()
  
static var share = getUserData()
    
    
    
    func getUserNickName(NickName: @escaping (String ) -> ()  )  {
        
        if  let userEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email {
            var MynickName : String!
            self.db.collection("user").whereField("Gmail", isEqualTo: userEmail).getDocuments { (data, error) in
                if let error = error{ print(error)  }
                guard let data = data else {return}
                for i in data.documents{
                    MynickName = (i.data()["nickName"] as! String)
                    
                }
                
            }
            
        }
   }
    
    
    
}
          
    
 
