 
 
 import UIKit
 import Firebase
 import GoogleSignIn
 class FavoriteVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating,UITextFieldDelegate {
    let myUID : String! = Auth.auth().currentUser?.uid
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var selectCategoryLabel: UILabel!
//    let myGoogleName = GIDSignIn.sharedInstance()?.currentUser.profile.name
    
 
    let db = Firestore.firestore()
    var data: [allPostModel] = []
    var tempIndex: IndexPath?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let allPostcell = tableview.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! allPostDetail
        var data = self.data[indexPath.row]
        allPostcell.Title.text = data.productName
        allPostcell.subTitle.text = data.userShortLocation
//        //        allPostcell.likeImage.image = data.likeImage
        allPostcell.postImage.image = data.categoryImage
        allPostcell.buildTime.text = data.buildTime
        allPostcell.viewsCount.text = String(data.viewsCount)
        allPostcell.favoriteCount.text = String(data.favoriteCount)
         
        
        
        return allPostcell
        
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
//        guard let myGoogleName = self.myGoogleName else {return}
        
        db.collection("user").document(myUID!).collection("favoriteList").addSnapshotListener { (query, error) in
            if let error = error{
                print("query Faild\(error)")
            }
            
            guard let documentChange = query?.documentChanges else {return}
            for change in documentChange{
                  let documentID = change.document.documentID
                 
                                   self.updateCount(documentID: documentID)
                                   self.updateFavoriteCount(documentID: documentID)
                                   if change.type == .added{
                                    
                                  self.db.collection("userPost").document(documentID).getDocument{ (data, error) in
                                    guard let data = data else {return}
                                    
                                       let postdetail = allPostModel(categoryImage: UIImage(named: "photo.fill")!,
                                                                     likeImage: UIImage(named: "pointRed")!,
                                                                     buildTime:  data.data()?["postTime"] as? String ?? "N/A",
                                                                     subTitle: data.data()?["userShortLocation"] as? String ?? "N/A",
                                                                     Title: data.data()?["productName"] as? String ?? "N/A",
                                                                     postGoogleName: data.data()?["googleName"] as? String ?? "N/A",
                                                                     postNickName: data.data()?["Name"]as? String ?? "N/A",
                                                                     postUUID: data.data()?["postUUID"] as? String ?? "N/A" ,
                                                                     postTime: data.data()?["postTime"] as? String ?? "N/A",
                                                                     viewsCount: data.data()?["viewsCount"] as? Int ?? 0,
                                                                     productName:data.data()?["productName"] as? String ?? "N/A",
                                                                     userLocation: data.data()?["userLocation"] as? String ?? "N/A",
                                                                     userShortLocation:data.data()?["userShortLocation"] as? String ?? "N/A",
                                                                     favoriteCount: data.data()?["favoriteCounts"] as? Int ?? 0,
                                                                     mainCategory:data.data()?["mainCategory"] as? String ?? "N/A",
                                                                     subCategory: data.data()?["postCategory"] as? String ?? "N/A",
                                                                     posterUID: data.data()?["posterUID"] as? String ?? "N/A")
                          
                                       self.data.append(postdetail)
                                       self.tableview.reloadData()
                                   
                                    }
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
            }
            
        }
    }
    func CountViews (){
        db.collection("userPost").document("D0E8F59E-940A-49C1-92D0-2CF0FCC6FF17").collection("views").addSnapshotListener { (allviewrs, error) in
            self.db.collection("userPost").document("D0E8F59E-940A-49C1-92D0-2CF0FCC6FF17").updateData(["viewsCount":allviewrs?.count])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postUUID = self.data[indexPath.row].postUUID
//        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        db.collection("userPost").document("\(postUUID)").collection("views").document(myUID).setData(["viww": "view"])
        CountViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteSegue"{
            let detailVcByCell = segue.destination as! allPostDetailBycell
            if let indexPath = self.tableview.indexPathForSelectedRow{
                let data = self.data[indexPath.row]
                detailVcByCell.data = data
            }
        }
    }
 
    
    
    func favotireCounts (uuid:String){
        db.collection("userPost").document(uuid).collection("favoriteCounts").addSnapshotListener { (favorite, error) in
            self.db.collection("userPost").document(uuid).updateData(["favoriteCounts":favorite?.count])
        }
    }
  
    
    @IBAction func searchButton(_ sender: UIButton) {
        
    }
     
 }
 
