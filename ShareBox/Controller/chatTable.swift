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
        
        self.db.collection("user").document( GIDSignIn.sharedInstance()!.currentUser!.profile.name!).getDocument { (data, error) in
            if let data = data {
                self.myNickName = data["nickName"] as? String ?? "N/A"
            }
        }
        
        self.textField.delegate = self
        queryFirestore()
        self.tableview.transform = CGAffineTransform(rotationAngle: .pi)
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
    
    
    @IBAction func sendMessage(_ sender: Any) {
//
//        getUserData.share.getUserNickName { (string) in
//            print(string)
//        }
        //*************以下送訊息以上參考
        let myGoogleName = GIDSignIn.sharedInstance()!.currentUser!.profile.name!
        //        let otherNickName = self.receiveMessageNickname!
      
        let sendParameter = ["send":"\(myNickName ?? "N/A"):\(self.textField.text ?? "N/A")"]
        let receiveParameter = ["receive":"\(myNickName ?? "N/A"):\(self.textField.text ?? "N/A")"]
        
        self.db.collection("user").document(myGoogleName).collection("Messages").document(self.otherNickName).setData(["otherGoogleName":self.otherGoogleName ?? "N/A"
        ]) { (error) in
            self.db.collection("user").document(myGoogleName).collection("Messages").document(self.otherNickName).collection("Message").document(currentTime.share.time()).setData(sendParameter)
        }
        
        self.db.collection("user").document(self.otherGoogleName).collection("Messages").document( self.myNickName).setData(["otherGoogleName":myGoogleName]) { (error) in
            self.db.collection("user").document(self.otherGoogleName).collection("Messages").document( self.myNickName).collection("Message").document(currentTime.share.time()).setData(receiveParameter)
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
//
//          func textFieldDidBeginEditing(_ textField: UITextField) {
//
//              NotificationCenter.default.addObserver(self, selector: #selector(textFiledChangeRect(notificaton:)), name: UIResponder.keyboardDidShowNotification, object: nil)
//
//
//          }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.tableview.topAnchor.constraint(equalTo: self.textField.topAnchor, constant: 0).isActive = true
//        NotificationCenter.default.addObserver(self, selector: #selector(textFiledChangeRect(notificaton:)), name: UIResponder.keyboardDidShowNotification, object: nil)
//    }
//
//    @objc func textFiledChangeRect ( notificaton : Notification ){
//        if let userInfo = notificaton.userInfo,
//        let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//        print(keyboardRectangle.height)
//               print(self.view.frame.size.height)
////        let a = CGRect(x: 0.0, y: -keyboardRectangle.height ,
////                       width: self.view.frame.size.width,
////                       height:self.view.frame.size.height)
//            self.textField.bottomAnchor.constraint(equalTo: self.tableview.topAnchor, constant: 0).isActive = true
//
//            let a = CGRect(x: keyboardRectangle.height, y: keyboardRectangle.height,
//                                 width: self.view.frame.size.width,
//                                 height:self.view.frame.size.height)
//
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
//            self.textField.topAnchor.constraint(equalTo: self.tableview.bottomAnchor, constant: 350).isActive = true
//
//        }) { (true) in}
//
//        }
//    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
               textField.resignFirstResponder()
               return true
           }

    
}
