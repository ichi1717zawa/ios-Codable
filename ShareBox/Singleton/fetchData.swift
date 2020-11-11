//
//  fetchData.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/11/6.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import Firebase
class fetchData {
    
    static let shared = fetchData()
    var data: [allPostModel] = []
    var myUserData :  myUserInfo?
    var lastTime : String?
    var lastDocument : QueryDocumentSnapshot?
    var db = Firestore.firestore()
    var Pagination : Bool = false
    
    
    func testData( ){
        
        db.collection("userPost").getDocuments { (query, error) in
            if let error = error{  print("query Faild\(error)");  return  }
            print("dcq",query!.documents.count)
             
        }
    }
    
    
    func queryFirestore(complete:@escaping ([allPostModel]) -> Void){
        
        db.collection("userPost").order(by: "timeStamp",descending: true ).limit(to: 10).getDocuments { (query, error) in
            if let error = error{  print("query Faild\(error)");  return  }
            
            guard let query = query else {return}
            if let querylast = query.documents.last{
                self.lastDocument = querylast
            } 
            for document in query.documents{ 
                let postdetail = allPostModel.QueryData2(Document:document )
                self.data.append(postdetail)
            }
            
            self.lastTime =  self.data.last?.longPostTime 
            complete(self.data)
        }
    }
    
    func fetchSingleData(uuid:String) -> allPostModel? {
        var data : allPostModel?
        if let SingleData = self.data.filter { (SingleData) -> Bool in
            SingleData.postUUID == uuid
        }.first{
            data = SingleData
        }
        guard let fetchData = data else {return nil}
        return fetchData
        
        
    }
    
    func fetchMyPostData(myuid:String,complete:@escaping ([allPostModel]) -> Void)   {
        var myPostdata : [allPostModel]?
//        if let post = self.data.filter({ (mypost) -> Bool in
//            mypost.posterUID == myuid
//        }).first{
//            myPostdata?.append(post)
//            
//        }
        
         let pos = self.data.filter({ (mypost) -> Bool in
            mypost.posterUID == myuid
        })
        complete(pos)
        
        
    }

    func fetchMyinfo(complete:@escaping (myUserInfo) -> Void){
        
        db.collection("user").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "N/A").getDocuments { (data, error) in
            guard let data = data else {return}
            for i in data.documents{
                var info = myUserInfo(nickname: "\(i.data()["nickName"] ?? "N/A")",
                                   userPhoneNumber: "\(i.data()["phoneNumber"] ?? "N/A")",
                                   googleGamil: "\(i.data()["Gmail"] ?? "N/A")",
                                   userName: "")
                complete(info)
                
            }
        }
    }
    
    
    
    func updateCount (documentID:Any){ 
        self.db.collection("userPost").document("\(documentID)").collection("views").getDocuments{ (data, error) in
            guard error == nil else {return}
            print("qqq",data?.count)
//            for _ in data!.documents{
                self.db.collection("userPost").document("\(documentID)").updateData(["viewsCount":data!.count])
//                print("有幾個",data!.count)
//            }
        }
    }
    
    
//    func nextPageData(){
//        Pagination = true
//        
////        listener?.remove()
//        db.collection("userPost").order(by: "timeStamp",descending: true).limit(to: 5).start(afterDocument: self.lastDocument!).getDocuments { (query, error) in
//            guard let checkDataEmpty = query else {return}
//            if checkDataEmpty.isEmpty {
//                self.tableview.tableFooterView = nil
//                return
//            }
//            
//            
//            if let error = error{ print("query Faild\(error)")  }
//            guard let myquest = query else {return}
//            if let querylast = myquest.documents.last{
//                self.lastDocument = querylast
//            }
//            
//            //             guard let documentChange = query?.documentChanges else {return}
//            guard let documentChange = query?.documentChanges else {return}
//            for change in documentChange{
//                //處理每一筆更新
//                let documentID = change.document.documentID
//                self.updateCount(documentID: documentID)
//                self.updateFavoriteCount(documentID: documentID)
//                if change.type == .added{
//                    let postdetail = allPostModel.QueryData(Document: change)
//                    self.data.append(postdetail)
////                    self.getfavoriteListName()
//                    self.tableview.reloadData()
//                    
//                }
//            }
//            //                    self.tableview.tableFooterView = nil
//            
//            self.Pagination = false
//        }
//        
//    }
}
