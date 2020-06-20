 

import UIKit
import MapKit
import Firebase
import GoogleSignIn
import CloudKit
import FirebaseStorage
class allPostDetailBycell: UIViewController      {
    var data : allPostModel!
    var db = Firestore.firestore()
    var annotation : MKAnnotation?
    var tempIndex : IndexPath!
    var postUUID : String?
    var postGmail :String?
    @IBOutlet weak var sendMessageOutlet: UIButton!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postimage: UIImageView!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var categoryLabel: UITextField!
    @IBOutlet weak var niceNameLabel: UITextField!
    @IBOutlet weak var userLocationLabel: UITextField!
    @IBOutlet weak var discriptionLabel: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    var image : UIImage!
    let database = CKContainer.default().publicCloudDatabase
    var receiverAnnotationData : AnnotationDetail?
    var  postGoolgeName :String?
    var postNickName:String?
    override func viewDidLoad() {
        super.viewDidLoad()
         let myGmail = GIDSignIn.sharedInstance()?.currentUser.profile.email
        queryData()
       
        let filter: String! =  self.postUUID ?? self.data.postUUID
        print(filter!)
        
        self.db.collection("userPost").whereField("postUUID", isEqualTo: self.postUUID ?? self.data.postUUID  ).getDocuments { (data, error) in
            if let e = error{
                print(e)
            }
           
            guard let data = data else {return}
            for data in data.documents{
                guard   let filePath2 = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("\(self.postUUID ?? self.data.postUUID)") else {return}
                    
                 
//                let filePath2 = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last?.appendingPathComponent("\(self.postUUID).jpg" ?? "\(self.data.postUUID).jpg")
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("CloudKit").appendingPathComponent("\(self.postUUID ?? self.data.postUUID)")
                if FileManager.default.fileExists(atPath: filePath2.path){
                    self.maskView.alpha = 0
                     
//                    let compressedData = try? NSData(contentsOfFile: url.path)?.decompressed(using: .lzma)
//                    let myImage = UIImage(data: compressedData as! Data )
                    let image = UIImage(contentsOfFile: filePath2.path)
                    self.postimage.image = image
                }else{
                    self.maskView.alpha = 0.5
                          self.activityIndicator.startAnimating()
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
                    let imageRef = ref.child("images/\(self.postUUID ?? self.data.postUUID)")
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
                                        self.postimage.image = image
                                        self.maskView.alpha = 0.0
                                       self.activityIndicator.stopAnimating()
                                        
                                          
                                       }
                                   }
                }
                self.categoryLabel.text = data.data()["postCategory"] as? String
                self.niceNameLabel.text = data.data()["Name"] as? String
                self.userLocationLabel.text = data.data()["userLocation"] as? String
                self.discriptionLabel.text = data.data()["postIntroduction"] as? String
                self.productName.text = data.data()["productName"] as? String
                self.postGoolgeName = data.data()["googleName"] as? String
                self.postNickName = data.data()["Name"] as? String
                self.postGmail = data.data()["gmail"] as? String
                print(data.data()["gmail"] as? String)
                if data.data()["gmail"] as? String == myGmail{
                    print("same gmail")
                    self.favoriteButton.alpha = 0
                    self.sendMessageOutlet.alpha = 0 }
            }
        }
//
       
 
//        CoredataShare.share.loadData()
//        categoryLabel.text = self.data[self.tempIndex.row].Title
//        niceNameLabel.text = self.data[self.tempIndex.row].postNickName
//        userLocationLabel.text = self.data[self.tempIndex.row].postUUID
//        discriptionLabel.text = self.data[self.tempIndex.row].subTitle
        
//        categoryLabel.text = self.data.Title
//        niceNameLabel.text = self.data.postNickName
//        userLocationLabel.text = self.data.userLocation
//        discriptionLabel.text = self.data.subTitle
//        productName.text = self.data.productName
        
//        self.receiverAnnotationData = receiveAnnotation
        
              if self.postGmail == myGmail{
                  
               
                 
              }
    }
     

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      
        
    }
    @IBAction func sendMessage(_ sender: Any) {
//        var myNickName :String!
         print("click sendMessageButton")

        
//        performSegue(withIdentifier: "personalMessageWithMap", sender: nil)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "personalMessageWithCell"{
              let personalMessage = segue.destination as! chatTable
            personalMessage.otherGoogleName = self.postGoolgeName ?? self.data.postGoolgeName
            personalMessage.otherNickName =  self.postNickName ??  self.data.postNickName
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
    //    func getLocation(){
//
//
//    }
    
    @IBAction func favoriteButtonClick(_ sender: UIButton) {
         let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        if self.favoriteButton.currentTitle == "inDatabase"{
            self.favoriteButton.setImage(UIImage(named:"heart"), for: .normal)
            self.db.collection("userPost").document(self.postUUID ?? self.data.postUUID).collection("favoriteCounts").document(myGoogleName).delete()
            self.db.collection("user").document(myGoogleName).collection("favoriteList").document(self.postUUID ?? self.data.postUUID).delete()
            
        }else{
            self.favoriteButton.setImage(UIImage(named:"heart.fill"), for: .normal)
            self.db.collection("userPost").document(self.postUUID ?? self.data.postUUID).collection("favoriteCounts").document(myGoogleName).setData(["favorite": "favorite"])
            self.db.collection("user").document(myGoogleName).collection("favoriteList").document(self.postUUID ?? self.data.postUUID).setData(["Myfavorite": "Null"])
        }
        //        if segue.identifier == "allPostDetailBycell"{
        //                            let detailVcByCell = segue.destination as! allPostDetailBycell
//                let pointInTable: CGPoint = sender.convert(CGPoint.zero, to: self.tableview)
//                guard let  indexPath = self.tableview.indexPathForRow(at: pointInTable)  else {return}
 
//                favotireCounts(uuid: self.data[indexPath.row].postUUID)
    }
    
    
    func queryData(){
         let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        self.db.collection("user").document(myGoogleName).collection("favoriteList").addSnapshotListener { (query, error) in
            guard let query = query else {return}
            for i in query.documents{
                print(i.documentID)
                if i.documentID == self.postUUID ?? self.data.postUUID {
                    self.favoriteButton.setImage(UIImage(named:"heart.fill"), for: .normal)
                    self.favoriteButton.setTitle("inDatabase", for: .normal)
                }
                else{
                    print("nonono")
                }
            }
        }
    }
    
    
}
