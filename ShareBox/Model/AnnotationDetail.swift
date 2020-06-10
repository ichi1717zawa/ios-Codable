//
//  AnnotationDetail.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/31.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import CloudKit
class AnnotationDetail :  NSObject,MKAnnotation{
  
    var title:String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var postIntroduction:String?
    var nickName: String?
    var postCategory : String?
    var userLocation : String?
    var googleName:String?
    var postUUID:String?
    var postTime:String?
    var viewsCount:Int
    
    init(title:String,Subtitle:String,coordinate:CLLocationCoordinate2D,postIntroduction:String,nickName:String,postCategory:String,userLocation:String,googleName:String,postUUID:String,postTime:String,viewsCount:Int) {
        self.title = title
        self.subtitle = Subtitle
        self.coordinate = coordinate
        self.postIntroduction = postIntroduction
        self.nickName = nickName
        self.postCategory = postCategory
        self.userLocation = userLocation
        self.googleName = googleName
        self.postUUID = postUUID
        self.postTime = postTime
        self.viewsCount = viewsCount
    }
    
}
