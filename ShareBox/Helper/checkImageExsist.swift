//
//  checkImageExsist.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/7/9.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class checkImageExsist  {
    
    static let share = checkImageExsist()
    
    
    func  checkImage(postUUID:String,postimage:UIImageView,maskView:UIView,activityIndicator:UIActivityIndicatorView)   {
       
        guard   let filePath2 = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("\(postUUID)") else {return}
        
                       if FileManager.default.fileExists(atPath: filePath2.path){
                                       maskView.alpha = 0
                                       
                  //                    let compressedData = try? NSData(contentsOfFile: url.path)?.decompressed(using: .lzma)
                  //                    let myImage = UIImage(data: compressedData as! Data )
                                      let image = UIImage(contentsOfFile: filePath2.path)
                                      postimage.image = image
                                  }else{
                                      maskView.alpha = 0.5
                                      activityIndicator.startAnimating()
                  //                    let predicate: NSPredicate = NSPredicate(format: "content = %@", filter)
                  //                           let query = CKQuery(recordType: "Note", predicate: predicate)
                  //                    self.database.perform(query, inZoneWith: nil) { (records, _) in
                  //                               guard let records = records else {return}
                  //                               for record in records{
                  //                                   let asset = record["myphoto"] as! CKAsset
                  ////                                let imageData = NSData(contentsOf: asset.fileURL!)
                  //                                let imageData = NSData(contentsOf: asset.fileURL!)
                  //                              let newImageData =  try! imageData!.decompressed(using: .lzma)
                  ////                                   let image = UIImage(data: imageData! as Data)
                  //                                let image = UIImage(data: newImageData as Data)
                  //                                print(image)
                  //                                   DispatchQueue.main.async {
                  //                                       self.postimage.image =  image
                  //                                       self.maskView.alpha = 0
                  //                                       self.activityIndicator.stopAnimating()
                  //                                       self.activityIndicator.alpha = 0
                  ////                                       self.clearCache()
                  //                                   }
                  //                               }
                  //                           }
                                     
                                      let ref = Storage.storage(url: "gs://noteapp-3d428.appspot.com").reference()
                                      let imageRef = ref.child("images/\(postUUID)")
                                      imageRef.write(toFile: filePath2) { (url, error) in
                                                         if let e = error{
                                                             print("下載圖檔有錯誤\(e)")
                                                         }else{
                                                              print("下載成功")
                                                          print(url)
                  //                                        let decompressData = try? NSData(contentsOfFile: filePath2.path)?.decompressed(using: .lzma)
                  //                                        let newImageData = decompressData as Data
                  //                                        let newdata = (decompressData as! Data)
                                                          let image = UIImage(contentsOfFile: filePath2.path)
                                                          postimage.image = image
                                                         maskView.alpha = 0.0
                                                       activityIndicator.stopAnimating()
                                                          
                                                            
                                                         }
                                                     }
                                  }
    }
}
 