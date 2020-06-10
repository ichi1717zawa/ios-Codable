//
//  FIreBaseStore.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/16.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import GoogleSignIn
import CoreLocation
class FIRFirestoreService{
    let PostShare = CoredataSharePost.share
    var a = 0
    private init(){}
    static let shared = FIRFirestoreService()
   
    
    
    func configure (){
        FirebaseApp.configure()
        }
    
  
    
    
    func create(){
        
        a += 1
        let user = GIDSignIn.sharedInstance()?.currentUser?.profile.familyName
        let parameters : [String:Any] = ["name":"測試文件","age":a]
        let userReference = Firestore.firestore().collection("users").document("\(user ?? "")")
//        userReference.addDocument(data: parameters)
        userReference.setData(parameters)
        }
    
    func mapcreate(locations:[CLLocation]){
        guard let coodinate = locations.last?.coordinate else {
                      return
                  }
        let user = GIDSignIn.sharedInstance()?.currentUser?.profile.familyName
        let parameters : [String:Any] = ["name":"\(coodinate.latitude)","age":(coodinate.latitude)]
        let userReference = Firestore.firestore().collection("users").document("\(user ?? "")"  )
        //        userReference.addDocument(data: parameters)
                userReference.setData(parameters)
        
    }
   

   
    func read( transdata: @escaping (Any) -> Void  ){
        let userReference = Firestore.firestore().collection("users").document("測試文件")
     
        userReference.addSnapshotListener { (snaphost, error) in
            if let error = error{
                 print("error\(error)")
                return
            }
            guard let snaphost = snaphost else {return}
            print(snaphost.data()!["name"] ?? "")
            transdata(snaphost.data()!["name"] ?? "")
              
            
        }
        
    }
    
    func update(){
    
         
    }
    func delete(){
     let userReference = Firestore.firestore().collection("users").document("skyocqk@goamcil.ocom")
        userReference.delete()
    }
    
     
}
