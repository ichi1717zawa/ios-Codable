//
//  ChatListCustomCell.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/9.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit

class ChatListCustomCell: UITableViewCell {

    @IBOutlet weak var OtherName: UILabel! 
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userSubtitle: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    @IBOutlet weak var MessageHint: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        

}

}
