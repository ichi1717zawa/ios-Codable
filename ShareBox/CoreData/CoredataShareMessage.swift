 
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

class CoredataShareMessage {
    
    static let share = CoredataShareMessage( )
    
    
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let myContextMessage = PersistenceService.context
    let request = NSFetchRequest<ChatMessageKit>(entityName: "Message")
    var data : [ChatMessageKit] = []
    
    func loadData (otherUID:String){
      
                  let request = NSFetchRequest<ChatMessageKit>(entityName: "Message")
//                  let sort = NSSortDescriptor(key: "labelName", ascending: false)
//                  request.sortDescriptors = [sort]
                 let predicate = NSPredicate(format: "otherUID = %@ " , otherUID)//contains[cd] %@" Ur/ 精準查詢
        ////        let predicate = NSPredicate(format: "text contains[cd] %@", "Note")//contains[cd] %@" 模糊查詢1
        ////         let predicate = NSPredicate(format: "text like %@", "*Note*")//contains[cd] %@" 模糊查詢2
        ////        fetchRequest.predicate = predicate
                request.predicate = predicate
                  moc.performAndWait {
                      do{
                          let results = try moc.fetch(request)
                        
                          self.data = results
                        print(moc)
                      }catch{
                          print("error while fetching Note from db \(error)")
                          
                      }
                  }
                  
                  
                  
              }
              
              //-----------------------------------------------------
           func saveData(){
                          try? moc.save() 
                      }
    
    
    func myContextCount() -> Int {
        guard let myContext = try? self.moc.count(for: request) else {
            return 0
        }
        return myContext
    }
    
    
}
