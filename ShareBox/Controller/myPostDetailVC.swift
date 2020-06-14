 

import UIKit
import MapKit
import Firebase
import GoogleSignIn
import CloudKit
 protocol myPostDetailDeleate: class {
    func Update(data:allPostModel)
 }
class myPostDetailVC: UIViewController  {
    weak var delegate : myPostDetailDeleate?
    var data : allPostModel!
    var db = Firestore.firestore()
    var annotation : MKAnnotation?
    var tempIndex : IndexPath!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postimage: UIImageView!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var categoryLabel: UITextField!
    @IBOutlet weak var niceNameLabel: UITextField!
    @IBOutlet weak var userLocationLabel: UITextField!
    @IBOutlet weak var discriptionLabel: UITextView!
    var image : UIImage!
    let database = CKContainer.default().publicCloudDatabase
    var receiverAnnotationData : AnnotationDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
 
       
        let filter: String! = self.data.postUUID
        print(filter!)
        let e :[String:Any] = ["viewcCount":12]
        db.collection("userPost").document("\(self.data.postUUID)").getDocument{ (data, error) in
             
         
        }
        
        let predicate: NSPredicate = NSPredicate(format: "content = %@", filter)
        let query = CKQuery(recordType: "Note", predicate: predicate)
//
        database.perform(query, inZoneWith: nil) { (records, _) in
            guard var records = records else {return}
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
 
//        CoredataShare.share.loadData()
//        categoryLabel.text = self.data[self.tempIndex.row].Title
//        niceNameLabel.text = self.data[self.tempIndex.row].postNickName
//        userLocationLabel.text = self.data[self.tempIndex.row].postUUID
//        discriptionLabel.text = self.data[self.tempIndex.row].subTitle
        categoryLabel.text = self.data.Title
        niceNameLabel.text = self.data.postNickName
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
    
    @IBAction func deleteMyPost(_ sender: UIButton) {
        let postUUID = self.data.postUUID
        
        
        db.collection("userPost").document(postUUID).delete()
        db.collection("user").document(self.data.postGoolgeName).collection("myPost").document(postUUID).delete()
        self.delegate?.Update(data: data)
    }
    
    
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
