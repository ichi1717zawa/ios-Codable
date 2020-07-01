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
class allPostVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating,UITextFieldDelegate,UIGestureRecognizerDelegate {
    let myUID : String! = Auth.auth().currentUser?.uid
    func updateSearchResults(for searchController: UISearchController) {
      
    }
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var hidenTopItem: UIView!
    @IBOutlet weak var tableview: UITableView! 
    @IBOutlet weak var serchMap: UITextField!
    @IBOutlet weak var selectCategoryLabel: UILabel!
    let database = CKContainer.default().publicCloudDatabase
    let db = Firestore.firestore()
    var data: [allPostModel] = []
    var tempIndex: IndexPath?
    var tableviewOringinminY :CGFloat!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
   
 

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
          let allPostcell = tableView.dequeueReusableCell(withIdentifier: "allPostCell", for: indexPath) as! allPostDetail
        let data = self.data[indexPath.row]
        allPostcell.Title.text = data.productName
        allPostcell.subTitle.text = data.userShortLocation
        allPostcell.introduction.text = data.subTitle
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
                         var imageRef = ref.child("images/\(data.postUUID)")
            
         
            imageRef.write(toFile: url) { (url, error) in
                if let e = error{
                    print("下載圖檔有錯誤\(e)")
//                    self.keepDownLoad( uuid: data.postUUID)
                }else{
                    print("下載成功")
                    let ciimage = CIImage(contentsOf: url!)
//                    let image = UIImage(contentsOfFile: url!.path)
                    let image = UIImage(ciImage: ciimage!)
                    allPostcell.postImage.image = image
                }
            }
        }
        allPostcell.buildTime.text = data.buildTime
        allPostcell.viewsCount.text = String(data.viewsCount)
        allPostcell.favoriteCount.text = String(data.favoriteCount)
        return allPostcell
    }
    
    func keepDownLoad(uuid:String ){
          let ref = Storage.storage(url: "gs://noteapp-3d428.appspot.com").reference()
        
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(uuid)")
        while FileManager.default.fileExists(atPath: url.path) == false {
           var imageRef = ref.child("images/\(uuid)")
             imageRef.write(toFile: url) { (url, error) in
                if let e = error {
                    print("keep error")
                }
                else{
                    print("success")
                }
            }
        }
        
    }

    
//    func getCloudKitImage(uuid:String , complite:@escaping (UIImage) -> Void)   {
//                  let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("CloudKit").appendingPathComponent("\(uuid)")
//              let predicate: NSPredicate = NSPredicate(format: "content = %@", uuid)
//                             let query = CKQuery(recordType: "Note", predicate: predicate)
//
//                      self.database.perform(query, inZoneWith: nil) { (records, _) in
//                                 guard let records = records else {return}
//                                 for record in records{
//                                     let asset = record["myphoto"] as! CKAsset
////                                    let imageData = NSData(contentsOf: asset.fileURL!)
//                                    let compressedData =  NSData(contentsOf: asset.fileURL!)
//                                    try? compressedData?.write(to: url, options: .atomicWrite)
////                                    imageData?.write(to: url, atomically: true)
////                                     let image = UIImage(data: imageData! as Data)
////                                    let image = UIImage(data: compressedData as! Data)
////                                    complite(image!)
//                                    DispatchQueue.main.async {
//                                        self.tableview.reloadData()
//                                    }
//
//                              }
//                  }
//          }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
  
    var refreshControl:UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
     
       queryFirestore()
        queryfavoriteCounts()
        checkDataExsist()
    }
    
       
     
    func checkDataExsist(){
       
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
    db.collection("userPost").order(by: "timeStamp").addSnapshotListener { (query, error) in
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
                   let postdetail = allPostModel(categoryImage: UIImage(named: "photo.fill")!,
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
                    mainCategory:change.document.data()["mainCategory"] as? String ?? "N/A",
                    subCategory: change.document.data()["postCategory"] as? String ?? "N/A",
                    posterUID: change.document.data()["posterUID"] as? String ?? "N/A")
                        
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
                         
//                        self.data.append(postdetail)
                        self.data.insert(postdetail, at: 0)
                        
 
                            let indexPath = IndexPath(row: 0, section: 0)
                             self.tableview.insertRows(at: [indexPath], with: .left)
 
                       
//                        self.tableview.reloadRows(at: [indexPath], with: .automatic)
//                        self.tableview.reloadData()
                         
                        
                    }
                        
                    else if change.type == .modified{ //修改
                        if let perPost = self.data.filter({ (perPost) -> Bool in
                            perPost.postUUID == documentID
                        }).first{
                            perPost.viewsCount = change.document.data()["viewsCount"] as! Int
                            perPost.favoriteCount = change.document.data()["favoriteCounts"] as! Int
//                            note.imageName = change.document.data()["imageName"] as? String
                            if let index = self.data.firstIndex(of: perPost){
                                let indexPath = IndexPath(row: index, section: 0)
                                self.tableview.reloadRows(at: [indexPath], with: .fade)
//                            self.tableview.reloadData()
                           
                            }
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
                                self.tableview.deleteRows(at: [indexPath], with: .fade)
//                                self.tableview.reloadData()
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
         tableView.deselectRow(at: indexPath, animated: false)
        let postUUID = self.data[indexPath.row].postUUID
        
//      let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        db.collection("userPost").document("\(postUUID)").collection("views").document(myUID).setData(["viww": "view"])
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
                 if segue.identifier == "tappMapByAllpostButton"{
                     let  MapData = segue.destination as! MapVC
                    MapData.mainCategory =  selectCategoryLabel.text
                    MapData.Adress = serchMap.text
                    
                }
                
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
     @IBOutlet weak var tableviewTopAnchor: NSLayoutConstraint!
    
    @IBAction func swipeUP(_ sender: UISwipeGestureRecognizer) {
        print("UP")
        UIView.animate(withDuration: 0.3) { 
//            self.tableview.topAnchor.constraint(equalTo:
//                self.view.topAnchor,constant: (self.navigationController?.navigationBar.frame.height)!).isActive = true
            self.tableviewTopAnchor.constant =  -self.hidenTopItem.frame.height
            self.tableview.frame.origin.y = super.view.frame.origin.y + (self.navigationController?.navigationBar.frame.height)!
//            self.tableview.frame.size.height = self.view.frame.height
            self.hidenTopItem.alpha = 0
            self.categoryControllButtenView.center.x = super.view.center.x
            self.searchButton.alpha = 0
            self.initButton()
        }
    }
    

    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        print("Down")
        UIView.animate(withDuration: 0.3) {
            self.hidenTopItem.alpha = 1
            self.tableviewTopAnchor.constant =  0
            self.tableview.frame.origin.y = self.hidenTopItem.frame.maxY
             
             
        }
        
    }
    
    
//    @IBOutlet weak var tableViewTopAncorLine: NSLayoutConstraint!
    @IBOutlet weak var bottonLine: UIView!
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
           return true
       }
   
    @IBAction func searchButton(_ sender: UIButton) {
         
        if self.serchMap.text?.isEmpty == false && selectCategoryLabel.text?.isEmpty == false {
           performSegue(withIdentifier: "tappMapByAllpostButton", sender: nil)
            
        } else if self.serchMap.text?.isEmpty == true && selectCategoryLabel.text?.isEmpty == false  {
            AlertMessage = "地址尚未填寫"
             saveTextfield(ShowAlertMessage: AlertMessage)
        }
        else if self.serchMap.text?.isEmpty == false && selectCategoryLabel.text?.isEmpty == true{
            AlertMessage = "種類尚未選擇"
            saveTextfield(ShowAlertMessage: AlertMessage)
        }else{
            AlertMessage = "請填寫地址並選擇種類"
              saveTextfield(ShowAlertMessage: AlertMessage)
            } 
         
       }
    
    func saveTextfield(ShowAlertMessage show:String ) {
            let alerController = UIAlertController(title: nil, message: show, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "確定", style: .default, handler: nil)
             alerController.addAction(OKAction)
             present(alerController,animated: true)
          }
    var AlertMessage:String!
    
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
    
  // ["物品種類","書籍文具票券","3c產品","玩具電玩","生活居家與家電","影視音娛樂","飲品食品","保養彩妝","男裝配件","女裝婦幼"]
    
//"ALL"
//"書籍文具票券"
//"3c產品"
//"玩具電玩"
//"生活居家與家電"
//"影視音娛樂"
//"飲品食品"
//"保養彩妝"
//"男裝配件"
//"女裝婦幼"
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(true)
            self.navigationController?.isNavigationBarHidden = true
           categoryControllButtenView.center.x = super.view.center.x
           searchButton.alpha = 0
           initButton()
          
       }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
         self.navigationController?.isNavigationBarHidden = false
    }
    

    @IBAction func tap(_ sender: Any) {
       
    }
 
    func pressCategoryButton(button:UIButton,categoryName:String){
        UIView.animate(withDuration: 0.3) {
            self.initButton()
            
                 self.categoryControllButtenView.frame.origin.x = super.view.frame.origin.x + 10
                 self.searchButton.alpha = 1
            button.setImage(UIImage(named: categoryName), for: .normal)
//                 button.alpha = 0.6
             }
    }
 
    @IBOutlet weak var categoryControllButtenView: UIStackView!
    @IBAction func btn1(_ sender: Any) {
       
//       self.jio.frame.origin.x = super.view.frame.origin.x
        selectCategoryLabel.text = "ALL" 
        pressCategoryButton(button:btn1, categoryName: "ALL彩")
        
    }
    @IBAction func btn2(_ sender: Any) {
//        initButton()
        selectCategoryLabel.text = "書籍文具票券"
        pressCategoryButton(button:btn2, categoryName: "書籍文具票券彩")
    }
    @IBAction func btn3(_ sender: Any) {
//        initButton()
        selectCategoryLabel.text = "3c產品"
        pressCategoryButton(button: btn3, categoryName: "3c產品彩")
    }
    @IBAction func btn4(_ sender: Any) {
//        initButton()
        selectCategoryLabel.text = "玩具電玩"
        pressCategoryButton(button: btn4, categoryName: "玩具電玩彩")
    }
    @IBAction func btn5(_ sender: Any) {
//        initButton()
        selectCategoryLabel.text = "生活居家與家電"
        pressCategoryButton(button: btn5, categoryName: "生活居家與家電彩")
    }
    @IBAction func btn6(_ sender: Any) {
//        initButton()
        selectCategoryLabel.text = "影視音娛樂"
        pressCategoryButton(button: btn6, categoryName: "影視音娛樂彩")
    }
    @IBAction func btn7(_ sender: Any) {
//        initButton()
        selectCategoryLabel.text =  "飲品食品"
        pressCategoryButton(button: btn7, categoryName: "飲品食品彩")
    }
    @IBAction func btn8(_ sender: Any) {
//        initButton()
        selectCategoryLabel.text = "保養彩妝"
        pressCategoryButton(button: btn8, categoryName: "保養彩妝彩")
    }
    @IBAction func btn9(_ sender: Any) {
//        initButton()
        selectCategoryLabel.text = "男裝配件"
        pressCategoryButton(button: btn9, categoryName: "男裝配件彩")
    }
    @IBAction func btn10(_ sender: Any) {
//        initButton()
        selectCategoryLabel.text = "女裝婦幼"
        pressCategoryButton(button: btn10, categoryName: "女裝婦幼彩")
    }
    
    func initButton(){
        Buttoninit.init(btn1: btn1, btn2: btn2, btn3: btn3, btn4: btn4, btn5: btn5, btn6: btn6, btn7: btn7, btn8: btn8, btn9: btn9, btn10: btn10)
        
    }
    
    @IBAction func scrollViewToTop(_ sender: UIButton) {
        let indexpath = IndexPath(row: 0, section: 0)
        self.tableview.scrollToRow(at: indexpath, at: .top, animated: true)
              UIView.animate(withDuration: 0.3) {
        self.hidenTopItem.alpha = 1
         self.tableview.frame.origin.y = self.hidenTopItem.frame.maxY
        }
    }
    
    
}
 
