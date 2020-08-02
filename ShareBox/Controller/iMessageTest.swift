//
//  iMessageTest.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/7/26.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import MessageUI
class iMessageTest: UIViewController,MFMessageComposeViewControllerDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        let messageVC = MFMessageComposeViewController()
            
        messageVC.body = "Enter a message";
        messageVC.recipients = ["0910903423"]
        messageVC.messageComposeDelegate = self
        
            
        self.present(messageVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
          switch (result) {
              case .cancelled:
                  print("Message was cancelled")
                  dismiss(animated: true, completion: nil)
              case .failed:
                  print("Message failed")
                  dismiss(animated: true, completion: nil)
              case .sent:
                  print("Message was sent")
                  dismiss(animated: true, completion: nil)
              default:
              break
          }
    }
    
 
}
