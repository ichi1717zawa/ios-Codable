//
//  ShowPostImage.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/22.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit

class lookImage: UIViewController {
    
    
    
    @IBOutlet weak var qwe: UIImageView!
    var myimage:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        qwe.image = myimage
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
