//
//  ViewController.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/15.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import CoreLocation
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {
 
    
    
    @IBOutlet weak var texblabel: UILabel!
    @IBOutlet weak var mapKitView: MKMapView!
    let locationManager = CLLocationManager()
    var user : Any?  
    override func viewDidLoad() {
        super.viewDidLoad()

        
}
     

}
