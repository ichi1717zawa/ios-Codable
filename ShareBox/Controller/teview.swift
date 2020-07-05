//
//  teview.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/7/5.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import Firebase
class teview: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var testbutton: UIButton!
    @IBOutlet weak var scroview: UIScrollView!
    @IBOutlet weak var pagecl: UIPageControl!
    var images : [String] = ["001","002"]
   
    var fram = CGRect (x: 0, y: 0, width: 0, height: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        scroview.frame.size.height = self.view.frame.height
        scroview.frame.origin.y = self.view.frame.origin.y
        scroview.frame.origin.x = self.view.frame.origin.x
       
//        scroview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: 100).isActive = true
//         scroview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: 0).isActive = true
//         scroview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 0).isActive = true
        pagecl.numberOfPages = images.count
        for index in 0 ..< images.count{
            fram.origin.x = scroview.frame.size.width * CGFloat(index)
            fram.size = scroview.frame.size
            let imageview = UIImageView(frame: fram)
            imageview.image = UIImage(named: images[index])
            self.scroview.addSubview(imageview)
        }
      
        scroview.contentSize = CGSize(width: (scroview.frame.size.width * CGFloat(images.count)), height: scroview.frame.size.height )
//        scroview.frame.size.height = self.view.frame.height
       
        pagecl.frame = CGRect(x: 0, y:self.view.frame.maxY - 100, width: self.view.frame.width, height: 30)
        
        scroview.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pagecl.currentPage = Int(pageNumber)
        print(pagecl.currentPage)
        if pagecl.currentPage == 1{
            testbutton.alpha = 1
        }else{
             testbutton.alpha = 0
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func buttonaction(_ sender: Any) {
        UIView.animate(withDuration: 1) {
            self.scroview.alpha = 0
                  self.testbutton.alpha = 0
        }
    }
}
