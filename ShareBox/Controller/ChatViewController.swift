//
//  mychatviewVC.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/7/15.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView
import CoreData
struct Message : MessageType{
       var sender: SenderType
       var messageId: String
       var sentDate: Date
       var kind: MessageKind
   }
 struct Sender: SenderType {

      var senderId: String
      var displayName: String
  }

class ChatViewController: MessagesViewController,MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate,InputBarAccessoryViewDelegate   {

    let currentUser =  Sender(senderId: "self", displayName: "me")
    let otherUser =  Sender(senderId: "other", displayName: "other")
    var messages : [MessageType] = []
    var myCoredataMessage : [ChatMessageKit] = []
    var otherNickName : String!
    var otherUID : String!
    var myUID = Auth.auth().currentUser?.uid
    var myNickName : String!
   
    
     
    override func viewDidDisappear(_ animated: Bool) {
           super.viewDidDisappear(true)
//        CoredataShareMessage.share.moc.reset() 
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        getMyUID()
//        loadLocalData()
       StartChat()
       
    }

    
    
    
    func StartChat(){
        
        //         self.messages.append(Message(sender: self.currentUser, messageId: "1", sentDate: Date(), kind: .text("eqwe")))
//        self.db.collection("user").document(myUID!).collection("Messages").document(otherNickName).collection("Message").whereField("time", isGreaterThan: CoredataShareMessage.share.data.last?.time ?? "2000:08:03 00:57:49").order(by: "time",descending: false).limit(to: 20) .addSnapshotListener {
        self.db.collection("user").document(myUID!).collection("Messages").document(otherNickName).collection("Message").getDocuments(source: .cache) { (query, error) in
             
//                   (query, error) in
            
                    if  let error = error {  print("Error:\(error)");  return   }
            
                   print(CoredataShareMessage.share.data.last?.time )
                                guard let documentChange = query?.documentChanges else {return}
                     
                                for change in documentChange{
//                                   letmydata = ChatMessageKit(context: CoredataShareMessage.share.myContextMessage)
                                  
                                    //處理每一筆更新
                                     
                                    if change.type == .added{
//                                        var mydata = ChatMessageKit(context: CoredataShareMessage.share.moc)
                                        
                                        
                //                       note(sender: self.currentUser, messageId: "qwe", sentDate: Date().addingTimeInterval(-46400), kind: .text("qwe"))
                                        if  change.document.data()["send"] != nil{
                                            
                                               self.messages.append(Message(sender: self.currentUser, messageId: "1", sentDate: Date(), kind: .text("\( change.document.data()["send"] as! String)")))
                                           
//                                            mydata.message = change.document.data()["send"] as? String ?? "?"
//                                            mydata.time = change.document.documentID
//                                            mydata.type = "send"
//                                            mydata.otherUID = self.otherUID
//                                              CoredataShareMessage.share.saveData()
                                            
                                             
                                        }
                                        if  change.document.data()["receive"] != nil{
                                            
                                            self.messages.append(Message(sender: self.otherUser, messageId: "2", sentDate: Date(), kind: .text("\( change.document.data()["receive"] as! String)")))
//                                            mydata.message = change.document.data()["receive"] as? String ?? "?"
//                                            mydata.time = change.document.documentID
//                                            mydata.type = "receive"
//                                            mydata.otherUID = self.otherUID
//                                                 CoredataShareMessage.share.saveData()
                                        }
//                                          CoredataShareMessage.share.saveData()
                                       
                                         self.messagesCollectionView.reloadData()
//                                         self.myCoredataMessage.append(  mydata)
//                                        self.messagesCollectionView.scrollToBottom()
                                    }
                                }
            self.messagesCollectionView.scrollToBottom()
                   
                            }
                
              
  
                // Do any additional setup after loading the view.
                messageInputBar.inputTextView.tintColor = .blue
                messageInputBar.sendButton.setTitleColor(.brown, for: .normal)
        //        messageInputBar.sendButton.title = "發送"
                messageInputBar.sendButton.setImage(UIImage(named: "a4"), for: .normal)
         
    }
    
    
    
    
    
    
        func loadLocalData(){
            CoredataShareMessage.share.loadData(otherUID: self.otherUID)
            for data in  CoredataShareMessage.share.data{
                if data.type == "receive" {
                    self.messages.append(Message(sender: self.otherUser,
                                                 messageId: "1",
                                                 sentDate: Date(),
                                                 kind: .text("\(data.message)")))
                  
                }else{
                    self.messages.append(Message(sender: self.currentUser,
                                                 messageId: "2",
                                                 sentDate: Date(),
                                                 kind: .text("\(data.message)")))
                }
            }
              messagesCollectionView.scrollToBottom()
        }
    
    
    
        func getMyUID(){
            self.db.collection("user").document(myUID!).getDocument { (data, error) in
                if let data = data {
                    self.myNickName = data["nickName"] as? String ?? "N/A"
                }
            }
        }
    
 func currentSender() -> SenderType {
     return currentUser
 }
 
 func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    return messages[indexPath.section]
    
 }
 
 func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    messagesCollectionView.reloadData()
    return messages.count
    
 }
     
//
    
    
    
    let db = Firestore.firestore()
    
    
    
    
//MARK: -> Send Message
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        self.messageInputBar.inputTextView.resignFirstResponder()
        messagesCollectionView.endEditing(true)
        inputBar.endEditing(true)
        inputBar.inputTextView.text = ""
       
//        self.messageInputBar.endEditing(true)
        
        self.db.collection("user").document(myUID!).collection("Messages").document(self.otherNickName).setData(["otherUID": self.otherUID ?? "N/A"
            ]) { (error) in
                if let error = error{
                               print("error\(error.localizedDescription)")
                           }
                self.db.collection("user").document(self.myUID!).collection("Messages").document(self.otherNickName).collection("Message").document(self.currentTime()).setData(["send":"\(text)","time":self.currentTime()])
            }
        
          self.db.collection("user").document(self.otherUID).collection("Messages").document( self.myNickName).setData(["otherUID":myUID!]) { (error) in
                 if let error = error{
                     print("error\(error.localizedDescription)")
                 }
            self.db.collection("user").document(self.otherUID).collection("Messages").document( self.myNickName).collection("Message").document(self.currentTime()).setData(["receive":"\(text)","time":self.currentTime()])
             }
        
        
//        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
    
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.senderId == "self"{
            
            avatarView.image = UIImage(named: "a4")
        }else{
            avatarView.image = UIImage(named: "a5")

        }
    }
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)
    }
   
    
   func currentTime () -> String   {
          let now = Date()
          let dateformatter = DateFormatter()
          dateformatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
          let currentTime = dateformatter.string(from: now)
          
          return currentTime
          
      }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let ContetHeigh = scrollView.contentSize.height
        let framsize = scrollView.frame.size.height
        print("offset\(offsetY)")
        print("ContetHeigh\(ContetHeigh)")
           print("framsize\(framsize)")
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.section)
    }
    
}
