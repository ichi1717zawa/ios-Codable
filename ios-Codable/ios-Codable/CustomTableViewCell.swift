//
//  CustomTableViewCell.swift
//  ios-Codable
//
//  Created by ichi1717zawa on 2020/9/28.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib() 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

         
    }
    
    func setData(model:[openData],index:IndexPath){
        let data = model[index.row]
        self.label1.text = data.TestTarget
        self.label2.text = data.住址
        self.label3.text = data.補助受理單位名稱
        self.label4.text = data.電話01
        self.label5.text = data.F5
    }

}


