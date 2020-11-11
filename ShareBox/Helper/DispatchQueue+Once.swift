//
//  DispatchQueue+Once.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/23.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    //靜態static 全域皆可用
    private static var _onceTokens = [String]()
    
    public class func once (token:String, job:()->Void ){
        
        //Thread Safe 注意 沒設定的話,多個地方同時呼叫,會導致多執行序搶onceTokens
        objc_sync_enter(self) //上鎖 Thread Safe
        
        
        // 延後 延遲 defer 離開大刮號或class就會執行
        defer {
            objc_sync_exit(self) //解鎖 Thread Safe
        }
        
        //Check if it is exsist?
        if _onceTokens.contains(token){
            return
        }
        //如果不存在執行以下
        _onceTokens.append(token)
        job()
        
    }
}
