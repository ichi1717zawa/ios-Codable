//
//  allPostModel.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/7.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class allPostModel : Equatable{
    static func ==(lhs: allPostModel, rhs: allPostModel) -> Bool {
        return lhs === rhs
    }
    var categoryImage :UIImage
    var likeImage:UIImage
    var buildTime:String
    var discription:String
    var Title:String
    var postGoolgeName:String
    var postNickName:String
    var postUUID:String
    var postTime:String
    var viewsCount:Int
    var productName:String
    var userLocation:String
    var userShortLocation : String
    var favoriteCount:Int
    var mainCategory:String
    var subCategory:String
    var posterUID:String
    var longPostTime:String
    
    init(categoryImage:UIImage,
         likeImage:UIImage,
         buildTime:String,
         discription:String,
         Title:String,
         postGoogleName:String,
         postNickName:String,
         postUUID:String,
         postTime:String,
         viewsCount:Int,
         productName:String,
         userLocation:String,
         userShortLocation:String,
         favoriteCount:Int,
         mainCategory:String,
         subCategory:String,
         posterUID:String,
         longPostTime:String
    )
    
    { 
        self.categoryImage = categoryImage
        self.likeImage = likeImage
        self.buildTime = buildTime
        self.discription = discription
        self.Title = Title
        self.postGoolgeName = postGoogleName
        self.postNickName = postNickName
        self.postUUID = postUUID
        self.postTime = postTime
        self.viewsCount = viewsCount
        self.productName = productName
        self.userLocation = userLocation
        self.userShortLocation = userShortLocation
        self.favoriteCount = favoriteCount
        self.mainCategory = mainCategory
        self.subCategory = subCategory
        self.posterUID = posterUID
        self.longPostTime = longPostTime
    }
    
    
    static func QueryData ( Document:DocumentChange) -> allPostModel{
        let postdetail = allPostModel(categoryImage: UIImage(named: "photo.fill")!,
                                      likeImage: UIImage(named: "pointRed")!,
                                      buildTime: Document.document.data()["postTime"] as? String ?? "N/A",
                                      discription: Document.document.data()["postIntroduction"] as? String ?? "N/A",
                                      Title: Document.document.data()["postCategory"] as? String ?? "N/A",
                                      postGoogleName: Document.document.data()["googleName"] as? String ?? "N/A",
                                      postNickName: Document.document.data()["Name"]as? String ?? "N/A",
                                      postUUID: Document.document.data()["postUUID"] as? String ?? "N/A" ,
                                      postTime: Document.document.data()["postTime"] as? String ?? "N/A",
                                      viewsCount: Document.document.data()["viewsCount"] as? Int ?? 0,
                                      productName:Document.document.data()["productName"] as? String ?? "N/A",
                                      userLocation: Document.document.data()["userLocation"] as? String ?? "N/A",
                                      userShortLocation:Document.document.data()["userShortLocation"] as? String ?? "N/A",
                                      favoriteCount: Document.document.data()["favoriteCounts"] as? Int ?? 0,
                                      mainCategory:Document.document.data()["mainCategory"] as? String ?? "N/A",
                                      subCategory: Document.document.data()["postCategory"] as? String ?? "N/A",
                                      posterUID: Document.document.data()["posterUID"] as? String ?? "N/A",
                                      longPostTime: Document.document.data()["longPostTime"] as? String ?? "N/A")
        return postdetail
    }
    
    static func QueryData2 ( Document:QueryDocumentSnapshot) -> allPostModel{
        let postdetail = allPostModel(categoryImage: UIImage(named: "photo.fill")!,
                                      likeImage: UIImage(named: "pointRed")!,
                                      buildTime: Document.data()["postTime"] as? String ?? "N/A",
                                      discription: Document.data()["postIntroduction"] as? String ?? "N/A",
                                      Title: Document.data()["postCategory"] as? String ?? "N/A",
                                      postGoogleName: Document.data()["googleName"] as? String ?? "N/A",
                                      postNickName: Document.data()["Name"]as? String ?? "N/A",
                                      postUUID: Document.data()["postUUID"] as? String ?? "N/A" ,
                                      postTime: Document.data()["postTime"] as? String ?? "N/A",
                                      viewsCount: Document.data()["viewsCount"] as? Int ?? 0,
                                      productName:Document.data()["productName"] as? String ?? "N/A",
                                      userLocation: Document.data()["userLocation"] as? String ?? "N/A",
                                      userShortLocation:Document.data()["userShortLocation"] as? String ?? "N/A",
                                      favoriteCount: Document.data()["favoriteCounts"] as? Int ?? 0,
                                      mainCategory:Document.data()["mainCategory"] as? String ?? "N/A",
                                      subCategory: Document.data()["postCategory"] as? String ?? "N/A",
                                      posterUID: Document.data()["posterUID"] as? String ?? "N/A",
                                      longPostTime: Document.data()["longPostTime"] as? String ?? "N/A")
        return postdetail
    }
    
}
