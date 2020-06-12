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

class ChatList: UIViewController,UITableViewDelegate,UITableViewDataSource  {
   
    
 
    var db = Firestore.firestore()
    @IBOutlet weak var tableview: UITableView!
    var chatData : [chatRoomList] = []
    var receiveMessageNickname : String!
    var receiveMessageGoogleName : String!
    var allUnreadCounts   = 0
    var allcount = 0
    var allMessageCount : Int!
    var ocount = 0
    var unread : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoredataShare.share.loadData()
       viewInChatListUpdate()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        queryFirestore()
        updatePersonalUnreadCounts()
    }
    
    
   
    func queryFirestore(){
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() == true {GIDSignIn.sharedInstance()?.restorePreviousSignIn() }
        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        db.collection("user").document(myGoogleName).collection("Messages").addSnapshotListener { (query, error) in
            if let error = error{
                print("query Faild\(error)")
            }
            guard let documentChange = query?.documentChanges else {return}
            for change in documentChange{
                let documentID = change.document.documentID
                
                //處理每一筆更新
                if change.type == .added{
                    let chatlist = chatRoomList()
                    chatlist.chatRoomName = change.document.documentID
                    print(documentID)
                    chatlist.otherGoogleName = change.document.data()["otherGoogleName"] as? String
                    chatlist.unreadCount = change.document.data()["unRead"] as? String
                    self.chatData.insert(chatlist, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.allUnreadCounts += Int(self.chatData.first!.unreadCount!)!
                    self.tabBarItem.badgeValue = String(self.allUnreadCounts)
                }
                else if change.type == .modified{ //修改
                    self.ocount = 0
                    if let otherGoogleName = self.chatData.filter({ (otherGoogleName) -> Bool in
                        otherGoogleName.otherGoogleName == documentID
                    }).first{
                        otherGoogleName.unreadCount = change.document.data()["unRead"] as! String
                        self.updateTabbarItembadge()
                        print(self.allUnreadCounts)
                    }
                    
                }
                
            }
        }
    }
    func updatePersonalUnreadCounts( ){
          let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
          self.db.collection("user").document(myGoogleName).collection("Messages").addSnapshotListener { (data, error) in
              for otherID in data!.documents{
                  self.db.collection("user").document(myGoogleName).collection("Messages").document(otherID.documentID).collection("Message").whereField("read", isEqualTo: false).addSnapshotListener { (query, error) in
                      if let error = error{ print("query Faild\(error)") }
                      guard let query = query else {return}
                      let documentChange = query.documents
                      for change in documentChange{
                          //處理每一筆更新
                          self.db.collection("user").document(myGoogleName)
                              .collection("Messages")
                              .document(otherID.documentID)
                              .setData(["unRead":"\(query.count)"],merge: true)
                      }
                  }
              }
          }
          
      }
   
    func updateTabbarItembadge (){
        var tempInt = 0
        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        
        db.collection("user").document(myGoogleName).collection("Messages").addSnapshotListener { (query, error) in
            if let error = error{
                print("query Faild\(error)")
            }
            
            guard let documentChange = query?.documentChanges else {return}
            for i in query!.documents{
                var readString = i.data()["unRead"] as! String
                var IntString = Int(readString)!
                tempInt += IntString
                print(self.ocount)
            }
            self.ocount = tempInt
            self.db.collection("user").document(myGoogleName).setData(["unread":"\(self.ocount)"],merge: true)
            self.tabBarItem.badgeValue = String(self.ocount)
        }
    }
    
     
    func viewInChatListUpdate(){
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() == true {GIDSignIn.sharedInstance()?.restorePreviousSignIn() }
        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        db.collection("user").document(myGoogleName).collection("Messages").addSnapshotListener { (query, error) in
            if let error = error{
                print("query Faild\(error)")
            }
            
            guard let documentChange = query?.documentChanges else {return}
            for change in documentChange{
                let documentID = change.document.documentID
                
                //處理每一筆更新
                if change.type == .added{
                    self.tableview.reloadData()
                }
                else if change.type == .modified{ //修改
                    self.ocount = 0
                    
                    if let otherGoogleName = self.chatData.filter({ (otherGoogleName) -> Bool in
                        otherGoogleName.otherGoogleName == documentID
                    }).first{
                        otherGoogleName.unreadCount = change.document.data()["unRead"] as! String
                        
                        if let index = self.chatData.index(of: otherGoogleName){
                            let indexPath = IndexPath(row: index, section: 0)
                            self.tableview.reloadRows(at: [indexPath], with: .automatic)
                            self.tableview.reloadData()
                        }
                    }
                }
            }
        }
    }


     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.chatData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let view = UIView()
            view.backgroundColor = .red
            let cell = tableview.dequeueReusableCell(withIdentifier: "ChatListCustomCell", for: indexPath) as! ChatListCustomCell
            cell.OtherName.text = self.chatData[indexPath.row].chatRoomName
            cell.userSubtitle.alpha = 0
            cell.userSubtitle.text = self.chatData[indexPath.row].otherGoogleName
            cell.userImage.image = UIImage(named: "avataaars")
            cell.unreadMessageCount.text =  self.chatData[indexPath.row].unreadCount

           
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
    
}
