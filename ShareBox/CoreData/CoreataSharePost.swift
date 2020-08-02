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

class CoredataSharePost {
    
    static let share = CoredataSharePost()
    
    
    
    let myContextPost = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let myContextPost = PersistenceService.context
    let request = NSFetchRequest<PostInfomation>(entityName: "Post")
    var data : [PostInfomation] = []
    func loadData (){

                  let request = NSFetchRequest<PostInfomation>(entityName: "Post")
//                  let sort = NSSortDescriptor(key: "labelName", ascending: false)
//                  request.sortDescriptors = [sort]
                  myContextPost.performAndWait {
                      do{
                          let results = try myContextPost.fetch(request)
                        
                          self.data = results
                      }catch{
                          print("error while fetching Note from db \(error)")
                          
                      }
                  }
                  
                  
                  
              }
              
              //-----------------------------------------------------
           func saveData(){
                          try? myContextPost.save()
                      }
    
    
    func myContextCount() -> Int {
        guard let myContext = try? self.myContextPost.count(for: request) else {
            return 0
        }
        return myContext
    }
    
    
}
