 

import UIKit
import Firebase
 import GoogleSignIn
 class myPostDetailCell: UIViewController,UITableViewDelegate,UITableViewDataSource,myPostDetailDeleate {
 
    
    @IBOutlet weak var myInfoView: UIView!
    @IBOutlet weak var tableview: UITableView!
    let sharePost = CoredataSharePost.share
    let db = Firestore.firestore()
//    var data: [PostInfomation] = []
    var data : [allPostModel] = []
    var tempIndex: IndexPath?
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var googleGamil: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let allPostcell = tableView.dequeueReusableCell(withIdentifier: "allPostCell", for: indexPath) as! allPostDetail
//        var data = self.data[indexPath.row]
        allPostcell.Title.text = self.data[indexPath.row].productName
        allPostcell.subTitle.text = self.data[indexPath.row].userShortLocation
//        allPostcell.likeImage.image = self.data[indexPath.row].postCategory
//        allPostcell.categoryImage.image = self.data[indexPath.row].categoryImage
        allPostcell.buildTime.text = self.data[indexPath.row].buildTime
       
        return allPostcell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.myInfoView.layer.borderWidth = 0.5
        self.tableview.layer.borderWidth = 0.5
        guard let UserEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email else {return}
                    db.collection("user").whereField("Gmail", isEqualTo: UserEmail).getDocuments { (data, error) in
                        guard let data = data else {return}
                        for i in data.documents{
                            self.nickname.text = "暱稱:\(i.data()["nickName"] ?? "N/A")"
                            self.userPhoneNumber.text = "聯絡電話:\(i.data()["phoneNumber"] ?? "N/A")"
                            self.googleGamil.text = "信箱:\(i.data()["Gmail"] ?? "N/A")"
                                    
                        }
                    }
        sharePost.loadData()
//        self.data = sharePost.data
 
       queryFirestore()
    }
    
 
        func queryFirestore(){
            guard let myGoogleName = GIDSignIn.sharedInstance()?.currentUser.profile.name else {return}




            self.db.collection("userPost").whereField("Name", isEqualTo: "花滿").addSnapshotListener { (data, error) in
                guard let data = data?.documentChanges else {return}
    //                    print(query.data()!["postTime"])
                for query in data {
                     let documentID = query.document.documentID
                    if query.type == .added{
                         let postdetail = allPostModel(
                                                categoryImage: UIImage(named: "test")!,
                                                likeImage: UIImage(named: "pointRed")!,
                                                buildTime: query.document.data()["postTime"] as? String ?? "N/A",
                                                subTitle: query.document.data()["postIntroduction"] as? String ?? "N/A",
                                                Title: query.document.data()["postCategory"] as? String ?? "N/A",
                                                postGoogleName: query.document.data()["googleName"] as? String ?? "N/A",
                                                postNickName: query.document.data()["Name"]as? String ?? "N/A",
                                                postUUID: query.document.data()["postUUID"] as? String ?? "N/A" ,
                                                postTime: query.document.data()["postTime"] as? String ?? "N/A",
                                                viewsCount: query.document.data()["viewsCount"] as? Int ?? 0,
                                                productName:query.document.data()["productName"] as? String ?? "N/A",
                                                userLocation: query.document.data()["userLocation"] as? String ?? "N/A",
                                                userShortLocation:query.document.data()["userShortLocation"] as? String ?? "N/A")

                        
                        
                        self.data.append(postdetail)
                        self.tableview.reloadData()
                    } else if query.type == .removed  {
                        if let mypost = self.data.filter({ (mypost) -> Bool in
                            mypost.postUUID == documentID
                        }).first{
                            
                            //                                perAnnotation.viewsCount = change.document.data()["viewsCount"] as! Int
                            //                            note.imageName = change.document.data()["imageName"] as? String
                            if let index = self.data.index(of: mypost){
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
    
    //以下OK
//      func queryFirestore(){
//        guard let myGoogleName = GIDSignIn.sharedInstance()?.currentUser.profile.name else {return}
//        db.collection("user").document(myGoogleName).collection("myPost").addSnapshotListener{ (query, error) in
//            guard let query = query else {return}
//
//            for i in query.documents{
//                self.db.collection("userPost").document(i.documentID).addSnapshotListener { (query, error) in
//                    guard let query = query else {return}
////                    print(query.data()!["postTime"])
//                     let postdetail = allPostModel(
//                                            categoryImage: UIImage(named: "test")!,
//                                            likeImage: UIImage(named: "pointRed")!,
//                                            buildTime: query.data()?["postTime"] as? String ?? "N/A",
//                                            subTitle: query.data()?["postIntroduction"] as? String ?? "N/A",
//                                            Title: query.data()?["postCategory"] as? String ?? "N/A",
//                                            postGoogleName: query.data()?["googleName"] as? String ?? "N/A",
//                                            postNickName: query.data()?["Name"]as? String ?? "N/A",
//                                            postUUID: query.data()?["postUUID"] as? String ?? "N/A" ,
//                                            postTime: query.data()?["postTime"] as? String ?? "N/A",
//                                            viewsCount: query.data()?["viewsCount"] as? Int ?? 0,
//                                            productName:query.data()?["productName"] as? String ?? "N/A",
//                                            userLocation: query.data()?["userLocation"] as? String ?? "N/A",
//                                            userShortLocation:query.data()?["userShortLocation"] as? String ?? "N/A")
//
//
//
//                                                self.data.append(postdetail)
//                                                self.tableview.reloadData()
//                    }
//                }
//        }
//    }

    
    //以上OK
    
//                    if let error = error{
//                        print("query Faild\(error)")
//                    }
//
//                    guard let documentChange = query?.documentChanges else {return}
//                    for change in documentChange{
//                        //處理每一筆更新
//                        let documentID = change.document.documentID
//
//                        if change.type == .added{
//
//                       let postdetail = allPostModel(categoryImage: UIImage(named: "test")!,
//                        likeImage: UIImage(named: "pointRed")!,
//                        buildTime: change.document.data()["postTime"] as? String ?? "N/A",
//                        subTitle: change.document.data()["postIntroduction"] as? String ?? "N/A",
//                        Title: change.document.data()["postCategory"] as? String ?? "N/A",
//                        postGoogleName: change.document.data()["googleName"] as? String ?? "N/A",
//                        postNickName: change.document.data()["Name"]as? String ?? "N/A",
//                        postUUID: change.document.data()["postUUID"] as? String ?? "N/A" ,
//                        postTime: change.document.data()["postTime"] as? String ?? "N/A",
//                        viewsCount: change.document.data()["viewsCount"] as? Int ?? 0,
//                        productName:change.document.data()["productName"] as? String ?? "N/A",
//                        userLocation: change.document.data()["userLocation"] as? String ?? "N/A",
//                        userShortLocation:change.document.data()["userShortLocation"] as? String ?? "N/A")
//
//
//
//                            self.data.append(postdetail)
//                            self.tableview.reloadData()
//
//                        }
//                        else if change.type == .modified{ //修改
//                            if let perPost = self.data.filter({ (perPost) -> Bool in
//                                perPost.postUUID == documentID
//                            }).first{
//                                perPost.viewsCount = change.document.data()["viewsCount"] as! Int
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
//
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
//          }
                    
//        }
        
        //
        

//  func queryFirestore(){
//
    
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

                  if segue.identifier == "myPostDetail"{
                      let myPostDetail = segue.destination as! myPostDetailVC
                    if let indexPath = self.tableview.indexPathForSelectedRow{
                        
                        let data = self.data[indexPath.row]
                        myPostDetail.delegate = self
                        myPostDetail.data = data
                    }

                  }
              }
    func Update(data: allPostModel) {
        self.tableview.reloadData()
     }
    
        }
 
