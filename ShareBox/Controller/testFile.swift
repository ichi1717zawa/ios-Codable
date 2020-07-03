//
//  testFile.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/7/2.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import Firebase
class testFile: UIViewController {
    let db  = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
queryFirestore()
        
//        let now = String(Date().timeIntervalSince1970)
              
//              let dateformatter = DateFormatter()
              //    dateformatter.dateFormat = "MM/dd/yy HH/mm/ss"
//              let currentTime = dateformatter.string(from: now)
//        print("Noew\(now)")
    }
    
    func queryFirestore(){
        let nowTime = String(Date().timeIntervalSince1970)
       
              db.collection("userPost").order(by: "timeStamp").whereField("coreDataTimeUse", isGreaterThan: nowTime).addSnapshotListener { (query, error) in
                                if let error = error{
                                    print("query Faild\(error)")
                                }
                        
            //            db.collection("userPost").whereField("coreDataTimeUse", isLessThan:    nowTime).addSnapshotListener { (query, error) in
            //                           if let error = error{
            //                               print("query Faild\(error)")
            //                           }
            
            
                    guard let documentChange = query?.documentChanges else {return}
                    for change in documentChange{
                       
                        //處理每一筆更新
                        let documentID = change.document.documentID
                          
                        if change.type == .added{
                       let postdetail = allPostModel(categoryImage: UIImage(named: "photo.fill")!,
                        likeImage: UIImage(named: "pointRed")!,
                        buildTime: change.document.data()["postTime"] as? String ?? "N/A",
                        subTitle: change.document.data()["postIntroduction"] as? String ?? "N/A",
                        Title: change.document.data()["postCategory"] as? String ?? "N/A",
                        postGoogleName: change.document.data()["googleName"] as? String ?? "N/A",
                        postNickName: change.document.data()["Name"]as? String ?? "N/A",
                        postUUID: change.document.data()["postUUID"] as? String ?? "N/A" ,
                        postTime: change.document.data()["postTime"] as? String ?? "N/A",
                        viewsCount: change.document.data()["viewsCount"] as? Int ?? 0,
                        productName:change.document.data()["productName"] as? String ?? "N/A",
                        userLocation: change.document.data()["userLocation"] as? String ?? "N/A",
                        userShortLocation:change.document.data()["userShortLocation"] as? String ?? "N/A",
                        favoriteCount: change.document.data()["favoriteCounts"] as? Int ?? 0,
                        mainCategory:change.document.data()["mainCategory"] as? String ?? "N/A",
                        subCategory: change.document.data()["postCategory"] as? String ?? "N/A",
                        posterUID: change.document.data()["posterUID"] as? String ?? "N/A")
                            
 print(                       documentID )
 
                            
                        }
            }
        }
    }
}
