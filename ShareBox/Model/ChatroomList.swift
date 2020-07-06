//
//  ChatroomList.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/2.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation


class chatRoomList :Equatable {
    static func ==(lhs: chatRoomList, rhs: chatRoomList) -> Bool {
        return lhs === rhs
    }
    
    
   
    var chatRoomName :String?
    var otherGoogleName : String?
    var unreadCount: String?
    var AllCountArray : String?
    var otherUID:String?
}
