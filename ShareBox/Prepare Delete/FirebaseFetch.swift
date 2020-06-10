////
////  FirebaseFetch.swift
////  ShareBox
////
////  Created by 廖逸澤 on 2020/6/1.
////  Copyright © 2020 廖逸澤. All rights reserved.
////
//
// 
//import UIKit
//import Firebase
//import GoogleSignIn
//import CoreLocation
//import MapKit
//import CloudKit
//extension MapVC {
//
//  
//   //監聽資料庫若有異動 通知app修改資料
////       func queryFirestore(){
////        db.collection("userPost").order(by: "postUUID", descending: false).order(by: "name", descending: true).addSnapshotListener { (query, error) in
////               if let error = error{
////                   print("query Faild\(error)")
////               }
////            
////            
////            
////               
////               guard let documentChange = query?.documentChanges else {return}
////               for change in documentChange{
////                   //處理每一筆更新 
////                   if change.type == .added{
////                               let userLocation =  change.document.data()["userLocation"] as? String ?? "花蓮縣新城鄉北埔村光復路157號"
////                               let geoLocation = CLGeocoder()
////                               geoLocation.geocodeAddressString(userLocation
////                               ) { (placemarks, error) in
////                                   if let error = error{
////                                       print(error)
////                                   }
////                                   
////                                   guard let placemark = placemarks?.first, let cordinate = placemark.location?.coordinate else {return}
////                                   print(cordinate.latitude)
////                                   var annotationCoordinate  = cordinate
////                                   annotationCoordinate.latitude += 0.0001
////                                   print(annotationCoordinate.latitude)
////                                   annotationCoordinate.longitude += 0.0001
////                                   
////                                   let annotation = AnnotationDetail(title: change.document.data()["postCategory"] as? String ?? "N/A",
////                                                                     Subtitle: change.document.data()["postIntroduction"] as? String ?? "N/A",
////                                                                     coordinate: annotationCoordinate,
////                                                                     postIntroduction: change.document.data()["postIntroduction"] as? String ?? "N/A",
////                                                                     nickName: change.document.data()["Name"] as? String ?? "N/A",
////                                                                     postCategory: change.document.data()["postCategory"] as? String ?? "N/A",
////                                                                     userLocation:change.document.data()["userLocation"] as? String ?? "N/A",
////                                                                     googleName: change.document.data()["googleName"] as? String ?? "N/A",
////                                                                     postUUID: change.document.data()["postUUID"] as? String ?? "N/A",
////                                                                     postTime: change.document.data()["postTime"] as? String ?? "N/A",
////                                                                     viewsCount: change.document.data()["viewsCount"] as? Int ?? 0)
////                                self.mapKitView.delegate = self
////                                   self.mapKitView.addAnnotation(annotation)
////                                  
//////                                   self.moveRegion(coodinate: cordinate)
////                               }
////                    
////   
////                       //新增
//////                       let PostInformation = PostInfomation(context: CoredataSharePost.share.myContextPost)
//////                       PostInformation.postCategory = change.document.data()["postCategory"] as? String ?? "玩具"
//////                       PostInformation.nickname = change.document.data()["nickName"] as? String ?? ""
//////                       PostInformation.postID = noteID
////                    
//////                       let indexPath = IndexPath(row: 0, section: 0)
//////                       self.tableView.insertRows(at: [indexPath], with: .automatic)
////                   }
////                   
//////                   else if change.type == .modified{ //修改
//////                       if let note = self.data.filter({ (note) -> Bool in
//////                            note.noteID == noteID
//////                           }).first{
//////                               note.text = change.document.data()["text"] as? String
//////                               note.imageName = change.document.data()["imageName"] as? String
//////                           if let index = self.data.index(of: note){
//////                               let indexPath = IndexPath(row: index, section: 0)
//////                               self.tableView.reloadRows(at: [indexPath], with: .automatic)
//////                               }
//////                           }
//////
//////                   }
//////                   else if change.type == .removed{//刪除
//////                       if let note = self.data.filter({ (note) -> Bool in
//////                           note.noteID == noteID
//////                       }).first{
//////                           if let index = self.data.index(of: note){
//////                               self.data.remove(at: index)//從data中移除
//////                               //通知tableView刪除該筆
//////                               let indexPath = IndexPath(row: index, section: 0)
//////                               self.tableView.deleteRows(at: [indexPath], with: .automatic)
//////                           }
//////                       }
//////                   }
////               }
////           }
////           
////           
////       }
//
//
//}
