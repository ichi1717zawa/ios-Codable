//
//  categorytableviewcell.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/30.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit

class categorytableviewcell: UITableViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
