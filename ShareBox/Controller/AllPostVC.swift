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
//import UserNotificationsUI
class allPostVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating,UITextFieldDelegate,UIGestureRecognizerDelegate {
    let myUID : String! = Auth.auth().currentUser?.uid
    func updateSearchResults(for searchController: UISearchController) {
      
    }
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var hidenTopItem: UIView!
    @IBOutlet weak var tableview: UITableView! 
    @IBOutlet weak var serchMap: UITextField!
    @IBOutlet weak var selectCategoryLabel: UILabel!
    @IBOutlet weak var backToTopBTN: UIButton!
    @IBOutlet weak var tableviewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var categoryControllButtenView: UIStackView!
    
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
    
    let AnnotationData:[AnnotationDetail] = []
    let database = CKContainer.default().publicCloudDatabase
    var db = Firestore.firestore()
    var data: [allPostModel] = []
    var tempIndex: IndexPath?
    var tableviewOringinminY :CGFloat!
    var firstIndex : IndexPath!
    var favoriteListName : [String] = []
    var lastDocument : QueryDocumentSnapshot?
    var listener : ListenerRegistration?
    var AlertMessage:String!
    var refreshControl:UIRefreshControl!
    var lastTime : String?
    var fetchOldButtonTopAnchor : NSLayoutConstraint!
    var fetchNewButtonTopAnchor : NSLayoutConstraint!
    
    var fetchNewButton : UIButton! = UIButton()
    var fetchOldButton : UIButton! = UIButton()
    var refreshCOntrol:UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       refreshControl = UIRefreshControl()
        
        self.tableview.tableFooterView?.addSubview(refreshControl)
        
        print("登入時的帳號\(Auth.auth().currentUser?.uid)")
        selectCategoryLabel.text = ""
        queryFirestore()
        queryfavoriteCounts()
         
        self.view.addSubview(fetchNewButton)
         
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //        updateDataBaseCounts(Currenttime: self.currentTime())
        self.navigationController?.isNavigationBarHidden = true
        UIView.animate(withDuration: 0.3) {
            //
            self.categoryControllButtenView.center.x = super.view.center.x
            self.searchButton.alpha = 0
        }
        initButton()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
     //MARK: -> numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
     //MARK: -> cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        getCatcheFaforiteList(myUID: "\(Auth.auth().currentUser?.uid ?? "N/A")") { (data) in
            print(data)
        }
        if let first = tableView.indexPathsForVisibleRows?.first  {
                firstIndex = first
        }
          let allPostcell = tableView.dequeueReusableCell(withIdentifier: "allPostCell", for: indexPath) as! allPostDetail
        let data = self.data[indexPath.row]
//        getCatcheFaforiteList(myUID: myUID) { (postUUID) in
//            print("qwe")
//        }
       
//        if let perpost = self.data.filter({ (perpost) -> Bool in
//            perpost.postUUID == favoriteListName.first
//        }).first{
//            print("get")
//        }
        allPostcell.Title.text = data.productName
        allPostcell.subTitle.text = data.userShortLocation
        allPostcell.introduction.text = data.subTitle
//        allPostcell.likeButton.setImage(UIImage(named: "a4"), for: .normal)
//        allPostcell.likeImage.image = data.likeImage
        let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("Caches").appendingPathComponent("\(data.postUUID)")
        if FileManager.default.fileExists(atPath: url.path){
//            let deCompressData = try!  NSData(contentsOf: url).decompressed(using: .lzma)
//            let deCompressData = try? NSData(contentsOf: url).decompressed(using: .lzma)
            let image = UIImage(contentsOfFile: url.path)
//            let Newimage = UIImage(data: image as! Data)
            allPostcell.postImage.image = image
        }else  {
                let ref = Storage.storage(url: "gs://noteapp-3d428.appspot.com").reference()
            let imageRef = ref.child("images/\(data.postUUID)")
               imageRef.write(toFile: url) { (url, error) in
                if error != nil{
                    print("從Firebase下載圖檔有錯誤")
                    self.getCloudKitImage(uuid: data.postUUID) { (image) in
                        DispatchQueue.main.async {
                            allPostcell.postImage.image = image
                            print("成功從cloudkit下載圖片")
                        }
                    }
//                    self.keepDownLoad( uuid: data.postUUID)
                }else{
                    print("從Firebase下載成功")
//                    let ciimage = CIImage(contentsOf: url!)
//                    let image = UIImage(contentsOfFile: url!.path)
                    guard let ciimage = CIImage(contentsOf: url!) else {return}
                    let image = UIImage(ciImage: ciimage)
                    allPostcell.postImage.image = image
                }
            }
        }
        allPostcell.buildTime.text = data.buildTime
        allPostcell.viewsCount.text = String(data.viewsCount)
        allPostcell.favoriteCount.text = String(data.favoriteCount)
        return allPostcell
    }
     //MARK: -> didSelectRowAt
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.tableview.deselectRow(at: indexPath, animated: false)
            let postUUID = self.data[indexPath.row].postUUID
            
    //      let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
            db.collection("userPost").document("\(postUUID)").collection("views").document(myUID).setData(["viww": "view"])
            CountViews()
             
        }
    
    //MARK: -> getfavoriteListName
    func getfavoriteListName(){
        self.db.collection("user")
            .document("\(Auth.auth().currentUser?.uid ?? "N/A")")
            .collection("favoriteList")
            .getDocuments(source: .cache) { (data, error) in
            
            if let data = data?.documents  {
                
                for postUUID in data{
                    //                                       print(postUUID.documentID)
                    let postUUID =  postUUID.documentID  as String
                    //                                        print(postUUID)
                    self.favoriteListName.append(postUUID)
                    
                }
            }
        }
    }

 //MARK: -> getCloudKitImage
    func getCloudKitImage(uuid:String , complite:@escaping (UIImage) -> Void)   {
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! .appendingPathComponent("\(uuid)")
                  let predicate: NSPredicate = NSPredicate(format: "content = %@", uuid)
                           let query = CKQuery(recordType: "Note", predicate: predicate)
                           self.database.perform(query, inZoneWith: nil) { (records, error) in
                            if let error = error{
                                print("讀取CloudKit檔案失敗\(error)")
                            }
                                     guard let records = records else {return}
                                     for record in records{
                                         let asset = record["myphoto"] as! CKAsset
                                        let imageData = NSData(contentsOf: asset.fileURL!)
//                                        let compressedData =  NSData(contentsOf: asset.fileURL!)
//                                        try? compressedData?.write(to: url, options: .atomicWrite)
                                        imageData?.write(to: url, atomically: true)
                                         let image = UIImage(data: imageData! as Data)
                                        complite(image!)
    //                                    let image = UIImage(data: compressedData as! Data)
    //                                    complite(image!)
                                        DispatchQueue.main.async {
                                            self.tableview.reloadData()
                                        }

                                  }
                      }
              }
     //MARK: -> getCatcheFaforiteList
     func getCatcheFaforiteList ( myUID:String,complete:@escaping (String) -> Void ) {
            self.db.collection("userPost").document("\(myUID)").collection("favoriteCounts").getDocuments(source: .cache) { (data, error) in
                if let data = data?.documents {
                    for postUUID in data{
                        let postUUID =  postUUID.documentID  as String
                        complete(postUUID)
                    }
                }
            }
        }
       //MARK: -> updateCount
        func updateCount (documentID:Any){
            self.db.collection("userPost").document("\(documentID)").collection("views").addSnapshotListener { (data, error) in
                if error != nil{
                    return
                }
                for _ in data!.documents{
                    self.db.collection("userPost").document("\(documentID)").updateData(["viewsCount":data!.count])
                  
                    self.tableview.reloadData()
                    
                }
            }
        }
       //MARK: -> updateFavoriteCount
        func updateFavoriteCount (documentID:Any){
            
            self.db.collection("userPost").document("\(documentID)").collection("favoriteCounts").addSnapshotListener { (data, error) in
                if  error  != nil {
                    return
                }
                
                for _ in data!.documents{
                      self.db.collection("userPost").document("\(documentID)").updateData(["favoriteCounts":data!.count])
    //                if  self.db.collection("userPost").document("\(documentID)").collection("favoriteCounts") == nil {
    //                    self.db.collection("userPost").document("\(documentID)").setData(["favoriteCounts":0])
    //                }
                      self.tableview.reloadData()
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
     
    func getNewstPost(date:Date){
        db.collection("userPost").whereField("timeStamp", isGreaterThanOrEqualTo: date).getDocuments { (query, error) in
                                if let error = error{
                                    print("query Faild\(error)")
                                }
                         guard let myquest = query else {return}
                         if let querylast = myquest.documents.last{
                             self.lastDocument = querylast
                         }
                    guard let documentChange = query else {return}
                    for change in documentChange.documents{
                                    //處理每一筆更新
                                    let documentID = change.documentID
                                     self.updateCount(documentID: documentID)
                                    self.updateFavoriteCount(documentID: documentID)
                                   
                                   let postdetail = allPostModel(categoryImage: UIImage(named: "photo.fill")!,
                                    likeImage: UIImage(named: "pointRed")!,
                                    buildTime: change.data()["postTime"] as? String ?? "N/A",
                                    subTitle: change.data()["postIntroduction"] as? String ?? "N/A",
                                    Title: change.data()["postCategory"] as? String ?? "N/A",
                                    postGoogleName: change.data()["googleName"] as? String ?? "N/A",
                                    postNickName: change.data()["Name"]as? String ?? "N/A",
                                    postUUID: change.data()["postUUID"] as? String ?? "N/A" ,
                                    postTime: change.data()["postTime"] as? String ?? "N/A",
                                    viewsCount: change.data()["viewsCount"] as? Int ?? 0,
                                    productName:change.data()["productName"] as? String ?? "N/A",
                                    userLocation: change.data()["userLocation"] as? String ?? "N/A",
                                    userShortLocation:change.data()["userShortLocation"] as? String ?? "N/A",
                                    favoriteCount: change.data()["favoriteCounts"] as? Int ?? 0,
                                    mainCategory:change.data()["mainCategory"] as? String ?? "N/A",
                                    subCategory: change.data()["postCategory"] as? String ?? "N/A",
                                    posterUID: change.data()["posterUID"] as? String ?? "N/A",
                                    longPostTime: change.data()["longPostTime"] as? String ?? "N/A")
                                         self.data.insert(postdetail, at: 0)
                                        self.getfavoriteListName()
                                        self.tableview.reloadData()
                }
        }
    }
    func updateDataBaseCounts(Currenttime:String){
        //2020:08:08 02:05:25
        let time = self.lastDocument?.data()["longPostTime"] as? String
       
        let myDate = Date()
        db.collection("userPost").whereField("longPostTime", isGreaterThan: time!).addSnapshotListener { (query, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let query = query?.documentChanges else {return}
            for change in query{
                if change.type == .added{
                    print("yes")
                    self.getNewstPost(date: myDate)
                }
            }
        }
    }
    
    
 //MARK: -> queryFirestore 獲取資料
  func queryFirestore(){
    
    let myref =  db.collection("userPost").order(by: "timeStamp",descending: true ).limit(to: 10).getDocuments { (query, error) in
        if let error = error{  print("query Faild\(error)");  return  }
        
        guard let myquest = query else {return}
        if let querylast = myquest.documents.last{
            self.lastDocument = querylast
        }

                guard let documentChange = query?.documentChanges else {return}
        
                for change in documentChange{
                  
                    //處理每一筆更新
                    let documentID = change.document.documentID
                    self.updateCount(documentID: documentID)
                    self.updateFavoriteCount(documentID: documentID)
                    
                    if change.type == .added{
                    let postdetail = allPostModel.QueryData(Document: change)
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
//                        self.data.insert(postdetail, at: 0)
                        self.getfavoriteListName()
                        self.tableview.reloadData()
                      
                    }else if change.type == .modified{ //修改
                        if let perPost = self.data.filter({ (perPost) -> Bool in
                            perPost.postUUID == documentID
                        }).first{
                            perPost.viewsCount = change.document.data()["viewsCount"] as! Int
                            perPost.favoriteCount = change.document.data()["favoriteCounts"] as! Int
//                            note.imageName = change.document.data()["imageName"] as? String
                            if let index = self.data.firstIndex(of: perPost){
                                let indexPath = IndexPath(row: index, section: 0)
                                self.tableview.reloadRows(at: [indexPath], with: .fade)
                            }}}
                    else if change.type == .removed{ //刪除
                        
                        if let perPost = self.data.filter({ (perPost) -> Bool in
                            perPost.postUUID == documentID
                        }).first{
                            if let index = self.data.firstIndex(of: perPost){
                                let indexPath = IndexPath(row: index, section: 0)
                                self.data.remove(at: indexPath.row)
                                self.tableview.deleteRows(at: [indexPath], with: .fade)
                            } } }
                   }
        self.lastTime =  self.data.first?.longPostTime
        self.listenerToCheckNewPost()
             }
    }
    
 
    //MARK: -> queryfavoriteCounts 計算追蹤人數
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
                                //perPost.favoriteCount = change.document.data()["favoriteCounts"] as! Int
                                self.updateFavoriteCount(documentID: perPost.postUUID)
                                //perAnnotation.viewsCount = change.document.data()["viewsCount"] as! Int
                                //note.imageName = change.document.data()["imageName"] as? String
                                if self.data.firstIndex(of: perPost) != nil{
                                //let indexPath = IndexPath(row: index, section: 0)
                                //self.mapKitView.annotations[indexPath.row]
                                //self.data[indexPath.row]
                                //self.tableview.reloadRows(at: [indexPath], with: .fade)
                                //self.data.remove(at: indexPath.row)
                                    self.tableview.reloadData()
                                  
                                } } } } } } } }
    
    
    func CountViews (){
        db.collection("userPost").document("D0E8F59E-940A-49C1-92D0-2CF0FCC6FF17").collection("views").addSnapshotListener { (allviewrs, error) in
            self.db.collection("userPost").document("D0E8F59E-940A-49C1-92D0-2CF0FCC6FF17").updateData(["viewsCount":allviewrs?.count ?? 0])
        }
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
            self.db.collection("userPost").document(uuid).updateData(["favoriteCounts":favorite?.count ?? 0])
         }
     }
    
     
//    @IBAction func swiftSwipeAction(_ sender: UISwipeGestureRecognizer) {
//        UIView.animate(withDuration: 0.6) {
//         self.hidenTopItem.alpha = 1
//          }
//        self.tableview.topAnchor.constraint(equalTo: self.hidenTopItem.bottomAnchor,constant: 0).isActive = true
//         print("down")
//    }
  
    
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
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
           return true
       }
   
    @IBAction func searchButton(_ sender: UIButton) {
         
        if self.serchMap.text?.isEmpty == false && selectCategoryLabel.text?.isEmpty == false {
           performSegue(withIdentifier: "tappMapByAllpostButton", sender: nil)
            self.selectCategoryLabel.text = ""
            self.serchMap.text = ""
            
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
          self.view.endEditing(true)
       }
    
    func saveTextfield(ShowAlertMessage show:String ) {
            let alerController = UIAlertController(title: nil, message: show, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "確定", style: .default, handler: nil)
             alerController.addAction(OKAction)
             present(alerController,animated: true)
          }
   
     
    @IBAction func tap(_ sender: Any) {
       
    }
    
    func currentTime () -> String   {
          let now = Date()
          let dateformatter = DateFormatter()
          dateformatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
          let currentTime = dateformatter.string(from: now)
          return currentTime
      }
     
    func pressCategoryButton(button:UIButton,categoryName:String){
        UIView.animate(withDuration: 0.3) {
            self.initButton()
             self.categoryControllButtenView.frame.origin.x = super.view.frame.origin.x + 10
              self.searchButton.alpha = 1
            button.setImage(UIImage(named: categoryName), for: .normal)
             }
    }
     
    @IBAction func scrollViewToTop(_ sender: UIButton) {
        let indexpath = IndexPath(row: 0, section: 0)
        self.tableview.scrollToRow(at: indexpath, at: .top, animated: true)
              UIView.animate(withDuration: 0.3) {
        self.hidenTopItem.alpha = 1
         self.tableview.frame.origin.y = self.hidenTopItem.frame.maxY
        }
    }
    
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        backToTopBTN.alpha = 0
        
        let offsetY = scrollView.contentOffset.y
        let contetHeight = scrollView.contentSize.height
        let scrollviewSizeHeight = scrollView.frame.size.height
//        print("offsetY\(offsetY)")
//        print("ContentsHeight\(contetHeight)")
//        print("scrollviewSizeHeight\(scrollviewSizeHeight)")
        if contetHeight > scrollviewSizeHeight &&  offsetY   >= contetHeight - scrollviewSizeHeight {
             print("符合條件")
            checkFetchOldDataExist()
//            nextPageData()
        }else  if offsetY < contetHeight - scrollviewSizeHeight {
            if fetchOldButtonTopAnchor != nil {
//                self.fetchOldButtonTopAnchor.constant = 100
                 checkFetchOldDataExist()
                 self.fetchOldButton.alpha = 0
            }
        }
    }
    
    func checkFetchOldDataExist(){
      if self.fetchOldButton.titleLabel?.text == "查看更多資料" {
         self.fetchOldButton.alpha = 1
          return
      }else{
          self.createFetchButton()
      }
    }
    
    
    func createFetchButton(){
                           self.fetchOldButton.alpha = 1
                           self.fetchOldButton.translatesAutoresizingMaskIntoConstraints = false
                            view.addSubview(self.fetchOldButton)
                           self.fetchOldButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
                           self.fetchOldButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
               //           self.fetchDataButton.leadingAnchor.constraint(equalTo: super.view.leadingAnchor,constant: 0).isActive = true
               //           self.fetchDataButton.trailingAnchor.constraint(equalTo: super.view.trailingAnchor,constant: 0).isActive = true
                           self.fetchOldButton.layer.cornerRadius = 10
                           fetchOldButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                           self.fetchOldButtonTopAnchor =  self.fetchOldButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -20)
                          self.fetchOldButtonTopAnchor.isActive = true
                          self.fetchOldButton.backgroundColor = .red
                          self.fetchOldButton.setTitle("查看更多資料", for: .normal)
                           self.fetchOldButton.setTitleColor(.white, for: .normal)
                           self.fetchOldButton.addTarget(self, action: #selector(nextPageData), for: .touchUpInside)
           }
     
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let firstIndex = firstIndex {
            if  firstIndex.row == 0{
                backToTopBTN.alpha = 0
            }else if  firstIndex.row != 0{
                backToTopBTN.alpha = 1
            }
        }
    }
 
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let firstIndex = firstIndex {
            if  firstIndex.row == 0{
                backToTopBTN.alpha = 0
            }else if  firstIndex.row != 0{
                backToTopBTN.alpha = 1
            }
        }
    }
   
    
    @IBAction func searchBar(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.categoryControllButtenView.frame.origin.x = super.view.frame.origin.x + 10
            self.searchButton.alpha = 1
            
        }
    }
    
    
    
    @IBAction func searchMapAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.categoryControllButtenView.frame.origin.x = super.view.frame.origin.x + 10
            self.searchButton.alpha = 1
        }
    }
    
    @IBAction func deleteUser(_ sender: Any) {
       let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
            print("deleteUser：\(error.localizedDescription)")
            return
          } else {
            // Account deleted.
            print("帳號已經刪除嘗試google登入 ")
            GIDSignIn.sharedInstance()?.signIn()
          }
        }
    }
    
    @objc func nextPageData(){
        
           listener?.remove()
                db.collection("userPost").order(by: "timeStamp",descending: true).limit(to: 5).start(afterDocument: self.lastDocument!).getDocuments { (query, error) in
                    
                         if let error = error{ print("query Faild\(error)")  }
                         guard let myquest = query else {return}
                         if let querylast = myquest.documents.last{
                             self.lastDocument = querylast
                         }
                    
        //             guard let documentChange = query?.documentChanges else {return}
                    guard let documentChange = query?.documentChanges else {return}
                    for change in documentChange{
                     
                                    //處理每一筆更新
                        let documentID = change.document.documentID
                                     self.updateCount(documentID: documentID)
                                    self.updateFavoriteCount(documentID: documentID)
                        if change.type == .added{
                             let postdetail = allPostModel.QueryData(Document: change)
                                        self.data.append(postdetail)
                                        self.getfavoriteListName()
                                        self.tableview.reloadData()
                            
                        } } }
    }
    
    
    
  
    
    
    
    func listenerToCheckNewPost(){
        db.collection("userPost").whereField("longPostTime", isGreaterThan: lastTime!).addSnapshotListener { (query, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let query = query?.documents.first else {return}
//            let lastTimee = query.data()["longPostTime"] as? String
//            self.uploadNewPost(lastTime:self.lastTime!)

//            self.clickButtonRefreshData()
            self.checkUploadButtonExsit()
        }
    }
    
    
    
    @objc func uploadNewPost(){
        moveRefreshButtonPostion(hiden: true)
        
         db.collection("userPost").whereField("longPostTime", isGreaterThan: lastTime).getDocuments { (query, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let query = query?.documentChanges else {return}
            for change in query {
                let documentID = change.document.documentID
                self.updateCount(documentID: documentID)
                self.updateFavoriteCount(documentID: documentID)
                let postdetail = allPostModel.QueryData(Document: change)
                self.data.insert(postdetail, at: 0)
               // self.data.append(postdetail)
                self.getfavoriteListName()
                //self.tableview.reloadData()
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableview.insertRows(at: [indexPath], with: .left)
                self.lastTime = self.data.first?.longPostTime
                
                
            } }
        
        
    }
    
    
    func checkUploadButtonExsit(){
        if self.fetchNewButton.titleLabel?.text == "更新最新資料" {
            return
        }else{
            self.clickButtonRefreshData()
        }
      }
    
    
    func clickButtonRefreshData(){
       
        self.fetchNewButton.translatesAutoresizingMaskIntoConstraints = false
        self.fetchNewButton.layer.cornerRadius = 10
        self.fetchNewButton.setTitle("更新最新資料", for: .normal)
        self.fetchNewButton.setTitleColor(.white, for: .normal)
        self.fetchNewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.fetchNewButtonTopAnchor = self.fetchNewButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        fetchNewButtonTopAnchor.isActive = true
        self.fetchNewButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.fetchNewButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.fetchNewButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.fetchNewButton.titleLabel?.baselineAdjustment = .alignCenters
        self.fetchNewButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.fetchNewButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.fetchNewButton.backgroundColor = #colorLiteral(red: 0.5414773226, green: 0.5835128427, blue: 0.7766371369, alpha: 1)
         
        addShadow(Button: self.fetchNewButton).addTarget(self, action: #selector(uploadNewPost), for: .touchUpInside)
 
        
    }
    
    func addShadow(Button:UIButton) -> UIButton{
        Button.clipsToBounds = false
        Button.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        Button.layer.shadowOffset = CGSize(width: 10, height: 10)
        Button.layer.shadowRadius = 4
        Button.layer.shadowOpacity = 0.5
//        moveRefreshButtonPostion(hiden: false)
        return Button
        
    }
    
    @objc func moveRefreshButtonPostion(hiden:Bool){
        
        if hiden{
            UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.fetchNewButtonTopAnchor.constant = -100
                self.view.layoutIfNeeded()
                self.fetchNewButtonTopAnchor.isActive = false
                self.fetchNewButton.setTitle("  ", for: .normal)
            }, completion: nil)
            
        }else{
            UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.fetchNewButtonTopAnchor.constant = 100
                          self.view.layoutIfNeeded()
              }, completion: nil)
            
        }
        
    }
    
     
    @IBAction func 刪除測試資料用(_ sender: Any) {
          db.collection("userPost").whereField("longPostTime",  isGreaterThan: "2020:08:01 12:00:01").getDocuments { (query, error) in
               if let error = error{  print("query Faild\(error)");  return  }
               
            guard let myquest = query?.documents else {return}
            for i in myquest{
                print(i.documentID)
                self.db.collection("userPost").document(i.documentID).delete()
            }
              } }
    
    //MARK: -> 尾巴

}

