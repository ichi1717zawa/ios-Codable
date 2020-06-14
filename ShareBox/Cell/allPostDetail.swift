//
//  allPostDetail.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/7.
//  Copyright © 2020 廖逸澤. All rights reserved.
 
import UIKit

class allPostDetail: UITableViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var buildTime: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var favoriteCount: UILabel!
    
    
    

 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
