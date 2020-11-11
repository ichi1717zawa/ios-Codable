//
//  categoryViewVC.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/6/30.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit

class categoryViewVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var mytableview: UITableView!
    
    let imageData : [UIImage] = [
        UIImage(named: "a4")!,
        UIImage(named: "a5")!,
        UIImage(named: "a6")!,
        UIImage(named: "a4")!,
        UIImage(named: "a5")!,
        UIImage(named: "a6")!,
        UIImage(named: "a4")!,
        UIImage(named: "a5")!,
        UIImage(named: "a6")!,
        UIImage(named: "a4")!,
        UIImage(named: "a5")!,
        UIImage(named: "a6")!]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.mytableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! categorytableviewcell
        let data = self.imageData[indexPath.row]
        cell.categoryImage.image = data
        cell.transform = CGAffineTransform(rotationAngle: -.pi / 2 )
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mytableview.transform = CGAffineTransform(rotationAngle: .pi / 2)
        
    }
    
}
