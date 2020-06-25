//
//  chatTableCell.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/25.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit

class chatTableCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var messageTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
