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
class allPostVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
      
    }
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var SearchMap: UISearchBar!
    let db = Firestore.firestore()
    var data: [allPostModel] = []
    var tempIndex: IndexPath?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let allPostcell = tableView.dequeueReusableCell(withIdentifier: "allPostCell", for: indexPath) as! allPostDetail
        var data = self.data[indexPath.row]
        allPostcell.Title.text = data.productName
        allPostcell.subTitle.text = data.userShortLocation
//        allPostcell.likeImage.image = data.likeImage
        allPostcell.categoryImage.image = data.categoryImage
        allPostcell.buildTime.text = data.buildTime
        allPostcell.viewsCount.text = String(data.viewsCount)
        
        
        
       
        return allPostcell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        SearchMap.placeholder = "qwe"
        SearchMap.delegate = self
        
        
      
        
       queryFirestore()
    }
    
    
    func updateCount (documentID:Any){
        self.db.collection("userPost").document("\(documentID)").collection("views").addSnapshotListener { (data, error) in
                                         for i in data!.documents{
                                             print(i.documentID)
             self.db.collection("userPost").document("\(documentID)").updateData(["viewsCount":data!.count])
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
                    if change.type == .added{
                       
                   let postdetail = allPostModel(categoryImage: UIImage(named: "test")!,
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
                    userShortLocation:change.document.data()["userShortLocation"] as? String ?? "N/A")
                        
//                                    let annotation = AnnotationDetail(title: change.document.data()["postCategory"] as? String ?? "N/A",
//                                                                      Subtitle: change.document.data()["postIntroduction"] as? String ?? "N/A",
//                                                                      coordinate: annotationCoordinate,
//                                                                      postIntroduction: change.document.data()["postIntroduction"] as? String ?? "N/A",
//                                                                      nickName: change.document.data()["Name"] as? String ?? "N/A",
//                                                                      postCategory: change.document.data()["postCategory"] as? String ?? "N/A",
//                                                                      userLocation:change.document.data()["userLocation"] as? String ?? "N/A",
//                                                                      googleName: change.document.data()["googleName"] as? String ?? "N/A",
//                                                                      postUUID: change.document.data()["postUUID"] as? String ?? "N/A")
//                                    self.mapKitView.addAnnotation(annotation)
              
                        self.data.append(postdetail)
                        
                        self.tableview.reloadData()
                        
                    }
                    else if change.type == .modified{ //修改
                        if let perPost = self.data.filter({ (perPost) -> Bool in
                            perPost.postUUID == documentID
                        }).first{
                            perPost.viewsCount = change.document.data()["viewsCount"] as! Int
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


    func CountViews (){
    
        
        db.collection("userPost").document("D0E8F59E-940A-49C1-92D0-2CF0FCC6FF17").collection("views").addSnapshotListener { (allviewrs, error) in
            print(allviewrs?.count)
            self.db.collection("userPost").document("D0E8F59E-940A-49C1-92D0-2CF0FCC6FF17").updateData(["viewsCount":allviewrs?.count])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postUUID = self.data[indexPath.row].postUUID
        print(postUUID)
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
    
    @IBAction func likeButton(_ sender: UIButton) {
         let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        print(myGoogleName)
//        if segue.identifier == "allPostDetailBycell"{
//                            let detailVcByCell = segue.destination as! allPostDetailBycell
        let pointInTable: CGPoint = sender.convert(CGPoint.zero, to: self.tableview)
        guard let  indexPath = self.tableview.indexPathForRow(at: pointInTable)  else {return}
//        let postUUID = self.data[indexPath.row].postUUID
//        db.collection("user").document(myGoogleName).collection("FavoriteList").document("\(self.data[indexPath.row].postUUID)").setData(["ee":123])
       
//        db.collection("userPost").document("\(self.data[indexPath.row].postUUID)").setData(["favoriteCounts": +1],merge: true)
          db.collection("userPost").document(self.data[indexPath.row].postUUID).collection("favoriteCounts").document(myGoogleName).setData(["favorite": "favorite"])
        print(self.data[indexPath.row].productName)
        favotireCounts(uuid: self.data[indexPath.row].postUUID)
                          
    }
    func favotireCounts (uuid:String){
     
         
         db.collection("userPost").document(uuid).collection("favoriteCounts").addSnapshotListener { (favorite, error) in
             self.db.collection("userPost").document(uuid).updateData(["favoriteCounts":favorite?.count])
         }
     }
    
}
 
