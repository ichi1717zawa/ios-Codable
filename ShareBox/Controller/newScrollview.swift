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
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = myscrollview.contentOffset.x / scrollView.frame.size.width
        mypageCL.currentPage = Int(pageNumber)
        print(mypageCL.currentPage)
        if mypageCL.currentPage == 1{
            
        }
    }
}
