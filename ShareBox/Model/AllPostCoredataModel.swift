//
//  allPostModel.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/7.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class AllPostModelCoreDataModel : NSManagedObject{
  
        @NSManaged  var postCategory : String
       @NSManaged  var userLocation : String
       @NSManaged  var nickname: String
       @NSManaged  var postIntroduction: String
       @NSManaged  var postID: String
       @NSManaged  var latitude: String
       @NSManaged  var longitude: String
       @NSManaged  var googleName: String
       @NSManaged  var postUUID: String
//    init(categoryImage:UIImage,likeImage:UIImage,buildTime:String,subTitle:String,Title:String,postGoogleName:String,postNickName:String,postUUID:String) {
//        super.init(context: CoredataShareAllPost.share.myContextPost)
////        self.categoryImage = categoryImage
////        self.likeImage = likeImage
////        self.buildTime = buildTime
////        self.subTitle = subTitle
////        self.Title = Title
////        self.postGoolgeName = postGoogleName
////        self.postNickName = postNickName
////        self.postUUID = postUUID
//    }
    override func awakeFromInsert() {
        
        
               }
    
}
