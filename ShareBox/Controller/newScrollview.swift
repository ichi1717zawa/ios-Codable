//
//  newScrollview.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/7/7.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit

class newScrollview: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mypageCL: UIPageControl!
    @IBOutlet weak var myscrollview: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mypageCL.numberOfPages = 3
        myscrollview.delegate = self
        mypageCL.currentPageIndicatorTintColor = .orange
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = myscrollview.contentOffset.x / scrollView.frame.size.width
          mypageCL.currentPage = Int(pageNumber)
        print(mypageCL.currentPage)
          if mypageCL.currentPage == 1{
               
          }
      }
}
