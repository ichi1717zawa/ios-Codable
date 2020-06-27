//
//  chatTable.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/2.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class chatTable: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
        static var Share = chatTable()
    @IBOutlet weak var userImage: UIImageView!
    var otherGoogleName: String!
        var otherUID:String!
        var otherNickName: String!
        var db = Firestore.firestore()
        var data : [ChatNote] = []
        var receiveMessageNickname : String!
        let my = CoredataShare.share.data.first?.nickname
        var myNickName : String!
        let dummyString = ["9":"9"]
    let myUID : String! = Auth.auth().currentUser?.uid
        @IBOutlet weak var textField: UITextField!
        @IBOutlet weak var textFieldTopAnchor: NSLayoutConstraint!
        @IBOutlet weak var textFieldBottomAnchor: NSLayoutConstraint!
        @IBOutlet weak var tableview: UITableView!
        var tempOriginY : CGFloat!
    
    
//     let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { self.data.count }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! chatTableCell
        if let data = self.data[indexPath.row].SendMessage {

            cell.messageTitle.text = data
            cell.messageTitle.textAlignment = .right
            cell.userImage.image = nil
        }else{
//
            cell.userImage.image = UIImage(named: "avataaars")
            cell.messageTitle.text = self.data[indexPath.row].ReceiveMessage
            cell.messageTitle.textAlignment = .left
          
        }
        cell.contentView.transform = CGAffineTransform(rotationAngle: .pi)
        return cell
    }
    
  
   
    
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navagationBar.topItem?.title = otherNickName
       
        
        
        print(self.tableview.frame.origin.y)
        self.db.collection("user").document(myUID).getDocument { (data, error) in
            if let data = data {
                self.myNickName = data["nickName"] as? String ?? "N/A"
            }
        }
        
        self.textField.delegate = self
        queryFirestore()
        self.tableview.transform = CGAffineTransform(rotationAngle: .pi)
//        queryFirestore2()
    }
    
 
    func queryFirestore2(){
//          let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        self.db.collection("user").document(myUID).collection("Messages").document(self.otherNickName).collection("Message").whereField("read", isEqualTo: false).addSnapshotListener { (query, error) in
              if let error = error{ print("query Faild\(error)") }
           
              guard let documentChange = query?.documents else {return}
            for change in documentChange{
                  //處理每一筆更新
                self.tabBarItem.badgeValue = "\(query?.count)"
                    
//                 self.db.collection("user").document(myGoogleName).collection("Messages").document(self.otherNickName).collection("Message").document(change.documentID).setData(["read":true], merge: true) { (error) in
//                    if let e = error{
//                        print(e)
//                    }
//                    print(query?.count)
//                }
//                     print(query?.count)
//                      let note = ChatNote()
//                      note.SendMessage = change.document.data()["send"] as? String
//                      note.ReceiveMessage = change.document.data()["receive"] as? String
//                      self.data.insert(note, at: 0)
//                      let indexPath = IndexPath(row: 0, section: 0)
//                      self.tableview.insertRows(at: [indexPath], with: .automatic)
                   
              }
          }
      } //暫時沒用
    
    func queryFirestore(){
//        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        self.db.collection("user").document(myUID).collection("Messages").document(self.otherNickName).collection("Message").addSnapshotListener { (query, error) in
            if let error = error{ print("query Faild\(error)") }
            guard let documentChange = query?.documentChanges else {return}
            for change in documentChange{
                //處理每一筆更新
                if change.type == .added{
                    let note = ChatNote()
                    note.SendMessage = change.document.data()["send"] as? String
                    note.ReceiveMessage = change.document.data()["receive"] as? String
                    self.data.insert(note, at: 0)
//                    self.data.append(note)
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableview.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    
    func clearViewCounts(){
          db.collection("user").document(myUID).collection("Messages").document(otherNickName).collection("Message").whereField("read", isEqualTo: false).getDocuments { (query, error) in
              
              guard let query = query?.documents else {return}
              for i in query{
                  self.db.collection("user").document(self.myUID).collection("Messages").document(self.otherNickName).collection("Message").document(i.documentID).setData(["read":""],merge: true)
              }
          }
      }
     func currentTime () -> String   {
         
        
         let now = Date()
         let dateformatter = DateFormatter()
         dateformatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
         let currentTime = dateformatter.string(from: now)
         
         return currentTime
         
     }
    
    
    func currentTimeUncludeYear () -> String   {
         
        
         let now = Date()
         let dateformatter = DateFormatter()
         dateformatter.dateFormat = "MM/dd HH:mm"
         let currentTime = dateformatter.string(from: now)
         return currentTime
         
     }
     
    @IBAction func sendMessage(_ sender: Any) {
        let currentTime :String! = self.currentTimeUncludeYear()
 
//        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name! 
        let sendParameter :[String : Any]
        let receiveParameter :[String : Any]
//         sendParameter = ["send":"\(myNickName ?? "N/A"):\(self.textField.text ?? "N/A")","time":currentTime ?? ""]
        sendParameter = ["send":"\(self.textField.text ?? "N/A")","time":currentTime ?? ""]
        receiveParameter = ["receive":"\(self.textField.text ?? "N/A")","time":currentTime ?? "" ,"read":false]
//
        self.db.collection("user").document(myUID).collection("Messages").document(self.otherNickName).setData(["otherUID":self.otherUID ?? "N/A"
        ]) { (error) in
            self.db.collection("user").document(self.myUID).collection("Messages").document(self.otherNickName).collection("Message").document(self.currentTime ()).setData(sendParameter)
        }

      
        self.db.collection("user").document(self.otherUID).collection("Messages").document( self.myNickName).setData(["otherUID":myUID!]) { (error) in
            self.db.collection("user").document(self.otherUID).collection("Messages").document( self.myNickName).collection("Message").document(self.currentTime ()).setData(receiveParameter)
        }
        
        self.textField.text = ""
    }
    
    
//    @objc private func handle(keyboardShowNotification notification: Notification) -> CGFloat  {
//          // 1
//          print("Keyboard show notification")
//          // 2
//          if let userInfo = notification.userInfo,
//          // 3
//              let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//              print(keyboardRectangle.height)
//              return keyboardRectangle.height
//          }
//          return 0.0
//
//      }
 
          func textFieldDidBeginEditing(_ textField: UITextField) {
//             self.tableview.frame.origin.y - 500
//             NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notificaton:)), name: UIResponder.keyboardWillShowNotification, object: nil)
          }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.tableview.topAnchor.constraint(equalTo: self.textField.topAnchor, constant: 0).isActive = true
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notificaton:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
//



    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
               textField.resignFirstResponder()
               return true
           }

    
    
    var viewOriginSize : CGFloat!
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(true)
//        let indexpath = IndexPath(row: self.data.count - 1, section: 0)
//        self.tableview.scrollToRow(at: indexpath, at: .bottom, animated: true)
                 
       viewOriginSize = self.view.frame.size.height
      clearViewCounts()
      }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(self.view.frame.size.height)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
         clearViewCounts()
         NotificationCenter.default.removeObserver(self)
        
     }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
         
    }
    
    @objc func keyboardWillHide(notification : Notification)  {
     self.view.transform = CGAffineTransform(translationX: 0, y: 0)
//       self.view.frame.size.height +=  viewOriginSize
//        self.view.frame.size.height += 1200
     }

    
    @IBOutlet weak var sendButton: UIButton!
    
    @objc func keyBoardWillShow ( notification : Notification ){
        self.navigationController?.isNavigationBarHidden = false
//        self.tableview.frame.origin.y = super.view.frame.origin.y + (  self.navagationBar.frame.height)
      
        if let userInfo = notification.userInfo,
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect{
//            self.tableview.frame = self.tableview.frame.offsetBy(dx: 0, dy: -200)
            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height + 34  )
//
//             print( self.tableview.frame.size.height)
//            self.tableview.frame.size.height =  (self.view.frame.size.height - keyboardRectangle.height + self.textField.frame.size.height)
//            self.view.frame.size.width = super.view.frame.size.width
            
            
        }
           
            
           
       
 
    }
    @IBAction func backToRoot(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
       
    }
   
    @IBOutlet weak var navagationBar: UINavigationBar!
    
}
