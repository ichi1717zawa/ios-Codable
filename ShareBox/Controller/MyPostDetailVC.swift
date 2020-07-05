 

import UIKit
import MapKit
import Firebase
import GoogleSignIn
import CloudKit
 import FirebaseStorage
 protocol myPostDetailDeleate: class {
    func Update(data:allPostModel)
 }
class myPostDetailVC: UIViewController  {
    weak var delegate : myPostDetailDeleate?
    var data : allPostModel!
    var db = Firestore.firestore()
    var annotation : MKAnnotation?
    var tempIndex : IndexPath!
    let myUID : String! = Auth.auth().currentUser?.uid
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postimage: UIImageView!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var MaincategoryLabel: UILabel!
    @IBOutlet weak var SubcategoryLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UITextField!
    @IBOutlet weak var userLocationLabel: UITextField!
    @IBOutlet weak var discriptionLabel: UITextView!
    var image : UIImage!
    let database = CKContainer.default().publicCloudDatabase
    var receiverAnnotationData : AnnotationDetail?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let filter: String! = self.data.postUUID
        
//        let e :[String:Any] = ["viewcCount":12]
//        db.collection("userPost").document("\(self.data.postUUID)").getDocument{ (data, error) in
//
//
//        }
        
//        let predicate: NSPredicate = NSPredicate(format: "content = %@", filter)
//        let query = CKQuery(recordType: "Note", predicate: predicate)
////
//        database.perform(query, inZoneWith: nil) { (records, _) in
//            guard var records = records else {return}
//            for record in records{
//
//                let asset = record["myphoto"] as! CKAsset
//                let imageData = NSData(contentsOf: asset.fileURL!)
//                let image = UIImage(data: imageData! as Data)
//
//                DispatchQueue.main.async {
//                    self.postimage.image = image
//                    self.maskView.alpha = 0
//                    self.activityIndicator.stopAnimating()
//                    self.activityIndicator.alpha = 0
//                    self.clearCache()
//                }
//            }
//        }
   let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(data.postUUID)")
        if FileManager.default.fileExists(atPath: url.path){
            maskView.alpha = 0
            
               //            let deCompressData = try!  NSData(contentsOf: url).decompressed(using: .lzma)
               //            let deCompressData = try? NSData(contentsOf: url).decompressed(using: .lzma)
                           let image = UIImage(contentsOfFile: url.path)
                           
               //            let Newimage = UIImage(data: image as! Data)
                           postimage.image = image
                           
                       }else{
                        maskView.alpha = 0.55
                        activityIndicator.startAnimating()
                           let ref = Storage.storage(url: "gs://noteapp-3d428.appspot.com").reference()
                           let imageRef = ref.child("images/\(data.postUUID)")
                           imageRef.write(toFile: url) { (url, error) in
                               if let e = error{
                                   print("下載圖檔有錯誤\(e)")
                               }else{
                                   print("下載成功")
                                   
                                   let image = UIImage(contentsOfFile: url!.path)
                                   //                                        let newImageData = decompressData as Data
                                self.postimage.image = image
                                self.maskView.alpha = 0
                                self.activityIndicator.stopAnimating()
                               }
                               
                           }

                           DispatchQueue.global().async {
               //                       self.getCloudKitImage(uuid: data.postUUID) { (image) in
               //                           DispatchQueue.main.async {
               //                               allPostcell.postImage.image = image
               //
               //                        }
               //                }
                                
                           }
                       }
//        CoredataShare.share.loadData()
//        categoryLabel.text = self.data[self.tempIndex.row].Title
//        niceNameLabel.text = self.data[self.tempIndex.row].postNickName
//        userLocationLabel.text = self.data[self.tempIndex.row].postUUID
//        discriptionLabel.text = self.data[self.tempIndex.row].subTitle
//        categoryLabel.text = self.data.Title
        MaincategoryLabel.text = self.data.mainCategory
        SubcategoryLabel.text = self.data.subCategory
        nickNameLabel.text = self.data.postNickName
        userLocationLabel.text = self.data.userLocation
        discriptionLabel.text = self.data.subTitle
        productName.text = self.data.productName
//        self.receiverAnnotationData = receiveAnnotation
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
//    func getLocation(){
//
//
//    }
    
    @IBOutlet weak var Mynavagation: UIBarButtonItem!
    
    @IBAction func giveAwayPost(_ sender: Any) {
        let postUUID = self.data.postUUID
                
                db.collection("userPost").document(postUUID).delete { (error) in
                    if let error = error{
                        print("PO文刪除失敗：\(error)")
                    }
                }
                
                db.collection("user").document(myUID).collection("myPost").document(postUUID).delete { (error) in
                    if let error = error {
                        print("PO文刪除失敗：\(error)")
                    }
                    self.delegate?.Update(data: self.data)
                    self.navigationController?.popViewController(animated: true)
                }
    }
    
    @IBAction func deletePost(_ sender: Any) {
        maskView.alpha = 0.55
        self.activityIndicator.startAnimating()
        let postUUID = self.data.postUUID
              
        db.collection("userPost").document(postUUID).collection("favoriteCounts").getDocuments { (otherUserId, error) in
            if let e = error{
                print(e)
            }
            guard let userID = otherUserId else {return}
            for userID in userID.documents{
                self.db.collection("user").document(userID.documentID).collection("favoriteList").document(postUUID).delete()
            }
            
            
        }
              db.collection("userPost").document(postUUID).delete { (error) in
                  if let error = error{
                      print("PO文刪除失敗：\(error)")
                  }
              }
              
              db.collection("user").document(myUID).collection("myPost").document(postUUID).delete { (error) in
                  if let error = error {
                      print("PO文刪除失敗：\(error)")
                  }
                  self.delegate?.Update(data: self.data)
                  self.navigationController?.popViewController(animated: true)
                 self.maskView.alpha = 0
                 self.activityIndicator.stopAnimating()
              }
        
        
    }

    
    
    
    @IBAction func BackToRootViewcontroller(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var MynavigationBar: UINavigationBar!
    
}

//
//import UIKit
//import MapKit
//import Firebase
//import GoogleSignIn
//import CloudKit
//class myPostDetailVC: UIViewController      {
//    var data : PostInfomation!
//    var db = Firestore.firestore()
//    var annotation : MKAnnotation?
//    var tempIndex : IndexPath!
//    @IBOutlet weak var maskView: UIView!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var postimage: UIImageView!
//    @IBOutlet weak var categoryLabel: UILabel!
//    @IBOutlet weak var niceNameLabel: UILabel!
//    @IBOutlet weak var userLocationLabel: UILabel!
//    @IBOutlet weak var discriptionLabel: UILabel!
//    var image : UIImage!
//    let database = CKContainer.default().publicCloudDatabase
//    var receiverAnnotationData : AnnotationDetail?
//
//
//
//
//
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        activityIndicator.startAnimating()
//
//
//        let filter: String! = self.data.postUUID
//        print(filter!)
//        let predicate: NSPredicate = NSPredicate(format: "content = %@", filter)
//        let query = CKQuery(recordType: "Note", predicate: predicate)
////
//        database.perform(query, inZoneWith: nil) { (records, _) in
//            guard var records = records else {return}
//            for record in records{
//
//                let asset = record["myphoto"] as! CKAsset
//                let imageData = NSData(contentsOf: asset.fileURL!)
//                let image = UIImage(data: imageData! as Data)
//
//                DispatchQueue.main.async {
//                    self.postimage.image = image
//                    self.maskView.alpha = 0
//                    self.activityIndicator.stopAnimating()
//                    self.activityIndicator.alpha = 0
//                    self.clearCache()
//                }
//            }
//        }
//
//        categoryLabel.text = "種類：\(data.postCategory)"
//        niceNameLabel.text = "暱稱：\(data.nickname)"
//        userLocationLabel.text = "供取貨位置：\(data.userLocation)"
//        discriptionLabel.text = "物品簡介：\(data.postIntroduction)"
//
//    }
//
//
//
//    func clearCache(){
//
//          let cacheURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("CloudKit")
//            let fileManager = FileManager.default
//            do {
//                // Get the directory contents urls (including subfolders urls)
//              let directoryContents = try FileManager.default.contentsOfDirectory( at: cacheURL, includingPropertiesForKeys: nil, options: [])
//                for file in directoryContents {
//                    do {
//                        try fileManager.removeItem(at: file)
//                    }
//                    catch let error as NSError {
//                        debugPrint("Ooops! Something went wrong: \(error)")
//                    }
//
//                }
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//        }
//
//
//}
