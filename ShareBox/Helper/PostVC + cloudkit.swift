//
//  PostVC + cloudkit.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/5.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import CloudKit
import Firebase
extension PostVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func saveToCloud( ) {
        
//        let image = self.imageview.image?.jpegData(compressionQuality: 0.1)
        let fileName = "123.jpg" 
       let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent(fileName)
        
         let imageData = imageview.image?.jpegData(compressionQuality: 0.1)
//         let url = URL(dataRepresentation: image!, relativeTo: nil)
        try? imageData?.write(to: filePath!,options: [.atomic])
        let myphoto = CKAsset(fileURL: filePath!)
        
//        newNote.setValue(note, forKey: "content")
        newNote.setValue(myphoto, forKey: "myphoto")
        database.save(newNote) { (record, error) in
            if let error = error{
                print(error)
            }
            guard record != nil else { return }
            let parameters = ["recordID":"\(String(describing: record?.recordID))"]
                          self.db.collection("userPost").document("\(UUID().uuidString)").setData(parameters) { (error) in
                              if let e = error{
                                  print("Error=\(e)")
                              }
                          }
            print("saved record")
        }
    }
    
    
     @objc func queryDatabase() {
           
           
    //     let fetchImage = CKFetchRecordsOperation(recordIDs: T##[CKRecord.ID]
        
        
       
            let query = CKQuery(recordType: "Note", predicate: NSPredicate(value: true))
             
            database.perform(query, inZoneWith: nil) { (records, _) in
                
                guard let records = records else { return }
                let sortedRecords = records.sorted(by: { $0.creationDate! > $1.creationDate! })
                self.notes = sortedRecords
                for record in records {
                    
                    self.database.fetch(withRecordID: record.recordID) { (record, error) in
                        if let e = error{
                            print(e)
                        }else{
//                            var file : CKAsset?
                            let asset = record!["myphoto"] as! CKAsset
                            let imageData = NSData(contentsOf: asset.fileURL!)
                            
                            let image = UIImage(data: imageData! as Data)
                            DispatchQueue.main.async {
                                 self.imageview.image = image
                            }
                        
//                            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [record!.recordID])
                         
    //                         fetchRecordsImageOperation.desiredKeys = ["myphotoq"]
    //                        fetchRecordsImageOperation.queuePriority = .veryHigh
    //                        fetchRecordsImageOperation.perRecordCompletionBlock = { (record, recordID, error) -> Void in
    //                        if let error = error {
    //                            print("Failed to get restaurant image: \(error.localizedDescription)")
    //                            return
    //                        }else{
    //                            print(record?.recordID)
    ////
    //                    }
    //
    //                }
                }
                DispatchQueue.main.async {
//                    self.tableView.refreshControl?.endRefreshing()
//                    self.tableView.reloadData()
                        }
                    }
                }
        }
   
    
              
        
  
    
}

}
