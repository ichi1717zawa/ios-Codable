//
//  currentTime.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/2.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation


class currentTime    {
    static var share = currentTime()
    func time() -> String{
    let now = Date()
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "MM/dd"
    let currentTime = dateformatter.string(from: now)
    
    return currentTime
    }
}
