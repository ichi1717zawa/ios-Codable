//
//  PushNotificationSender.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/8/1.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import UIKit

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String ,badgeValue:Int) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body, "sound" : "default","badge":badgeValue],
                                           "data" : ["user" : "test_id"],
                                           
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAkPsryUI:APA91bH7A3z373kE7-IqEQELlvdJB_PkjlPfsU9vM4xCytxHuiVxGfULM4VLdGo6aZ6jn_KTS2c2J1UB1-cogC_EgRRWDGxHEuYdntVEkiVqHv3amslVrhbrSoMzHpOiGCAZ_6zgO_MI", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
