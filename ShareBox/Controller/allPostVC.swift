//
//  allPostVC.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/7.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import CloudKit
import FirebaseStorage
class allPostVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating,UITextFieldDelegate {
    func updateSearchResults(for searchController: UISearchController) {
      
    }
    
    @IBOutlet weak var hidenTopItem: UIView!
    @IBOutlet weak var tableview: UITableView! 
    @IBOutlet weak var serchMap: UITextField!
    @IBOutlet weak var selectCategoryLabel: UILabel!
    let database = CKContainer.default().publicCloudDatabase
    let db = Firestore.firestore()
    var data: [allPostModel] = []
    var tempIndex: IndexPath?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
 

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let allPostcell = tableView.dequeueReusableCell(withIdentifier: "allPostCell", for: indexPath) as! allPostDetail
        let data = self.data[indexPath.row]
        allPostcell.Title.text = data.productName
        allPostcell.subTitle.text = data.userShortLocation
//        allPostcell.likeImage.image = data.likeImage
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(data.postUUID)")
        
        if FileManager.default.fileExists(atPath: url.path){
//            let deCompressData = try!  NSData(contentsOf: url).decompressed(using: .lzma)
//            let deCompressData = try? NSData(contentsOf: url).decompressed(using: .lzma)
            let image = UIImage(contentsOfFile: url.path)
            
//            let Newimage = UIImage(data: image as! Data)
            allPostcell.postImage.image = image
            
        }else{
            let ref = Storage.storage(url: "gs://noteapp-3d428.appspot.com").reference()
            let imageRef = ref.child("images/\(data.postUUID)")
            imageRef.write(toFile: url) { (url, error) in
                if let e = error{
                    print("下載圖檔有錯誤\(e)")
                }else{
                    print("下載成功")
                    
                    let image = UIImage(contentsOfFile: url!.path)
                    //                                        let newImageData = decompressData as Data
                    allPostcell.postImage.image = image
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

           
        allPostcell.buildTime.text = data.buildTime
        allPostcell.viewsCount.text = String(data.viewsCount)
        allPostcell.favoriteCount.text = String(data.favoriteCount)
        
         
        return allPostcell
        
    }
    
    func getCloudKitImage(uuid:String , complite:@escaping (UIImage) -> Void)   {
                  let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("CloudKit").appendingPathComponent("\(uuid)")
              let predicate: NSPredicate = NSPredicate(format: "content = %@", uuid)
                             let query = CKQuery(recordType: "Note", predicate: predicate)

                      self.database.perform(query, inZoneWith: nil) { (records, _) in
                                 guard let records = records else {return}
                                 for record in records{
                                     let asset = record["myphoto"] as! CKAsset
//                                    let imageData = NSData(contentsOf: asset.fileURL!)
                                    let compressedData =  NSData(contentsOf: asset.fileURL!)
                                    try? compressedData?.write(to: url, options: .atomicWrite)
//                                    imageData?.write(to: url, atomically: true)
//                                     let image = UIImage(data: imageData! as Data)
//                                    let image = UIImage(data: compressedData as! Data)
//                                    complite(image!)
                                    DispatchQueue.main.async {
                                        self.tableview.reloadData()
                                    }
                                    
                              }
                  }
          }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
      
        
       queryFirestore()
        queryfavoriteCounts()
    }
   
    
    func updateCount (documentID:Any){
        self.db.collection("userPost").document("\(documentID)").collection("views").addSnapshotListener { (data, error) in
            for i in data!.documents{
                self.db.collection("userPost").document("\(documentID)").updateData(["viewsCount":data!.count])
              
                self.tableview.reloadData()
                
            }
        }
    }
    
    func updateFavoriteCount (documentID:Any){
          self.db.collection("userPost").document("\(documentID)").collection("favoriteCounts").addSnapshotListener { (data, error) in
              for i in data!.documents{
                  self.db.collection("userPost").document("\(documentID)").updateData(["favoriteCounts":data!.count])
                if  self.db.collection("userPost").document("\(documentID)").collection("favoriteCounts") == nil {
                    self.db.collection("userPost").document("\(documentID)").setData(["favoriteCounts":0])
                }
                  self.tableview.reloadData()
              }
          }
      }
    
  func queryFirestore(){
            db.collection("userPost").addSnapshotListener { (query, error) in
                if let error = error{
                    print("query Faild\(error)")
                }
             
                guard let documentChange = query?.documentChanges else {return}
                for change in documentChange{
                    //處理每一筆更新
                    let documentID = change.document.documentID
                     self.updateCount(documentID: documentID)
                    self.updateFavoriteCount(documentID: documentID)
                    if change.type == .added{
                       
                   let postdetail = allPostModel(categoryImage: UIImage(named: "testqq")!,
                    likeImage: UIImage(named: "pointRed")!,
                    buildTime: change.document.data()["postTime"] as? String ?? "N/A",
                    subTitle: change.document.data()["postIntroduction"] as? String ?? "N/A",
                    Title: change.document.data()["postCategory"] as? String ?? "N/A",
                    postGoogleName: change.document.data()["googleName"] as? String ?? "N/A",
                    postNickName: change.document.data()["Name"]as? String ?? "N/A",
                    postUUID: change.document.data()["postUUID"] as? String ?? "N/A" ,
                    postTime: change.document.data()["postTime"] as? String ?? "N/A",
                    viewsCount: change.document.data()["viewsCount"] as? Int ?? 0,
                    productName:change.document.data()["productName"] as? String ?? "N/A",
                    userLocation: change.document.data()["userLocation"] as? String ?? "N/A",
                    userShortLocation:change.document.data()["userShortLocation"] as? String ?? "N/A",
                    favoriteCount: change.document.data()["favoriteCounts"] as? Int ?? 0,
                    mainCategory:change.document.data()["mainCategory"] as? String ?? "N/A")
                        
//let annotation = AnnotationDetail(title: change.document.data()["postCategory"] as? String ?? "N/A",
//Subtitle: change.document.data()["postIntroduction"] as? String ?? "N/A",
//coordinate: annotationCoordinate,
//postIntroduction: change.document.data()["postIntroduction"] as? String ?? "N/A",
//nickName: change.document.data()["Name"] as? String ?? "N/A",
//postCategory: change.document.data()["postCategory"] as? String ?? "N/A",
//userLocation:change.document.data()["userLocation"] as? String ?? "N/A",
//googleName: change.document.data()["googleName"] as? String ?? "N/A",
//postUUID: change.document.data()["postUUID"] as? String ?? "N/A")
// self.mapKitView.addAnnotation(annotation)

                        self.data.append(postdetail)
                        
                        self.tableview.reloadData()
                        
                    }
                    else if change.type == .modified{ //修改
                        if let perPost = self.data.filter({ (perPost) -> Bool in
                            perPost.postUUID == documentID
                        }).first{
                            perPost.viewsCount = change.document.data()["viewsCount"] as! Int
                            perPost.favoriteCount = change.document.data()["favoriteCounts"] as! Int
//                            note.imageName = change.document.data()["imageName"] as? String
//                            if let index = self.data.index(of: perPost){
//                                let indexPath = IndexPath(row: index, section: 0)
//                                self.tableview.reloadRows(at: [indexPath], with: .fade)
                            self.tableview.reloadData()
//                            }
                        }
                        
                    }
                    else if change.type == .removed{ //刪除
                        
                        if let perPost = self.data.filter({ (perPost) -> Bool in
                            perPost.postUUID == documentID
                        }).first{
                            
//                            self.updateFavoriteCount(documentID: perPost.postUUID)
                            
                            
                            //                                perAnnotation.viewsCount = change.document.data()["viewsCount"] as! Int
                            //                            note.imageName = change.document.data()["imageName"] as? String
                            if let index = self.data.index(of: perPost){
                                let indexPath = IndexPath(row: index, section: 0)
//                                self.mapKitView.annotations[indexPath.row]
//                                self.data[indexPath.row]
//                                 self.tableview.reloadRows(at: [indexPath], with: .fade)
                                self.data.remove(at: indexPath.row)
                                self.tableview.reloadData()
                                //
                                
                            }
                        }
                    }
      }
                
    }
    
    //
    }

      func queryfavoriteCounts(){
                db.collection("userPost").addSnapshotListener { (query, error) in
                    if let error = error{
                        print("query Faild\(error)")
                    }
                   
                    guard let query = query else {return}
                    for i in query.documents{
                        let doucumentID = i.documentID
                        self.db.collection("userPost").document(doucumentID).collection("favoriteCounts").addSnapshotListener { (data, error) in
                            guard let data = data else {return}
                           
                            for ii in data.documentChanges{
                                let documentID = ii.document.documentID
                                if ii.type == .removed{
                                    if let perPost = self.data.filter({ (perPost) -> Bool in
                                                                perPost.postUUID == documentID
                                                            }).first{
                                    //                            perPost.favoriteCount = change.document.data()["favoriteCounts"] as! Int
                                                                self.updateFavoriteCount(documentID: perPost.postUUID)
                                                                //                                perAnnotation.viewsCount = change.document.data()["viewsCount"] as! Int
                                                                //                            note.imageName = change.document.data()["imageName"] as? String
                                                                if let index = self.data.index(of: perPost){
                                                                    let indexPath = IndexPath(row: index, section: 0)
                                    //                                self.mapKitView.annotations[indexPath.row]
                                    //                                self.data[indexPath.row]
                                    //                                 self.tableview.reloadRows(at: [indexPath], with: .fade)
//                                                                    self.data.remove(at: indexPath.row)
                                                                    self.tableview.reloadData()
                                                                    //
                                                                    
                                                                }
                                                            }
                                }
                                
                            }
                    }
                    
//                        else if change.type == .modified{ //修改
//                            if let perPost = self.data.filter({ (perPost) -> Bool in
//                                perPost.postUUID == documentID
//                            }).first{
//                                perPost.viewsCount = change.document.data()["viewsCount"] as! Int
//                                perPost.favoriteCount = change.document.data()["favoriteCounts"] as! Int
//    //                            note.imageName = change.document.data()["imageName"] as? String
//    //                            if let index = self.data.index(of: perPost){
//    //                                let indexPath = IndexPath(row: index, section: 0)
//    //                                self.tableview.reloadRows(at: [indexPath], with: .fade)
//                                self.tableview.reloadData()
//    //                            }
//                            }
//
//                        }
//                        else if change.type == .removed{ //刪除
//
//                            if let perPost = self.data.filter({ (perPost) -> Bool in
//                                perPost.postUUID == documentID
//                            }).first{
//    //                            perPost.favoriteCount = change.document.data()["favoriteCounts"] as! Int
//                                self.updateFavoriteCount(documentID: perPost.postUUID)
//                                //                                perAnnotation.viewsCount = change.document.data()["viewsCount"] as! Int
//                                //                            note.imageName = change.document.data()["imageName"] as? String
//                                if let index = self.data.index(of: perPost){
//                                    let indexPath = IndexPath(row: index, section: 0)
//    //                                self.mapKitView.annotations[indexPath.row]
//    //                                self.data[indexPath.row]
//    //                                 self.tableview.reloadRows(at: [indexPath], with: .fade)
//                                    self.data.remove(at: indexPath.row)
//                                    self.tableview.reloadData()
//                                    //
//
//                                }
//                            }
//                        }
          }
                    
        }
        
        //
        }
    func CountViews (){
    
        
        db.collection("userPost").document("D0E8F59E-940A-49C1-92D0-2CF0FCC6FF17").collection("views").addSnapshotListener { (allviewrs, error) in
            
            self.db.collection("userPost").document("D0E8F59E-940A-49C1-92D0-2CF0FCC6FF17").updateData(["viewsCount":allviewrs?.count])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postUUID = self.data[indexPath.row].postUUID
        
      let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        db.collection("userPost").document("\(postUUID)").collection("views").document(myGoogleName).setData(["viww": "view"])
        CountViews()
         
    }
    
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                  
                  if segue.identifier == "allPostDetailBycell"{
                      let detailVcByCell = segue.destination as! allPostDetailBycell
                    if let indexPath = self.tableview.indexPathForSelectedRow{
                        let data = self.data[indexPath.row]
                        detailVcByCell.data = data
                    }
                   
                  }
              }
    @IBAction func oderByViews(_ sender: Any) {
        self.data.removeAll()
        tableview.reloadData()
        
        
    }
    
    @IBAction func oderByTimeStamp(_ sender: Any) {
        queryFirestore()
       
        
    }
    
  
    func favotireCounts (uuid:String){
     
         
         db.collection("userPost").document(uuid).collection("favoriteCounts").addSnapshotListener { (favorite, error) in
             self.db.collection("userPost").document(uuid).updateData(["favoriteCounts":favorite?.count])
         }
     }
    
     

//
        
    
//    @IBAction func swiftSwipeAction(_ sender: UISwipeGestureRecognizer) {
//        UIView.animate(withDuration: 0.6) {
//         self.hidenTopItem.alpha = 1
//          }
//        self.tableview.topAnchor.constraint(equalTo: self.hidenTopItem.bottomAnchor,constant: 0).isActive = true
//         print("down")
//    }
 
//    @IBAction func swipeUP(_ sender: UISwipeGestureRecognizer) {
//        print("UP")
////        UIView.animate(withDuration: 0.3) {
////        self.hidenTopItem.alpha = 1
////            self.tableview.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 0).isActive = true
////         }
//
//
//    }
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//           return true
//       }
  
    @IBAction func searchButton(_ sender: UIButton) {
        
       }
    
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn10: UIButton!
    
    
    @IBAction func btn1(_ sender: Any) {
        initButton()
        btn1.setImage(UIImage(named: "heart.fill"), for: .normal)
//        btn1.backgroundColor = .gray
        btn1.alpha = 0.6
        selectCategoryLabel.text = "btn1"
        
    }
    @IBAction func btn2(_ sender: Any) {
        initButton()
               selectCategoryLabel.text = "btn2"
    }
    @IBAction func btn3(_ sender: Any) {
        initButton()
    }
    @IBAction func btn4(_ sender: Any) {
        initButton()
    }
    @IBAction func btn5(_ sender: Any) {
        initButton()
    }
    @IBAction func btn6(_ sender: Any) {
        initButton()
    }
    @IBAction func btn7(_ sender: Any) {
        initButton()
    }
    @IBAction func btn8(_ sender: Any) {
        initButton()
    }
    @IBAction func btn9(_ sender: Any) {
        initButton()
    }
    @IBAction func btn10(_ sender: Any) {
        initButton()
    }
    
    func initButton(){
         Buttoninit(btn1: btn1, btn2: btn2, btn3: btn3, btn4: btn4, btn5: btn5, btn6: btn6, btn7: btn7, btn8: btn8, btn9: btn9, btn10: btn10)
    }
    
    
}
 
