//
//  SceneDelegate.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/15.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    
    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
          print("進入背景")
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "通知收鍵盤"), object: nil)
        

    }
    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) { 
    }
   
    func sceneDidDisconnect(_ scene: UIScene) {
        print("ewqeqwe")
    }
    func sceneDidBecomeActive(_ scene: UIScene) {
     
 
    }

}

