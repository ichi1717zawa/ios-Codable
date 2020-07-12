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
    var receiveMessageOtherUID:String!
    let myUID : String! = Auth.auth().currentUser?.uid
//    let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
           self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
//       self.navigationController?.isNavigationBarHidden = true
        
//        CoredataShare.share.loadData()
//       viewInChatListUpdate()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
         self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor(named: "聊天室背景色")
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder) 
        queryFirestore()
          
        updatePersonalUnreadCounts()
        updateTabbarItembadge()
        
//        getSumUnRead ()
 
         
    }
    
    
   
    func queryFirestore(){
        
//        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() == true {GIDSignIn.sharedInstance()?.restorePreviousSignIn() }
//        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        
        db.collection("user").document(myUID).collection("Messages").addSnapshotListener { (query, error) in
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
                    chatlist.otherGoogleName = change.document.data()["otherGoogleName"] as? String
                    chatlist.unreadCount = change.document.data()["unRead"] as? String
                    chatlist.otherUID = change.document.data()["otherUID"] as? String
                    self.chatData.insert(chatlist, at: 0)
//                    let indexPath = IndexPath(row: 0, section: 0)
//                    self.allUnreadCounts += Int(self.chatData.first!.unreadCount!)!
//                    self.tabBarItem.badgeValue = String(self.allUnreadCounts)
                }
                else if change.type == .modified{ //修改
                    self.ocount = 0
                    if let otherUID = self.chatData.filter({ (otherUID) -> Bool in
                          otherUID.chatRoomName == documentID
                       
//                        otherUID.otherUID
                    }).first{
                        
//                        self.updatePersonalUnreadCounts( )
                        otherUID.unreadCount = change.document.data()["unRead"] as? String
                        
//                        if let index = self.chatData.firstIndex(of: otherUID){
//                            let indexPath = IndexPath(row: index, section: 0)
//                            self.tableview.reloadRows(at: [indexPath], with: .automatic)
//                            
//                            
//                        }
                       
                        if self.tableview != nil{
//                            tableview.reloadData()
//                            tableview.reloadRows(at: [indexPath], with: .automatic)
                             self.tableview.reloadData()
                        }
//                        self.updateTabbarItembadge()
                        print("yes")
                    }
                    
                }
                
            }
        }
    }
    func updatePersonalUnreadCounts( ){
 
//          let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        self.db.collection("user").document(myUID).collection("Messages").addSnapshotListener { (data, error) in
            if error != nil{
                return
            }
            for otherID in data!.documents{
   
                self.db.collection("user").document(self.myUID).collection("Messages").document(otherID.documentID).collection("Message").whereField("read", isEqualTo: false).addSnapshotListener { (query, error) in
                    if let error = error{ print("query Faild\(error)") }
                    guard let query = query else {return}
                    
                    //處理每一筆更新
                    self.db.collection("user").document(self.myUID)
                        .collection("Messages")
                        .document(otherID.documentID)
                        .setData(["unRead":"\(query.count)"],merge: true)
                      
                      
                  }
               
              }
//            self.ocount = tempInt
            
//            self.db.collection("user").document(myGoogleName).setData(["unread":"\(tempInt)"],merge: true)
//            self.tabBarItem.badgeValue = String(self.ocount)
          }
          
      }
   
    func getSumUnRead (){
        
//        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        db.collection("user").document(myUID).getDocument { (query, error) in
            if let error = error{
                print("query Faild\(error)")
            }
            guard let query = query  else {return}
            self.tabBarItem.badgeValue =   query.data()?["unread"] as? String
        }
    }
    
    
    func updateTabbarItembadge (){
//        var tempInt = 0
//        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        db.collection("user").document(myUID).collection("Messages").addSnapshotListener { (query, error) in
             if  let error   = error {
             print("query Faild\(error)")
                return
            }
           
//            guard let documentChange = query?.documentChanges else {return}
            for i in query!.documents{
                let readString = i.data()["unRead"] as? String
                let IntString = Int(readString ?? "")
                self.ocount += IntString ?? 0
//                self.ocount = tempInt
//                  self.db.collection("user").document(myGoogleName).setData(["unread":"\(tempInt)"],merge: true)
            }
//            self.ocount = tempInt
            self.db.collection("user").document(self.myUID).setData(["unread":"\(self.ocount)"],merge: true)
            if self.ocount == 0{
                self.navigationController?.tabBarItem.badgeColor = .white
                self.navigationController?.tabBarItem.badgeValue = ""
            }else{
                self.navigationController?.tabBarItem.badgeColor = UIColor(named: "myOrangeColor")
             self.navigationController?.tabBarItem.badgeValue  = String(self.ocount)
            }
 
        }
              
    }
    
     
    func viewInChatListUpdate(){
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() == true {GIDSignIn.sharedInstance()?.restorePreviousSignIn() }
//        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        db.collection("user").document(myUID).collection("Messages").addSnapshotListener { (query, error) in
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
                    
                    if let otherUID = self.chatData.filter({ (otherUID) -> Bool in
                        otherUID.otherUID == documentID
                    }).first{
                        otherUID.unreadCount = change.document.data()["unRead"] as? String
                        
//                        if let index = self.chatData.firstIndex(of: otherUID){
//                            let indexPath = IndexPath(row: index, section: 0)
//                            self.tableview.reloadRows(at: [indexPath], with: .automatic)
//                            self.tableview.reloadData()
//                        }
                        self.tableview.reloadData()
                    }
                }
            }
        }
    }//沒用到

    
   

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.chatData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let view = UIView()
            view.backgroundColor = .red
            let cell = tableview.dequeueReusableCell(withIdentifier: "ChatListCustomCell", for: indexPath) as! ChatListCustomCell
            cell.OtherName.text = self.chatData[indexPath.row].chatRoomName
            cell.userSubtitle.alpha = 0
            cell.userSubtitle.text = self.chatData[indexPath.row].otherUID
            cell.userImage.image = UIImage(named: "avataaars")
            
            cell.unreadMessageCount.text =  self.chatData[indexPath.row].unreadCount
             
            db.collection("user").document(myUID).collection("Messages").document("\(self.chatData[indexPath.row].chatRoomName ?? "??")").collection("Message").order(by: "time", descending: true).limit(to: 1).getDocuments(source: .cache, completion: { (query, error)  in
           if let query = query{
          cell.messageTime.text =   query.documents.first?.data()["time"] as? String ?? "??"
                }
               })
            db.collection("user").document(myUID).collection("Messages").document("\(self.chatData[indexPath.row].chatRoomName ?? "??")").collection("Message").order(by: "time", descending: true).limit(to: 1).getDocuments(source: .cache, completion: { (query, error)  in
                      if let query = query{
                     cell.lastMessage.text =   query.documents.first?.data()["send"] as? String ?? query.documents.first?.data()["receive"] as? String
                           }
                          })
            
            if cell.unreadMessageCount.text != "0"{
                cell.countMessageView.alpha = 0
                cell.unreadMessageCount.alpha = 0
                cell.countMessageView.alpha = 1
                                  cell.unreadMessageCount.alpha = 1
                cell.countMessageView.backgroundColor =  UIColor(named: "newOrangeColor")
                               cell.unreadMessageCount.textColor = .black
               
            }else{
                cell.countMessageView.backgroundColor = . white
                cell.unreadMessageCount.textColor = .white
                cell.countMessageView.alpha = 1
                    cell.unreadMessageCount.alpha = 1
            }
           
            return cell
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let receiveMessageNickname = tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "N/A"
    //         let OtherGoogleName = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text ?? "N/A"
            let receiveMessageNickname = self.chatData[indexPath.row].chatRoomName
            let otherUID =  self.chatData[indexPath.row].otherUID
            self.receiveMessageNickname = receiveMessageNickname
            self.receiveMessageOtherUID =  otherUID
               performSegue(withIdentifier: "personalMessage", sender: nil)
            
        }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "personalMessage"{
                let personalMessage = segue.destination as! chatTable
                personalMessage.otherNickName = self.receiveMessageNickname
                personalMessage.otherUID = self.receiveMessageOtherUID
             
            }
        }
  
    
}

