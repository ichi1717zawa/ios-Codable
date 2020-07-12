 
 
 import UIKit
 import Firebase
 import GoogleSignIn
 import FirebaseStorage
 import FBSDKLoginKit
 class myPostDetailCell: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,UISearchResultsUpdating,UITextFieldDelegate, LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    let myUID : String! = Auth.auth().currentUser?.uid
    func updateSearchResults(for searchController: UISearchController) {
    }
    @IBOutlet weak var fbLogIn: FBLoginButton!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var myInfoView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var selectCategoryLabel: UILabel!
    //    let myGoogleName = GIDSignIn.sharedInstance()?.currentUser.profile.name
    
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var googleGamil: UILabel!
    let db = Firestore.firestore()
    var data: [allPostModel] = []
    var tempIndex: IndexPath?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let allPostcell = tableview.dequeueReusableCell(withIdentifier: "allPostCell", for: indexPath) as! allPostDetail
        let data = self.data[indexPath.row]
        allPostcell.Title.text = data.productName
        allPostcell.subTitle.text = data.userShortLocation
        allPostcell.postImage.image = data.categoryImage
        allPostcell.buildTime.text = data.buildTime
        allPostcell.viewsCount.text = String(data.viewsCount)
        allPostcell.favoriteCount.text = String(data.favoriteCount)
        allPostcell.introduction.text = data.subTitle
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
                    print("從Firebase下載圖檔有錯誤\(e)")
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
        
        
        return allPostcell
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        fbLogIn.delegate = self
        //        fbLogIn.permissions = ["public_profile","email","user_friends"]
        
        
        //  guard let UserEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email else {return}
        db.collection("user").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "N/A").getDocuments { (data, error) in
            guard let data = data else {return}
            for i in data.documents{
                self.nickname.text = "\(i.data()["nickName"] ?? "N/A")"
                self.userPhoneNumber.text = "\(i.data()["phoneNumber"] ?? "N/A")"
                self.googleGamil.text = "\(i.data()["Gmail"] ?? "N/A")"
                self.userName.text = ""
                
            }
        }
        queryFirestore()
        queryfavoriteCounts()
    }
    
    
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
    
    func updateFavoriteCount (documentID:Any){
        self.db.collection("userPost").document("\(documentID)").collection("favoriteCounts").addSnapshotListener { (data, error) in
            if error != nil{
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
    
    func queryFirestore(){
        //        guard let myGoogleName = self.myGoogleName else {return}
        self.db.collection("userPost").whereField("posterUID", isEqualTo: myUID!).addSnapshotListener { (query, error) in
            if let error = error{
                print("query Faild\(error)")
                return
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
                                                      subTitle: data.data()?["postIntroduction"] as? String ?? "N/A",
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
                        if let index = self.data.firstIndex(of: perPost){
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
                return
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
                                if self.data.firstIndex(of: perPost) != nil{
//                                    let indexPath = IndexPath(row: index, section: 0)
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
            if error != nil{
                           return
                       }
            self.db.collection("userPost").document("D0E8F59E-940A-49C1-92D0-2CF0FCC6FF17").updateData(["viewsCount":allviewrs?.count ?? 0])
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         self.tableview.deselectRow(at: indexPath, animated: false)
        let postUUID = self.data[indexPath.row].postUUID
//        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        db.collection("userPost").document("\(postUUID)").collection("views").document(myUID).setData(["viww": "view"])
        CountViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        if segue.identifier == "myPostDetail"{
            let myPostDetail = segue.destination as! myPostDetailVC
            if let indexPath = self.tableview.indexPathForSelectedRow{
                
                let data = self.data[indexPath.row]
                //                            myPostDetail.delegate = self
                myPostDetail.data = data
            }
            
        }
    }
    
    
    
    func favotireCounts (uuid:String){
        db.collection("userPost").document(uuid).collection("favoriteCounts").addSnapshotListener { (favorite, error) in
            if error != nil{
                           return
                       }
            self.db.collection("userPost").document(uuid).updateData(["favoriteCounts":favorite?.count ?? 0])
        }
    }
    
    
    
    
    @IBAction func SignOutButton(_ sender: UIButton) {
        
      
        let fbLoginManager = LoginManager()
        fbLoginManager.logOut()
        
//        let listener = db.collection("userPost").addSnapshotListener { querySnapshot, error in
//
//        }
//        let listener1 = self.db.collection("user").document(myUID).collection("Messages").addSnapshotListener  { querySnapshot, error in
//
//        }
        
        let listener = db.collection("userPost").addSnapshotListener { querySnapshot, error in
            let query = querySnapshot!
            for i in query.documents{
                print(i.data()["postUUID"]!)
            }
            
        }
        let listener1 =  db.collection("user").addSnapshotListener  { querySnapshot, error in
            
            }
        
        listener.remove()
        listener1.remove()
        
        GIDSignIn.sharedInstance()?.signOut()
        try? Auth.auth().signOut()
        
        //         try? Auth.auth().signOut()
//        self.navigationController?.popToRootViewController(animated: true)
//        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationController?.popToRootViewController(animated: true)
    }
    
 }
 
 
 ////
 ////
 //import UIKit
 //import Firebase
 // import GoogleSignIn
 // class myPostDetailCell: UIViewController,UITableViewDelegate,UITableViewDataSource,myPostDetailDeleate {
 //
 //
 //    @IBOutlet weak var myInfoView: UIView!
 //    @IBOutlet weak var tableview: UITableView!
 //    let sharePost = CoredataSharePost.share
 //    let db = Firestore.firestore()
 ////    var data: [PostInfomation] = []
 //    var data : [allPostModel] = []
 //    var tempIndex: IndexPath?
 //    @IBOutlet weak var nickname: UILabel!
 //    @IBOutlet weak var userPhoneNumber: UILabel!
 //    @IBOutlet weak var googleGamil: UILabel!
 //
 //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 //        return data.count
 //    }
 //
 //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 //          let allPostcell = tableView.dequeueReusableCell(withIdentifier: "allPostCell", for: indexPath) as! allPostDetail
 ////        var data = self.data[indexPath.row]
 //        allPostcell.Title.text = self.data[indexPath.row].productName
 //        allPostcell.subTitle.text = self.data[indexPath.row].userShortLocation
 ////        allPostcell.likeImage.image = self.data[indexPath.row].postCategory
 ////        allPostcell.categoryImage.image = self.data[indexPath.row].categoryImage
 //        allPostcell.buildTime.text = self.data[indexPath.row].buildTime
 //
 //        return allPostcell
 //
 //    }
 //
 //
 //    override func viewDidLoad() {
 //        super.viewDidLoad()
 //        self.myInfoView.layer.borderWidth = 0.5
 //        self.tableview.layer.borderWidth = 0.5
 //        guard let UserEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email else {return}
 //                    db.collection("user").whereField("Gmail", isEqualTo: UserEmail).getDocuments { (data, error) in
 //                        guard let data = data else {return}
 //                        for i in data.documents{
 //                            self.nickname.text = "暱稱:\(i.data()["nickName"] ?? "N/A")"
 //                            self.userPhoneNumber.text = "聯絡電話:\(i.data()["phoneNumber"] ?? "N/A")"
 //                            self.googleGamil.text = "信箱:\(i.data()["Gmail"] ?? "N/A")"
 //
 //                        }
 //                    }
 //        sharePost.loadData()
 ////        self.data = sharePost.data
 //
 //       queryFirestore()
 //    }
 //
 //
 //        func queryFirestore(){
 //            guard let myGoogleName = GIDSignIn.sharedInstance()?.currentUser.profile.name else {return}
 //
 //
 //
 //
 //            self.db.collection("userPost").whereField("googleName", isEqualTo: myGoogleName).addSnapshotListener { (data, error) in
 //                guard let data = data?.documentChanges else {return}
 //
 //                for query in data {
 //                     let documentID = query.document.documentID
 //                    if query.type == .added{
 //                         let postdetail = allPostModel(
 //                                                categoryImage: UIImage(named: "test")!,
 //                                                likeImage: UIImage(named: "pointRed")!,
 //                                                buildTime: query.document.data()["postTime"] as? String ?? "N/A",
 //                                                subTitle: query.document.data()["postIntroduction"] as? String ?? "N/A",
 //                                                Title: query.document.data()["postCategory"] as? String ?? "N/A",
 //                                                postGoogleName: query.document.data()["googleName"] as? String ?? "N/A",
 //                                                postNickName: query.document.data()["Name"]as? String ?? "N/A",
 //                                                postUUID: query.document.data()["postUUID"] as? String ?? "N/A" ,
 //                                                postTime: query.document.data()["postTime"] as? String ?? "N/A",
 //                                                viewsCount: query.document.data()["viewsCount"] as? Int ?? 0,
 //                                                productName:query.document.data()["productName"] as? String ?? "N/A",
 //                                                userLocation: query.document.data()["userLocation"] as? String ?? "N/A",
 //                                                userShortLocation:query.document.data()["userShortLocation"] as? String ?? "N/A",
 //                                                favoriteCount: query.document.data()["favoriteCounts"] as? Int ?? 0,
 //                                                mainCategory: query.document.data()["mainCategory"] as? String ?? "N/A")
 //
 //
 //
 //                        self.data.append(postdetail)
 //                        self.tableview.reloadData()
 //                    } else if query.type == .removed  {
 //                        if let mypost = self.data.filter({ (mypost) -> Bool in
 //                            mypost.postUUID == documentID
 //                        }).first{
 //
 //                            //                                perAnnotation.viewsCount = change.document.data()["viewsCount"] as! Int
 //                            //                            note.imageName = change.document.data()["imageName"] as? String
 //                            if let index = self.data.index(of: mypost){
 //                                let indexPath = IndexPath(row: index, section: 0)
 //                                //                                self.mapKitView.annotations[indexPath.row]
 //                                //                                self.data[indexPath.row]
 //                                //                                 self.tableview.reloadRows(at: [indexPath], with: .fade)
 //                                self.data.remove(at: indexPath.row)
 //                                self.tableview.reloadData()
 //                                //
 //
 //                            }
 //                        }
 //
 //                    }
 //                }
 //
 //
 //            }
 //    }
 //
 //    //以下OK
 ////      func queryFirestore(){
 ////        guard let myGoogleName = GIDSignIn.sharedInstance()?.currentUser.profile.name else {return}
 ////        db.collection("user").document(myGoogleName).collection("myPost").addSnapshotListener{ (query, error) in
 ////            guard let query = query else {return}
 ////
 ////            for i in query.documents{
 ////                self.db.collection("userPost").document(i.documentID).addSnapshotListener { (query, error) in
 ////                    guard let query = query else {return}
 //////                    print(query.data()!["postTime"])
 ////                     let postdetail = allPostModel(
 ////                                            categoryImage: UIImage(named: "test")!,
 ////                                            likeImage: UIImage(named: "pointRed")!,
 ////                                            buildTime: query.data()?["postTime"] as? String ?? "N/A",
 ////                                            subTitle: query.data()?["postIntroduction"] as? String ?? "N/A",
 ////                                            Title: query.data()?["postCategory"] as? String ?? "N/A",
 ////                                            postGoogleName: query.data()?["googleName"] as? String ?? "N/A",
 ////                                            postNickName: query.data()?["Name"]as? String ?? "N/A",
 ////                                            postUUID: query.data()?["postUUID"] as? String ?? "N/A" ,
 ////                                            postTime: query.data()?["postTime"] as? String ?? "N/A",
 ////                                            viewsCount: query.data()?["viewsCount"] as? Int ?? 0,
 ////                                            productName:query.data()?["productName"] as? String ?? "N/A",
 ////                                            userLocation: query.data()?["userLocation"] as? String ?? "N/A",
 ////                                            userShortLocation:query.data()?["userShortLocation"] as? String ?? "N/A")
 ////
 ////
 ////
 ////                                                self.data.append(postdetail)
 ////                                                self.tableview.reloadData()
 ////                    }
 ////                }
 ////        }
 ////    }
 //
 //
 //    //以上OK
 //
 ////                    if let error = error{
 ////                        print("query Faild\(error)")
 ////                    }
 ////
 ////                    guard let documentChange = query?.documentChanges else {return}
 ////                    for change in documentChange{
 ////                        //處理每一筆更新
 ////                        let documentID = change.document.documentID
 ////
 ////                        if change.type == .added{
 ////
 ////                       let postdetail = allPostModel(categoryImage: UIImage(named: "test")!,
 ////                        likeImage: UIImage(named: "pointRed")!,
 ////                        buildTime: change.document.data()["postTime"] as? String ?? "N/A",
 ////                        subTitle: change.document.data()["postIntroduction"] as? String ?? "N/A",
 ////                        Title: change.document.data()["postCategory"] as? String ?? "N/A",
 ////                        postGoogleName: change.document.data()["googleName"] as? String ?? "N/A",
 ////                        postNickName: change.document.data()["Name"]as? String ?? "N/A",
 ////                        postUUID: change.document.data()["postUUID"] as? String ?? "N/A" ,
 ////                        postTime: change.document.data()["postTime"] as? String ?? "N/A",
 ////                        viewsCount: change.document.data()["viewsCount"] as? Int ?? 0,
 ////                        productName:change.document.data()["productName"] as? String ?? "N/A",
 ////                        userLocation: change.document.data()["userLocation"] as? String ?? "N/A",
 ////                        userShortLocation:change.document.data()["userShortLocation"] as? String ?? "N/A")
 ////
 ////
 ////
 ////                            self.data.append(postdetail)
 ////                            self.tableview.reloadData()
 ////
 ////                        }
 ////                        else if change.type == .modified{ //修改
 ////                            if let perPost = self.data.filter({ (perPost) -> Bool in
 ////                                perPost.postUUID == documentID
 ////                            }).first{
 ////                                perPost.viewsCount = change.document.data()["viewsCount"] as! Int
 ////    //                            note.imageName = change.document.data()["imageName"] as? String
 ////    //                            if let index = self.data.index(of: perPost){
 ////    //                                let indexPath = IndexPath(row: index, section: 0)
 ////    //                                self.tableview.reloadRows(at: [indexPath], with: .fade)
 ////                                self.tableview.reloadData()
 ////    //                            }
 ////                            }
 ////
 ////                        }
 ////                        else if change.type == .removed{ //刪除
 ////
 ////                            if let perPost = self.data.filter({ (perPost) -> Bool in
 ////                                perPost.postUUID == documentID
 ////                            }).first{
 ////
 ////                                //                                perAnnotation.viewsCount = change.document.data()["viewsCount"] as! Int
 ////                                //                            note.imageName = change.document.data()["imageName"] as? String
 ////                                if let index = self.data.index(of: perPost){
 ////                                    let indexPath = IndexPath(row: index, section: 0)
 ////    //                                self.mapKitView.annotations[indexPath.row]
 ////    //                                self.data[indexPath.row]
 ////    //                                 self.tableview.reloadRows(at: [indexPath], with: .fade)
 ////                                    self.data.remove(at: indexPath.row)
 ////                                    self.tableview.reloadData()
 ////                                    //
 ////
 ////                                }
 ////                            }
 ////                        }
 ////          }
 //
 ////        }
 //
 //        //
 //
 //
 ////  func queryFirestore(){
 ////
 //
 //            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 //
 //                  if segue.identifier == "myPostDetail"{
 //                      let myPostDetail = segue.destination as! myPostDetailVC
 //                    if let indexPath = self.tableview.indexPathForSelectedRow{
 //
 //                        let data = self.data[indexPath.row]
 //                        myPostDetail.delegate = self
 //                        myPostDetail.data = data
 //                    }
 //
 //                  }
 //              }
 //    func Update(data: allPostModel) {
 //        self.tableview.reloadData()
 //     }
 //
 //        }
 
