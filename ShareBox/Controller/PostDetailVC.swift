//
//  PostDetailVC.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/30.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import GoogleSignIn
import CloudKit
class PostDetailVC: UIViewController      {
  
    var db = Firestore.firestore()
    var annotation : MKAnnotation?
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postimage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var niceNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    var image : UIImage!
    let database = CKContainer.default().publicCloudDatabase
    var receiverAnnotationData : AnnotationDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
//        self.postimage.image = UIImage(named: "photo.fill")
        let receiveAnnotation = annotation as! AnnotationDetail
        let filter: String! = receiveAnnotation.postUUID
         
        let predicate: NSPredicate = NSPredicate(format: "content = %@", filter)
        let query = CKQuery(recordType: "Note", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { (records, _) in
            guard let records = records else {return}
            for record in records{
                
                let asset = record["myphoto"] as! CKAsset
                let imageData = NSData(contentsOf: asset.fileURL!)
                let image = UIImage(data: imageData! as Data)
                
                DispatchQueue.main.async {
                    self.postimage.image = image
                    self.maskView.alpha = 0
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.clearCache()
                }
            }
        }
 
        CoredataShare.share.loadData()
//        categoryLabel.text = receiveAnnotation.postCategory ?? "qwe"
        categoryLabel.text = receiveAnnotation.title
//        niceNameLabel.text = receiveAnnotation.nickName ?? "qwe"
//        userLocationLabel.text = receiveAnnotation.userLocation ?? "qwe"
//        discriptionLabel.text = receiveAnnotation.postIntroduction ?? "eqwe"
        self.receiverAnnotationData = receiveAnnotation
    }
     

    
    @IBAction func sendMessage(_ sender: Any) {
//        var myNickName :String!
         print("click sendMessageButton")

        
        performSegue(withIdentifier: "personalMessageWithMap", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "personalMessageWithMap"{
//              let personalMessage = segue.destination as! chatTable
//            personalMessage.otherGoogleName = self.receiverAnnotationData?.googleName ?? "N/A"
//            personalMessage.otherNickName = self.receiverAnnotationData?.nickName ?? "N/A"
          }
      }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                   //位置的更新需要移動才會回傳
                       guard let coodinate = locations.last?.coordinate else {
                           return
                       }
                       print("coodinate:\(coodinate.latitude),\(coodinate.longitude)") //經緯度
    //                print(locations)
                       //只做一次
        //               DispatchQueue.once(token: "addAnnotation") {
        //                   addAnnotation(coodinate)
        //               }
        //               DispatchQueue.once(token: "moveRegion") {
        //                   moveRegion(coodinate: coodinate)
        //               }
            //        FIRFirestoreService.shared.mapcreate(locations: locations) //呼叫儲存至Database


                   }
    func clearCache(){
          let cacheURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("CloudKit")
            let fileManager = FileManager.default
            do {
                // Get the directory contents urls (including subfolders urls)
              let directoryContents = try FileManager.default.contentsOfDirectory( at: cacheURL, includingPropertiesForKeys: nil, options: [])
                for file in directoryContents {
                    do {
                        try fileManager.removeItem(at: file)
                    }
                    catch let error as NSError {
                        debugPrint("Ooops! Something went wrong: \(error)")
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
 
    
   
}
