//
//  ChatList.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/2.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ChatList: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var db = Firestore.firestore()
    @IBOutlet weak var tableview: UITableView!
    var chatData : [chatRoomList] = []
    var receiveMessageNickname : String!
     var receiveMessageGoogleName : String!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        return self.chatData.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = UIView()
        view.backgroundColor = .red
        let cell = tableview.dequeueReusableCell(withIdentifier: "ChatListCustomCell", for: indexPath) as! ChatListCustomCell
        cell.OtherName.text = self.chatData[indexPath.row].chatRoomName
//        cell.textLabel?.text = self.chatData[indexPath.row].chatRoomName
        cell.userSubtitle.alpha = 0
        
//        cell.detailTextLabel?.alpha = 0
        cell.userSubtitle.text = self.chatData[indexPath.row].otherGoogleName
//        cell.detailTextLabel?.text = self.chatData[indexPath.row].otherGoogleName
        cell.userImage.image = UIImage(named: "chatIcon")
        cell.unreadMessageCount.text =  self.chatData[indexPath.row].unreadCount
        
//        cell.accessoryType = .checkmark
        
//        print(cell.detailTextLabel?.text)
//        for i in 0...self.chatData.count{
        var c = 0
        let a = self.chatData[indexPath.row].unreadCount! as! Int
        c += a
        print(c)
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let receiveMessageNickname = tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "N/A"
//         let OtherGoogleName = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text ?? "N/A"
        let receiveMessageNickname = self.chatData[indexPath.row].chatRoomName
        let OtherGoogleName =  self.chatData[indexPath.row].otherGoogleName
        self.receiveMessageNickname = receiveMessageNickname
        self.receiveMessageGoogleName =  OtherGoogleName
        
           performSegue(withIdentifier: "personalMessage", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "personalMessage"{
            let personalMessage = segue.destination as! chatTable
            personalMessage.otherNickName = self.receiveMessageNickname
            personalMessage.otherGoogleName = self.receiveMessageGoogleName
         
        }
    }
    
    
 var allMessageCount : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoredataShare.share.loadData()
        queryFirestore()
       queryFirestore2()
        
    }
    
    
    var unread : String?
    func queryFirestore2( ){
         
        
         let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        self.db.collection("user").document(myGoogleName).collection("Messages").addSnapshotListener { (data, error) in
            for otherID in data!.documents{
               
                self.db.collection("user").document(myGoogleName).collection("Messages").document(otherID.documentID).collection("Message").whereField("read", isEqualTo: false).addSnapshotListener { (query, error) in
                           if let error = error{ print("query Faild\(error)") }
                    guard let query = query else {return}
                            let documentChange = query.documents
                         for change in documentChange{
                               //處理每一筆更新
//
                            self.db.collection("user").document(myGoogleName).collection("Messages").document(otherID.documentID).setData(["unRead":"\(query.count)"],merge: true)
                            change.data()
                          
                            }
                       }
            }
        }
   
          
//         self.db.collection("user").document(myGoogleName).collection("Messages").document("花滿").collection("Message").whereField("read", isEqualTo: false).addSnapshotListener { (query, error) in
//               if let error = error{ print("query Faild\(error)") }
//
//               guard let documentChange = query?.documents else {return}
//             for change in documentChange{
//                   //處理每一筆更新
//                 self.tabBarItem.badgeValue = "\(query!.count)"
//
// //                 self.db.collection("user").document(myGoogleName).collection("Messages").document(self.otherNickName).collection("Message").document(change.documentID).setData(["read":true], merge: true) { (error) in
// //                    if let e = error{
// //                        print(e)
// //                    }
// //                    print(query?.count)
// //                }
// //                     print(query?.count)
// //                      let note = ChatNote()
// //                      note.SendMessage = change.document.data()["send"] as? String
// //                      note.ReceiveMessage = change.document.data()["receive"] as? String
// //                      self.data.insert(note, at: 0)
// //                      let indexPath = IndexPath(row: 0, section: 0)
// //                      self.tableview.insertRows(at: [indexPath], with: .automatic)
//
//               }
//           }
       }
      func queryFirestore(){
      let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        db.collection("user").document(myGoogleName).collection("Messages").addSnapshotListener { (query, error) in
            if let error = error{
                print("query Faild\(error)")
            }
   
            guard let documentChange = query?.documentChanges else {return}
            for change in documentChange{
                //處理每一筆更新
                if change.type == .added{
                    
                    let chatlist = chatRoomList()
                    chatlist.chatRoomName = change.document.documentID
                    chatlist.otherGoogleName = change.document.data()["otherGoogleName"] as? String
                    chatlist.unreadCount = change.document.data()["unRead"] as? String
                    self.chatData.insert(chatlist, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableview.insertRows(at: [indexPath], with: .automatic)

                  
                    
                }
 
                   }
               }
        }
    }
  

 
