//
//  allPostVC + category.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/8/9.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import Foundation
import UIKit
extension allPostVC {
    
    
    // ["物品種類","書籍文具票券","3c產品","玩具電玩","生活居家與家電","影視音娛樂","飲品食品","保養彩妝","男裝配件","女裝婦幼"]
    
    //"ALL"
    //"書籍文具票券"
    //"3c產品"
    //"玩具電玩"
    //"生活居家與家電"
    //"影視音娛樂"
    //"飲品食品"
    //"保養彩妝"
    //"男裝配件"
    //"女裝婦幼"
    @IBAction func btn1(_ sender: Any) {
        selectCategoryLabel.text = "ALL"
        pressCategoryButton(button:btn1, categoryName: "ALL黑")
        
    }
    @IBAction func btn2(_ sender: Any) {
        //        initButton()
        selectCategoryLabel.text = "書籍文具票券"
        pressCategoryButton(button:btn2, categoryName: "書籍文具票券黑")
    }
    @IBAction func btn3(_ sender: Any) {
        //        initButton()
        selectCategoryLabel.text = "3c產品"
        pressCategoryButton(button: btn3, categoryName: "3C黑")
    }
    @IBAction func btn4(_ sender: Any) {
        //        initButton()
        selectCategoryLabel.text = "玩具電玩"
        pressCategoryButton(button: btn4, categoryName: "玩具電玩黑")
    }
    @IBAction func btn5(_ sender: Any) {
        //        initButton()
        selectCategoryLabel.text = "生活居家與家電"
        pressCategoryButton(button: btn5, categoryName: "生活居家與家電黑")
    }
    @IBAction func btn6(_ sender: Any) {
        //        initButton()
        selectCategoryLabel.text = "影視音娛樂"
        pressCategoryButton(button: btn6, categoryName: "影視音娛樂黑")
    }
    @IBAction func btn7(_ sender: Any) {
        //        initButton()
        selectCategoryLabel.text =  "飲品食品"
        pressCategoryButton(button: btn7, categoryName: "飲品食品黑")
    }
    @IBAction func btn8(_ sender: Any) {
        //        initButton()
        selectCategoryLabel.text = "保養彩妝"
        pressCategoryButton(button: btn8, categoryName: "保養彩妝黑")
    }
    @IBAction func btn9(_ sender: Any) {
        //        initButton()
        selectCategoryLabel.text = "男裝配件"
        pressCategoryButton(button: btn9, categoryName: "男裝配件黑")
    }
    @IBAction func btn10(_ sender: Any) {
        //        initButton()
        selectCategoryLabel.text = "女裝婦幼"
        pressCategoryButton(button: btn10, categoryName: "女裝婦幼黑")
    }
    
    func initButton(){
        
        btn1.setImage(UIImage(named: "ALL彩"), for: .normal)
        btn2.setImage(UIImage(named: "書籍文具票券彩"), for: .normal)
        btn3.setImage(UIImage(named: "3c產品彩"), for: .normal)
        btn4.setImage(UIImage(named: "玩具電玩彩"), for: .normal)
        btn5.setImage(UIImage(named: "生活居家與家電彩"), for: .normal)
        btn6.setImage(UIImage(named: "影視音娛樂彩"), for: .normal)
        btn7.setImage(UIImage(named: "飲品食品彩"), for: .normal)
        btn8.setImage(UIImage(named: "保養彩妝彩"), for: .normal)
        btn9.setImage(UIImage(named: "男裝配件彩"), for: .normal)
        btn10.setImage(UIImage(named: "女裝婦幼彩"), for: .normal)
        
    }
}
