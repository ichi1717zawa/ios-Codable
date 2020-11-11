//
//  allPostVC + oderByFunction.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/17.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import UIKit
import Firebase

enum orderType {
    case time
    case view
    case favorite
}

extension allPostVC {
    
    //MARK: 觀看排序
    @IBAction func oderByViewCounts(_ sender: Any) {
//        self.data.removeAll()
//        tableview.reloadData()
//        queryData(by: "viewsCount")
        print("資料數量",self.data.count)
        orderCurrentData(ordertype: .view)
    }
    //MARK: 時間排序
    @IBAction func oderByTimeStamp(_ sender: Any) {
//        self.data.removeAll()
//
//        self.tableview.reloadData()
//        self.queryData(by: "timeStamp")
        orderCurrentData(ordertype: .time)
        
    }
    //MARK: 收藏排序
    @IBAction func oderByFavorteCounts(_ sender: Any) {
//        self.data.removeAll()
//        tableview.reloadData()
//        queryData(by: "favoriteCounts")
        orderCurrentData(ordertype: .favorite)
    }
    //MARK: 動畫處理
    func animate(){
        UIView.animate(withDuration: 0.5) {
            self.tableview.alpha = 0.1
        }
        UIView.animate(withDuration: 1) {
            self.tableview.alpha = 1
            
        }
    }
    func queryData(by oderby:String){
        animate()

        //        db.collection("userPost").order(by: oderby).addSnapshotListener { (query, error) in
        db.collection("userPost").order(by: oderby).getDocuments(source: .cache){ (query, error) in
            
            if let error = error{
                print("query Faild\(error)")
            }
            
            guard let documentChange = query?.documentChanges else {return}
            for change in documentChange{
                //處理每一筆更新
                let documentID = change.document.documentID
                self.updateCount(documentID: documentID)
                self.updateFavoriteCount(documentID: documentID)
                if change.type == .added{
                    
                    let postdetail = allPostModel(categoryImage: UIImage(named: "chevron.left")!,
                                                  likeImage: UIImage(named: "pointRed")!,
                                                  buildTime: change.document.data()["postTime"] as? String ?? "N/A",
                                                  discription: change.document.data()["postIntroduction"] as? String ?? "N/A",
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
                                                  posterUID: change.document.data()["posterUID"] as? String ?? "N/A",
                                                  longPostTime: change.document.data()["longPostTime"] as? String ?? "N/A")
                    
                    //let annotation = AnnotationDetail(title: change.document.data()["postCategory"] as? String ?? "N/A",
                    //Subtitle: change.document.data()["postIntroduction"] as? String ?? "N/A",
                    //coordinate: annotationCoordinate,
                    //postIntroduction: change.document.data()["postIntroduction"] as? String ?? "N/A",
                    //nickName: change.document.data()["Name"] as? String ?? "N/A",
                    //postCategory: change.document.data()["postCategory"] as? String ?? "N/A",
                    //userLocation:change.document.data()["userLocation"] as? String ?? "N/A",
                    //googleName: change.document.data()["googleName"] as? String ?? "N/A",
                    //postUUID: change.document.data()["postUUID"] as? String ?? "N/A")
                    // self.mapKitView.addAnnotation(annotation)
                    self.data.insert(postdetail, at: 0)
                    //                            self.data.append(postdetail)
                    
                    self.tableview.reloadData()
                    
                }
                else if change.type == .modified{ //修改
                    if let perPost = self.data.filter({ (perPost) -> Bool in
                        perPost.postUUID == documentID
                    }).first{
                        perPost.viewsCount = change.document.data()["viewsCount"] as! Int
                        perPost.favoriteCount = change.document.data()["favoriteCounts"] as! Int
                        //                            note.imageName = change.document.data()["imageName"] as? String
                        //                            if let index = self.data.index(of: perPost){
                        //                                let indexPath = IndexPath(row: index, section: 0)
                        //                                self.tableview.reloadRows(at: [indexPath], with: .fade)
                        self.tableview.reloadData()
                        //                            }
                    }
                    
                }
                else if change.type == .removed{ //刪除
                    
                    if let perPost = self.data.filter({ (perPost) -> Bool in
                        perPost.postUUID == documentID
                    }).first{
                        
                        //                            self.updateFavoriteCount(documentID: perPost.postUUID)
                        
                        
                        //                                perAnnotation.viewsCount = change.document.data()["viewsCount"] as! Int
                        //                            note.imageName = change.document.data()["imageName"] as? String
                        if let index = self.data.firstIndex(of: perPost){
                            let indexPath = IndexPath(row: index, section: 0)
                            //                                self.mapKitView.annotations[indexPath.row]
                            //                                self.data[indexPath.row]
                            //                                 self.tableview.reloadRows(at: [indexPath], with: .fade)
                            self.data.remove(at: indexPath.row)
                            self.tableview.reloadData()
                            //
                            
                        }
                    }
                }
            }
            
        }
         
    }
    
    func orderCurrentData(ordertype:orderType){
        var newData:[allPostModel]
        switch ordertype {
        case .time:
            newData = self.data.sorted { (a1, a2) -> Bool in
                return a1.buildTime  > a2.buildTime
            }
        case .favorite:
            newData = self.data.sorted { (a1, a2) -> Bool in
                return a1.favoriteCount  > a2.favoriteCount
            }
        case .view:
            newData = self.data.sorted { (a1, a2) -> Bool in
                return a1.viewsCount  > a2.viewsCount
            }
        }
        self.data = newData
        self.tableview.reloadData()
    }
}

