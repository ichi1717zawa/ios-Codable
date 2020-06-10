//
//  allPostModel.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/7.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import UIKit

class allPostModel : Equatable{
    static func ==(lhs: allPostModel, rhs: allPostModel) -> Bool {
           return lhs === rhs
       }
    var categoryImage :UIImage
    var likeImage:UIImage
    var  buildTime:String
    var subTitle:String
    var  Title:String
    var postGoolgeName:String
    var postNickName:String
    var postUUID:String
    var postTime:String
    var viewsCount:Int
    
    init(categoryImage:UIImage,likeImage:UIImage,buildTime:String,subTitle:String,Title:String,postGoogleName:String,postNickName:String,postUUID:String,postTime:String,viewsCount:Int) {
        
        self.categoryImage = categoryImage
        self.likeImage = likeImage
        self.buildTime = buildTime
        self.subTitle = subTitle
        self.Title = Title
        self.postGoolgeName = postGoogleName
        self.postNickName = postNickName
        self.postUUID = postUUID
        self.postTime = postTime
        self.viewsCount = viewsCount
    }
}
