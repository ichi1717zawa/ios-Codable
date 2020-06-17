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
        var otherGoogleName: String!
        var otherNickName: String!
        var db = Firestore.firestore()
        var data : [ChatNote] = []
        var receiveMessageNickname : String!
        let my = CoredataShare.share.data.first?.nickname
        var myNickName : String!
        let dummyString = ["9":"9"]
        @IBOutlet weak var textField: UITextField!
        @IBOutlet weak var textFieldTopAnchor: NSLayoutConstraint!
        @IBOutlet weak var textFieldBottomAnchor: NSLayoutConstraint!
        @IBOutlet weak var tableview: UITableView!
        var tempOriginY : CGFloat!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { self.data.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell
        if let data = self.data[indexPath.row].SendMessage {
            cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = data
            cell.textLabel?.textAlignment = .right
        }else{
            cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = self.data[indexPath.row].ReceiveMessage
            cell.textLabel?.textAlignment = .left
        }
        cell.contentView.transform = CGAffineTransform(rotationAngle: .pi)
        return cell
    }
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       tempOriginY = self.textField.frame.origin.y
        
        
        print(self.tableview.frame.origin.y)
        self.db.collection("user").document( GIDSignIn.sharedInstance()!.currentUser!.profile.name!).getDocument { (data, error) in
            if let data = data {
                self.myNickName = data["nickName"] as? String ?? "N/A"
            }
        }
        
        self.textField.delegate = self
        queryFirestore()
        self.tableview.transform = CGAffineTransform(rotationAngle: .pi)
        queryFirestore2()
    }
    

    func queryFirestore2(){
          let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        self.db.collection("user").document(myGoogleName).collection("Messages").document(self.otherNickName).collection("Message").whereField("read", isEqualTo: false).addSnapshotListener { (query, error) in
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
      }
    
    func queryFirestore(){
        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        self.db.collection("user").document(myGoogleName).collection("Messages").document(self.otherNickName).collection("Message").addSnapshotListener { (query, error) in
            if let error = error{ print("query Faild\(error)") }
            guard let documentChange = query?.documentChanges else {return}
            for change in documentChange{
                //處理每一筆更新
                if change.type == .added{
                    let note = ChatNote()
                    note.SendMessage = change.document.data()["send"] as? String
                    note.ReceiveMessage = change.document.data()["receive"] as? String
                    self.data.insert(note, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableview.insertRows(at: [indexPath], with: .automatic)
                }
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
     
    @IBAction func sendMessage(_ sender: Any) {
//
//        getUserData.share.getUserNickName { (string) in
//            print(string)
//        }
        //*************以下送訊息以上參考
        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
//        print(myGoogleName)
//        //        let otherNickName = self.receiveMessageNickname!
//
        let sendParameter = ["send":"\(myNickName ?? "N/A"):\(self.textField.text ?? "N/A")"]
        let receiveParameter = ["receive":"\(myNickName ?? "N/A"):\(self.textField.text ?? "N/A")"]
//
        self.db.collection("user").document(myGoogleName).collection("Messages").document(self.otherNickName).setData(["otherGoogleName":self.otherGoogleName ?? "N/A"
        ]) { (error) in
            self.db.collection("user").document(myGoogleName).collection("Messages").document(self.otherNickName).collection("Message").document(self.currentTime ()).setData(sendParameter)
        }

        self.db.collection("user").document(self.otherGoogleName).collection("Messages").document( self.myNickName).setData(["otherGoogleName":myGoogleName]) { (error) in
            self.db.collection("user").document(self.otherGoogleName).collection("Messages").document( self.myNickName).collection("Message").document(self.currentTime ()).setData(receiveParameter)
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

    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         NotificationCenter.default.removeObserver(self)
     }
    
    @objc func keyboardWillHide(notification : Notification)  {
         let info = notification.userInfo!
         //回復原本的位置,注意這裏的duration 要設的跟66行一樣，可以自行調整
        
//             self.view.frame = self.originalFrame!
//            self.textField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: 0 ).isActive = true
             self.view.transform = CGAffineTransform(translationX: 0, y: 0)
//            self.tableview.frame.origin.y = super.view.frame.origin.y
              print("qwe")
        
     }
    
    @IBOutlet weak var qwe1: NSLayoutConstraint!
    @IBOutlet weak var qwe2: NSLayoutConstraint!
    @IBOutlet weak var qwe3: NSLayoutConstraint!
//    @IBOutlet weak var qwe4: NSLayoutConstraint!
//    @IBOutlet weak var qwe5: NSLayoutConstraint!
//    @IBOutlet weak var qwe6: NSLayoutConstraint!
//    @IBOutlet weak var qwe7: NSLayoutConstraint!
    @IBOutlet weak var sendMessageControll: UIStackView!
    @IBOutlet weak var sendButton: UIButton!
    @objc func keyBoardWillShow ( notification : Notification ){
        
        if let userInfo = notification.userInfo,
        let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {

           
            print(self.tableview.contentSize.height)
//
            
//            textField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -keyboardRectangle.height ).isActive = true
            
//
//            self.textField.frame.origin.y = keyboardRectangle.minY - 30
            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height + 34 )
           
        }
 
    }
    
}
