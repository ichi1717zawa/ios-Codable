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


extension allPostVC {


    @IBAction func oderByViewCounts(_ sender: Any) {
        self.data.removeAll()
        tableview.reloadData()
        queryData(by: "viewsCount")
       }

       @IBAction func oderByTimeStamp(_ sender: Any) {
        self.data.removeAll()
        tableview.reloadData()
        queryData(by: "timeStamp")

       }
       @IBAction func oderByFavorteCounts(_ sender: Any) {
        self.data.removeAll()
        tableview.reloadData()
        queryData(by: "favoriteCounts")
       }


    func queryData(by oderby:String){
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
                        likeImage: "heart-76",
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
                                if let index = self.data.index(of: perPost){
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

        //
        }
    
}
