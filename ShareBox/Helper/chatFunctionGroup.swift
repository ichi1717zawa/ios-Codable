//
//  chatFunctionGroup.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/8/2.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class chatFunctionGroup{
    
    static let shared = chatFunctionGroup( )
    let db  = Firestore.firestore()
   
    var ocount = 0
    
       
    func updateTabbarItembadge (userUID:String)   {
         
            db.collection("user").document(userUID).collection("Messages").addSnapshotListener { (query, error) in
                 if  let error   = error {
                 print("query Faild\(error)")
                    return
                }
                
                for i in query!.documents{
                    let readString = i.data()["unRead"] as? String
                    let IntString = Int(readString ?? "")
                    self.ocount += IntString ?? 0
                    print("self.ocount\(  self.ocount)")
                }
                self.db.collection("user").document(userUID).setData(["unread":"\( self.ocount)"],merge: true)
                
                
            }
        
        }
}
