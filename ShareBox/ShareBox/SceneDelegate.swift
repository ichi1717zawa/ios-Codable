//
//  SceneDelegate.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/15.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import Messages
import Firebase
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    
    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
       
          print("進入背景")
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "通知收鍵盤"), object: nil)
        

    }
    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("準備進入背景")
    }
   
    func sceneDidDisconnect(_ scene: UIScene) {
        print("切斷連接")
    }
    func sceneDidBecomeActive(_ scene: UIScene) {
      print("重新活動")
 
    }

 
    
}

