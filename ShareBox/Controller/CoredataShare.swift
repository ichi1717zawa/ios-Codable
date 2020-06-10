//
//  CoredataShare.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/27.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoredataShare {
    
    static let share = CoredataShare()
    
    
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let request = NSFetchRequest<UserInfomation>(entityName: "UserInfo")
    var data : [UserInfomation] = []
    func loadData (){
//                  let request = NSFetchRequest<UserInfomation>(entityName: "UserInfo")
       //           let sort = NSSortDescriptor(key: "labelName", ascending: false)
       //           request.sortDescriptors = [sort]
        
                  myContext.performAndWait {
                      do{
                          let results = try myContext.fetch(request)
                          self.data = results
                        
                        
                      }catch{
                          print("error while fetching Note from db \(error)")
                          
                      }
                  }
                  
                  
                  
              }
              
              //-----------------------------------------------------
           func saveData(){
                          try? myContext.save()
                      }
    
    
    func myContextCount() -> Int {
        guard let myContext = try? self.myContext.count(for: request) else {
            return 0
        }
        return myContext
    }
    
    
}


