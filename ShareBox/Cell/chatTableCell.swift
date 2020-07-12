//
//  chatTableCell.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/25.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit

class chatTableCell: UITableViewCell {

    @IBOutlet weak var receiveTextview: UITextView!
    @IBOutlet weak var sendTextview: UITextView!
    @IBOutlet var sendMessageview: UIView!
    @IBOutlet var receiveMessageview: UIView!
    @IBOutlet var sendMessageLabel: UILabel!
    @IBOutlet var myRightAnchor: NSLayoutConstraint!
    @IBOutlet var myLeftAnchor: NSLayoutConstraint!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var backGroundImage: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
//         receiveTextview.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
//        messageTitle.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
//               textView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     

}
