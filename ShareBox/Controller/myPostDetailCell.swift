 

import UIKit
import Firebase
class myPostDetailCell: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    let sharePost = CoredataSharePost.share
    let db = Firestore.firestore()
    var data: [PostInfomation] = []
    var tempIndex: IndexPath?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let allPostcell = tableView.dequeueReusableCell(withIdentifier: "allPostCell", for: indexPath) as! allPostDetail
//        var data = self.data[indexPath.row]
        allPostcell.Title.text = self.data[indexPath.row].postCategory
        allPostcell.subTitle.text = self.data[indexPath.row].postIntroduction
//        allPostcell.likeImage.image = self.data[indexPath.row].postCategory
//        allPostcell.categoryImage.image = self.data[indexPath.row].postCategory
//        allPostcell.buildTime.text = self.data[indexPath.row]
       
        return allPostcell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        sharePost.loadData()
        self.data = sharePost.data
     queryFirestoreMydata ()
//       queryFirestore()
    }
    
    
    
    func queryFirestoreMydata (){
        
//        for myPost in self.data{
//
//            db.collection("userPost").document("\(myPost.postUUID)").getDocument { (data, error) in
//                      print(data?.documentID)
//                  }
//        }
      
        
        
    }
//  func queryFirestore(){
//
//            db.collection("userPost").addSnapshotListener { (query, error) in
//                if let error = error{
//                    print("query Faild\(error)")
//                }
//
//
//
//
//                guard let documentChange = query?.documentChanges else {return}
//                for change in documentChange{
//                    //處理每一筆更新
//                    if change.type == .added{
//                   let postdetail = allPostModel(categoryImage: UIImage(named: "pointRed")!,
//                    likeImage: UIImage(named: "pointRed")!,
//                    buildTime: "2020",
//                    subTitle: change.document.data()["postIntroduction"] as? String ?? "N/A",
//                    Title: change.document.data()["postCategory"] as? String ?? "N/A",
//                    postGoogleName: change.document.data()["googleName"] as? String ?? "N/A",
//                    postNickName: change.document.data()["Name"]as? String ?? "N/A",
//                    postUUID: change.document.data()["postUUID"] as? String ?? "N/A" )
//
////                                    let annotation = AnnotationDetail(title: change.document.data()["postCategory"] as? String ?? "N/A",
////                                                                      Subtitle: change.document.data()["postIntroduction"] as? String ?? "N/A",
////                                                                      coordinate: annotationCoordinate,
////                                                                      postIntroduction: change.document.data()["postIntroduction"] as? String ?? "N/A",
////                                                                      nickName: change.document.data()["Name"] as? String ?? "N/A",
////                                                                      postCategory: change.document.data()["postCategory"] as? String ?? "N/A",
////                                                                      userLocation:change.document.data()["userLocation"] as? String ?? "N/A",
////                                                                      googleName: change.document.data()["googleName"] as? String ?? "N/A",
////                                                                      postUUID: change.document.data()["postUUID"] as? String ?? "N/A")
////                                    self.mapKitView.addAnnotation(annotation)
//                        self.data.append(postdetail)
//                        self.tableview.reloadData()
//
//                                }
//
//
//                    }
//
// //
//                }
//            }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//
//    }
//
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

                  if segue.identifier == "myPostDetailVC"{
                      let myPostDetail = segue.destination as! myPostDetailVC
                    if let indexPath = self.tableview.indexPathForSelectedRow{
                        let data = self.data[indexPath.row]
                        myPostDetail.data = data
                    }

                  }
              }
        }
 
