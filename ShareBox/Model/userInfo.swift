//
//  userInfo.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/16.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import CoreData


class UserInfomation : NSManagedObject {
    
    
    
    @NSManaged  var nickname : String
    @NSManaged  var contribute : String
    @NSManaged  var userID: String
    @NSManaged  var googleGmail: String
    @NSManaged  var googleName: String
    @NSManaged  var userLocation: String
    @NSManaged  var phoneNumber: String
    
    
    
    
    override func awakeFromInsert() {
        self.userID = UUID().uuidString
        self.nickname = ""
        self.contribute = ""
        self.googleName = ""
        self.googleGmail = ""
        self.userLocation = ""
        self.phoneNumber = ""
        
    }
    
    
    
    
}
