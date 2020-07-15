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

    let currentUser =  Sender(senderId: "self", displayName: "ios yi")
      let otherUser =  Sender(senderId: "other", displayName: "ios mio")
    var messages : [MessageType] = []
    var myCoredataMessage : [ChatMessageKit] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoredataShareMessage.share.loadData()
        
        for data in  CoredataShareMessage.share.data{
                                  print(data.message)
                              }
        
//         self.messages.append(Message(sender: self.currentUser, messageId: "1", sentDate: Date(), kind: .text("eqwe")))
          self.db.collection("user").document("ZxuAIeSEWmMVacLapW0aPTq5gOu1").collection("Messages").document("蘇蘇").collection("Message").addSnapshotListener { (query, error) in
                         if  let error = error {
                            print("Error:\(error)")
                            return
                          }
                        guard let documentChange = query?.documentChanges else {return}
                        for change in documentChange{
                            
                      
                             let mydata = ChatMessageKit(context: CoredataShareMessage.share.myContextMessage)
                            //處理每一筆更新
                            if change.type == .added{
        //                       note(sender: self.currentUser, messageId: "qwe", sentDate: Date().addingTimeInterval(-46400), kind: .text("qwe"))
                                if  change.document.data()["send"] != nil{
                                     self.messages.append(Message(sender: self.currentUser, messageId: "1", sentDate: Date(), kind: .text("\( change.document.data()["send"] as? String)")))
                                    mydata.message = change.document.data()["send"] as? String ?? "?"
                                    mydata.time = change.document.data()["time"] as? String ?? "?"
                                    mydata.type = "send"
                                
                                } else if  change.document.data()["receive"] != nil{
                                     self.messages.append(Message(sender: self.otherUser, messageId: "2", sentDate: Date(), kind: .text("\( change.document.data()["receive"] as? String)")))
                                    mydata.message = change.document.data()["receive"] as? String ?? "?"
                                    mydata.time = change.document.data()["time"] as? String ?? "?"
                                    mydata.type = "receive"
                                }
                                
//                                print(change.document.data()["send"] as? String)
                                self.messagesCollectionView.reloadData()
                                self.messagesCollectionView.scrollToBottom()
                                
                                self.myCoredataMessage.append(mydata)
//
                               
        //                        note.SendMessage = change.document.data()["send"] as? String
        //                        note.ReceiveMessage = change.document.data()["receive"] as? String
                               
            //                    self.data.append(note)
                             
                                
                            }
//                             CoredataShareMessage.share.saveData()
                        }
                    }
//
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self

        // Do any additional setup after loading the view.
        messageInputBar.inputTextView.tintColor = .blue
        messageInputBar.sendButton.setTitleColor(.brown, for: .normal)
//        messageInputBar.sendButton.title = "發送"
        messageInputBar.sendButton.setImage(UIImage(named: "a4"), for: .normal)
        
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
     
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    let db = Firestore.firestore()

    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        self.messageInputBar.inputTextView.resignFirstResponder()
         
        messagesCollectionView.endEditing(true)
        inputBar.endEditing(true)
        inputBar.inputTextView.text = ""
       
        self.messageInputBar.endEditing(true)
        
        self.db.collection("user").document("ZxuAIeSEWmMVacLapW0aPTq5gOu1").collection("Messages").document("蘇蘇").setData(["otherUID":"5u8hq9u3v6bKIAsViCeVq6TiL553" ?? "N/A"
            ]) { (error) in
                if let error = error{
                               print("error\(error.localizedDescription)")
                           }
                self.db.collection("user").document("ZxuAIeSEWmMVacLapW0aPTq5gOu1").collection("Messages").document("蘇蘇").collection("Message").document("\(Date())").setData(["send":"\(text)"])
            }
        
        messagesCollectionView.reloadData()
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
   
    
   
}
