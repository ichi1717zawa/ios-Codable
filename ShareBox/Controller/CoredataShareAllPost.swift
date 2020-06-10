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

class CoredataShareAllPost {
    
    static let share = CoredataShareAllPost()
    
    
    
    let AllContextPost = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request = NSFetchRequest<AllPostModelCoreDataModel>(entityName: "AllPost")
    var data : [AllPostModelCoreDataModel] = []
    func loadData (){

                  let request = NSFetchRequest<AllPostModelCoreDataModel>(entityName: "AllPost")
//                  let sort = NSSortDescriptor(key: "labelName", ascending: false)
//                  request.sortDescriptors = [sort]
                  AllContextPost.performAndWait {
                      do{
                          let results = try AllContextPost.fetch(request)
                        
                          self.data = results
                      }catch{
                          print("error while fetching Note from db \(error)")
                          
                      }
                  }
                  
                  
                  
              }
    
    func delete (){

                      let request = NSFetchRequest<AllPostModelCoreDataModel>(entityName: "AllPost")
    //                  let sort = NSSortDescriptor(key: "labelName", ascending: false)
    //                  request.sortDescriptors = [sort]
                      AllContextPost.performAndWait {
                          do{
                              let results = try AllContextPost.fetch(request)
                            for i in results{
                                AllContextPost.delete(i)
                                saveData()
                            }
                            
                              self.data = results
                          }catch{
                              print("error while fetching Note from db \(error)")
                              
                          }
                      }
                      
                      
                      
                  }
              
              //-----------------------------------------------------
           func saveData(){
                          try? AllContextPost.save()
                      }
    
    
    func myContextCount() -> Int {
        guard let myContext = try? self.AllContextPost.count(for: request) else {
            return 0
        }
        return myContext
    }
    
    
}
