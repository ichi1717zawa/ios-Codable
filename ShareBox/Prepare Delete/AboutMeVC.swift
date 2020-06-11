////
////  AboutMeVC.swift
////  ShareBox
////
////  Created by 廖逸澤 on 2020/5/27.
////  Copyright © 2020 廖逸澤. All rights reserved.
////
//
//import UIKit
//import CoreData
//import GoogleSignIn
//import Firebase
//class AboutMeVC: UIViewController  {
//    
//    var data : [UserInfomation] = []
//    @IBOutlet weak var nickname: UILabel!
//    @IBOutlet weak var userID: UILabel!
//    @IBOutlet weak var googleGamil: UILabel!
//    @IBOutlet weak var googleName: UILabel!
//    @IBOutlet weak var userLocation: UILabel!
//    @IBOutlet weak var contribute: UILabel!
//    
//     let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//     let db = Firestore.firestore()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        guard let UserEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email else {return}
//                db.collection("user").whereField("Gmail", isEqualTo: UserEmail).getDocuments { (data, error) in
//                    guard let data = data else {return}
//                    for i in data.documents{
//                        self.nickname.text = "暱稱:\(i.data()["nickName"] ?? "N/A")"
//                        self.userID.text = "聯絡電話:\(i.data()["phoneNumber"] ?? "N/A")"
//                        self.googleGamil.text = "信箱:\(i.data()["Gmail"] ?? "N/A")"
//                                
//                    }
//                }
////        loadData()
//// 
////        self.nickname.text = "暱稱:\(self.data[0].nickname)"
////        self.userID.text = "使用者ID:\(self.data[0].userID)"
////        self.googleGamil.text = "信箱:\(self.data[0].googleGmail)"
////        self.googleName.text = "Goolge名字:\(self.data[0].googleName)"
////        self.userLocation.text = "供取貨地址:\(self.data[0].userLocation)"
////        self.contribute.text = "已捐贈次數:\(self.data[0].contribute)"
// 
// 
//        
//    }
//    
// 
//      func loadData (){
//               let request = NSFetchRequest<UserInfomation>(entityName: "UserInfo")
//    //           let sort = NSSortDescriptor(key: "labelName", ascending: false)
//    //           request.sortDescriptors = [sort]
//               myContext.performAndWait {
//                   do{
//                       let results = try myContext.fetch(request)
//                       self.data = results
//                   }catch{
//                       print("error while fetching Note from db \(error)")
//                       
//                   }
//               }
//               
//               
//               
//           }
//           
//           //-----------------------------------------------------
//           func saveData(){
//               try? myContext.save()
//           }
//}
