 

import UIKit
import MapKit
import Firebase
import GoogleSignIn
import CloudKit
import FirebaseStorage
class allPostDetailBycell: UIViewController  {
    @IBOutlet weak var discriptionLabel: UILabel!
    var data : allPostModel!
    var db = Firestore.firestore()
    var annotation : MKAnnotation?
    var tempIndex : IndexPath!
    var postUUID : String?
    var postGmail :String?
    var posterUID : String?
    let myUID = Auth.auth().currentUser?.uid
    @IBOutlet weak var sendMessageOutlet: UIButton!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postimage: UIImageView!
//    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var MaincategoryLabel: UILabel!
    @IBOutlet weak var SubcategoryLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
//    @IBOutlet weak var discriptionLabel: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    var image : UIImage!
    let database = CKContainer.default().publicCloudDatabase
    var receiverAnnotationData : AnnotationDetail?
    var  postGoolgeName :String?
    var postNickName:String?
//    let myGmail = GIDSignIn.sharedInstance()?.currentUser.profile.email
    override func viewDidLoad() {
        super.viewDidLoad()
        checkImageExsist.share.checkImage(postUUID: self.postUUID ?? self.data.postUUID, postimage: postimage, maskView: self.maskView  , activityIndicator: self.activityIndicator)
        
        queryData()
       
        let filter: String! =  self.postUUID ?? self.data.postUUID
        print(filter!)
        
        self.db.collection("userPost").whereField("postUUID", isEqualTo: self.postUUID ?? self.data.postUUID  ).getDocuments { (data, error) in
            if let e = error{
                print("錯誤了啦！！！！！！！")
                print(e)
            }
           
            guard let data = data else {return}
            for data in data.documents{
        
                    
                 
//                let filePath2 = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last?.appendingPathComponent("\(self.postUUID).jpg" ?? "\(self.data.postUUID).jpg")
//            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("CloudKit").appendingPathComponent("\(self.postUUID ?? self.data.postUUID)")
           
                self.SubcategoryLabel.text = data.data()["postCategory"] as? String
                self.nickNameLabel.text = data.data()["Name"] as? String
                self.userLocationLabel.text = data.data()["userLocation"] as? String
//                self.discriptionLabel.text = data.data()["postIntroduction"] as? String
                 self.discriptionLabel.text = data.data()["postIntroduction"] as? String
                self.productName.text = data.data()["productName"] as? String
                self.postGoolgeName = data.data()["googleName"] as? String
                self.postNickName = data.data()["Name"] as? String
                self.postGmail = data.data()["gmail"] as? String
                self.posterUID = data.data()["posterUID"] as? String
                self.MaincategoryLabel.text =  data.data()["mainCategory"] as? String 
                 
                if data.data()["posterUID"] as? String != self.myUID{
                    print("same gmail")
                    UIView.animate(withDuration: 0.3) {
                        self.favoriteButton.alpha = 1
                        self.sendMessageOutlet.alpha = 1
                    }
                }
                
                
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
        
           
    }
     
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(true)
         self.navigationController?.isNavigationBarHidden = false
     }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(true)
             self.navigationController?.isNavigationBarHidden = true
       }
    
    @IBAction func sendMessage(_ sender: Any) {
//        var myNickName :String!
         print("click sendMessageButton")

        
//        performSegue(withIdentifier: "personalMessageWithMap", sender: nil)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "personalMessageWithCell"{
              let personalMessage = segue.destination as! chatTable
            personalMessage.otherUID = self.posterUID
//            personalMessage.otherGoogleName = self.posterUID ?? self.data.postGoolgeName
            personalMessage.otherNickName =  self.postNickName ??  self.data.postNickName
            personalMessage.self.navigationController?.navigationBar.backgroundColor = .red
          }
          else if segue.identifier == "showImageSegue"{
            let showImage = segue.destination as! lookImage
            showImage.myimage = self.postimage.image
            
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
        
//         let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        if self.favoriteButton.currentTitle == "inDatabase" || self.favoriteButton.currentImage?.accessibilityIdentifier == "heart-r"{
            self.favoriteButton.setImage(UIImage(named:"heart"), for: .normal)
            self.db.collection("userPost").document(self.postUUID ?? self.data.postUUID).collection("favoriteCounts").document(myUID!).delete()
            self.db.collection("user").document(myUID!).collection("favoriteList").document(self.postUUID ?? self.data.postUUID).delete()
        }else if self.favoriteButton.currentTitle != "notInDatabase" || self.favoriteButton.currentImage?.accessibilityIdentifier == "heart"{
            self.favoriteButton.setImage(UIImage(named:"heart-r"), for: .normal)
            self.db.collection("userPost").document(self.postUUID ?? self.data.postUUID).collection("favoriteCounts").document(myUID!).setData(["favorite": "favorite"])
            self.db.collection("user").document(myUID!).collection("favoriteList").document(self.postUUID ?? self.data.postUUID).setData(["Myfavorite": "Null"])
        }
        //        if segue.identifier == "allPostDetailBycell"{
        //                            let detailVcByCell = segue.destination as! allPostDetailBycell
//                let pointInTable: CGPoint = sender.convert(CGPoint.zero, to: self.tableview)
//                guard let  indexPath = self.tableview.indexPathForRow(at: pointInTable)  else {return}
 
//                favotireCounts(uuid: self.data[indexPath.row].postUUID)
    }
    
    
    func queryData(){
//         let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
//        guard let myuid = Auth.auth().currentUser?.uid else {return}
        self.db.collection("user").document(myUID!).collection("favoriteList").addSnapshotListener { (query, error) in
            guard let query = query else {return}
            for i in query.documents{
                print(i.documentID)
                if i.documentID == self.postUUID ?? self.data.postUUID {
                    self.favoriteButton.setImage(UIImage(named:"heart-r"), for: .normal)
                    self.favoriteButton.setTitle("inDatabase", for: .normal)
                }
                else{
                    self.favoriteButton.setTitle("notInDatabase", for: .normal)
                    print("nonono")
                }
            }
        }
    }
    
    @IBAction func backToRootView(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
   
  
   
    
 }
