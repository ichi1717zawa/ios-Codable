//
//  userInfo.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/16.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import CoreData


class ChatMessageKit : NSManagedObject {
    
    
    
    @NSManaged  var time : String
    @NSManaged  var type : String
   
    
     @NSManaged  var message : String
    
    
    override func awakeFromInsert() {
     
//        self.type = ""
//        self.time = ""
//
        
            }
    
    
    
    
}
