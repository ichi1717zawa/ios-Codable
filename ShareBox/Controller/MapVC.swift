//
//  MapVC.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/29.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import CoreLocation
import MapKit
import CloudKit

class MapVC: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    var data: [AnnotationDetail] = []
    let database = CKContainer.default().publicCloudDatabase
    let defaultPhoto =  UIImage(named: "photo.fill")
    let db = Firestore.firestore()
    var didImage :UIImage?
    @IBOutlet weak var mapKitView: MKMapView!
    let locationManager = CLLocationManager()
    var annotation : MKAnnotation?
    var postUUID : String?
    var mainCategory: String?
    var Adress:String!
    var posterUID:String!
    var categoryImageName:String!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: -> viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        CoredataSharePost.share.loadData()
        
        if mainCategory == "ALL" {
            categoryImageName = "ALL彩"
            fetchsomeData(fetchALL: true)
        }else{
            fetchsomeData(fetchALL: false)
        }
        transAdressAndMoveThere(Adress: Adress)
        //        mapKitView.delegate = self
        mapKitView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "\(AnnotationDetail.self)")
        //        addAnnotation()
    }
    func transAdressAndMoveThere(Adress:String){
        let geoLocation = CLGeocoder()
        geoLocation.geocodeAddressString(Adress
        ) { (placemarks, error) in
            if let error = error{
                print("輸入地址無法辨識\(error.localizedDescription)")
            }
            
            guard let placemark = placemarks?.first, let cordinate = placemark.location?.coordinate else {return}
            let gotoAdress  = cordinate
            self.moveRegion(coodinate: gotoAdress)
        }
    }
    
    //MARK: -> viewFor
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //
        guard let annotation = annotation as? AnnotationDetail else {
            return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "\(AnnotationDetail.self)", for: annotation)
        annotationView.canShowCallout = true
        let infoButton = UIButton(type: .detailDisclosure)
        
        infoButton.addTarget(self, action: #selector(buttonPressd(sender:)), for: .touchUpInside)
        annotationView.rightCalloutAccessoryView = infoButton
        //        if annotation.title == "玩具"{
        annotationView.image = (UIImage(named: "\(annotation.mainCategory ?? "")彩"))
        //        }
        return annotationView
        
    }
    
    //MARK: -> buttonPressd
    @objc func buttonPressd(sender:Any){
        performSegue(withIdentifier: "postDetail", sender: nil)
        
    }
    //MARK: -> prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "postDetail"{
            let detailVC = segue.destination as! allPostDetailBycell
            detailVC.postUUID = self.postUUID
            detailVC.posterUID = self.posterUID
            detailVC.annotation = self.annotation
            
            let data = fetchData.shared.fetchSingleData(uuid: self.postUUID!)
            detailVC.data = data
            
        }
        //        if segue.identifier == "postDetail"{
        //            let detailVC = segue.destination as! PostDetailVC
        //            detailVC.image = self.didImage
        //            detailVC.annotation = self.annotation
        //        }
    }
    
    //MARK: -> didSelect
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        //        mapView.removeAnnotation(view.annotation as! MKAnnotation)
        let annotation = view.annotation as! AnnotationDetail
        self.postUUID = annotation.postUUID
        self.posterUID = annotation.posterUID
        self.annotation = annotation
        
        
        //        let filter: String! = annotation.postUUID
        //              print(filter!)
        //              let predicate: NSPredicate = NSPredicate(format: "content = %@", filter)
        //              let query = CKQuery(recordType: "Note", predicate: predicate)
        //        DispatchQueue.global().async {
        //
        //
        //            self.database.perform(query, inZoneWith: nil) { (records, _) in
        //                  guard var records = records else {return}
        //                  for record in records{
        //
        //                      let asset = record["myphoto"] as! CKAsset
        //                      let imageData = NSData(contentsOf: asset.fileURL!)
        //                        self.didImage = UIImage(data: imageData as! Data)
        //
        ////                    self.didImage = UIImage(data: imageData! as Data) ?? self.defaultPhoto
        ////                    self.didImage = self.defaultPhoto
        //                  }
        //              }
        //            }
    }
    
    //MARK: -> moveRegion
    func moveRegion(coodinate: CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coodinate, span: span)
        
        mapKitView.setRegion(region, animated: true)
        
    }
    
    //MARK: -> addAnnotation
    func fetchsomeData(fetchALL category:Bool){
        var data : [allPostModel] = []
        if category == true {
            data = fetchData.shared.data
        }else{
            data = fetchData.shared.data.filter{$0.mainCategory == mainCategory}
        }
        for i in data{
            let geoLocation = CLGeocoder()
            geoLocation.geocodeAddressString(i.userLocation) { (placemarks, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                guard let placemark = placemarks?.first, let cordinate = placemark.location?.coordinate else {return}
                var annotationCoordinate  = cordinate
                annotationCoordinate.latitude += 0.0001
                annotationCoordinate.longitude += 0.0001
                
                let annotation = AnnotationDetail(title: i.productName,
                                                  coordinate: annotationCoordinate,
                                                  postUUID: i.postUUID,
                                                  mainCategory: i.mainCategory,
                                                  posterUID: i.posterUID
                )
                self.mapKitView.delegate = self
                self.mapKitView.addAnnotation(annotation)
                self.data.append(annotation)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func addAnnotation( ){
//            for i in CoredataSharePost.share.data{
//
//                let userLocation = i.userLocation
//                let geoLocation = CLGeocoder()
//                geoLocation.geocodeAddressString(userLocation
//                ) { (placemarks, error) in
//                    if let error = error{
//                        print("錯誤\(error)")
//                        return
//                    }
//
//                    guard let placemark = placemarks?.first, let cordinate = placemark.location?.coordinate else {return}
//                    var annotationCoordinate  = cordinate
//                    annotationCoordinate.latitude += 0.0001
//                    annotationCoordinate.longitude += 0.0001
//                    let annotation = AnnotationDetail(title: i.postCategory,
//                                                      Subtitle: i.postIntroduction,
//                                                      coordinate: annotationCoordinate,
//                                                      postIntroduction: i.postIntroduction,
//                                                      nickName: i.nickname,
//                                                      postCategory: i.postCategory,
//                                                      userLocation: i.userLocation,
//                                                      googleName: i.googleName, postUUID: i.postUUID,
//                                                      postTime: i.postTime,
//                                                      viewsCount: i.viewsCount  )
//                    self.mapKitView.addAnnotation(annotation)
//    //                self.moveRegion(coodinate: cordinate)
//                }
//            }
    
        } //備註暫時用不到
    func fetchAllData(){
        let data = fetchData.shared.data
        
        for i in data{
            let geoLocation = CLGeocoder()
            geoLocation.geocodeAddressString(i.userLocation) { (placemarks, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                guard let placemark = placemarks?.first, let cordinate = placemark.location?.coordinate else {return}
                var annotationCoordinate  = cordinate
                annotationCoordinate.latitude += 0.0001
                annotationCoordinate.longitude += 0.0001
                
                let annotation = AnnotationDetail(title: i.productName,
                                                  coordinate: annotationCoordinate,
                                                  postUUID: i.postUUID,
                                                  mainCategory: i.mainCategory,
                                                  posterUID: i.posterUID
                )
                self.mapKitView.delegate = self
                self.mapKitView.addAnnotation(annotation)
                self.data.append(annotation)
            }
        }
    } //備註暫時用不到
    func fetchSpecificCategory(){
        let specificData = fetchData.shared.data.filter{$0.mainCategory == mainCategory}
        for i in specificData{
            let geoLocation = CLGeocoder()
            geoLocation.geocodeAddressString(i.userLocation) { (placemarks, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                guard let placemark = placemarks?.first, let cordinate = placemark.location?.coordinate else {return}
                var annotationCoordinate  = cordinate
                annotationCoordinate.latitude += 0.0001
                annotationCoordinate.longitude += 0.0001
                
                let annotation = AnnotationDetail(title: i.productName,
                                                  coordinate: annotationCoordinate,
                                                  postUUID: i.postUUID,
                                                  mainCategory: i.mainCategory,
                                                  posterUID: i.posterUID
                )
                self.mapKitView.delegate = self
                self.mapKitView.addAnnotation(annotation)
                self.data.append(annotation)
            }
        }
    } //備註暫時用不到
    func querySpecificCategory(){
        db.collection("userPost").whereField("mainCategory",isEqualTo: mainCategory!).addSnapshotListener { (query, error) in
            if let error = error{
                print("query Faild\(error)")
            }
            
            
            
            
            guard let documentChange = query?.documentChanges else {return}
            for change in documentChange{
                let documentID = change.document.documentID
                //處理每一筆更新
                if change.type == .added{
                    
                    let userLocation =  change.document.data()["userLocation"] as? String ?? ""
                    let geoLocation = CLGeocoder()
                    geoLocation.geocodeAddressString(userLocation
                    ) { (placemarks, error) in
                        if let error = error{
                            print(error)
                        }
                        
                        guard let placemark = placemarks?.first, let cordinate = placemark.location?.coordinate else {return}
                        
                        var annotationCoordinate  = cordinate
                        annotationCoordinate.latitude += 0.0001
                        annotationCoordinate.longitude += 0.0001
                        //                        let annotation = AnnotationDetail(title: change.document.data()["productName"] as? String ?? "N/A",
                        //                                                          Subtitle: change.document.data()["postIntroduction"] as? String ?? "N/A",
                        //                                                          coordinate: annotationCoordinate,
                        //                                                          postIntroduction: change.document.data()["postIntroduction"] as? String ?? "N/A",
                        //                                                          nickName: change.document.data()["Name"] as? String ?? "N/A",
                        //                                                          postCategory: change.document.data()["postCategory"] as? String ?? "N/A",
                        //                                                          userLocation:change.document.data()["userLocation"] as? String ?? "N/A",
                        //                                                          googleName: change.document.data()["googleName"] as? String ?? "N/A",
                        //                                                          postUUID: change.document.data()["postUUID"] as? String ?? "N/A",
                        //                                                          postTime: change.document.data()["postTime"] as? String ?? "N/A",
                        //                                                          viewsCount: change.document.data()["viewsCount"] as? Int ?? 0)
                        let annotation = AnnotationDetail(title: change.document.data()["productName"] as? String ?? "N/A",
                                                          coordinate: annotationCoordinate,
                                                          postUUID: change.document.data()["postUUID"] as? String ?? "N/A",
                                                          mainCategory: change.document.data()["mainCategory"] as? String ?? "N/A",
                                                          posterUID: change.document.data()["posterUID"] as? String ?? "N/A"
                        )
                        self.mapKitView.delegate = self
                        self.mapKitView.addAnnotation(annotation)
                        self.data.append(annotation)
                        
                        //                                   self.moveRegion(coodinate: cordinate)
                    }
                }
                else if change.type == .removed{ //刪除
                    if let perAnnotation = self.data.filter({ (perAnnotation) -> Bool in
                        perAnnotation.postUUID == documentID
                    }).first{
                        //                                perAnnotation.viewsCount = change.document.data()["viewsCount"] as! Int
                        //                            note.imageName = change.document.data()["imageName"] as? String
                        if let index = self.data.firstIndex(of: perAnnotation){
                            let indexPath = IndexPath(row: index, section: 0)
                            self.mapKitView.removeAnnotation(self.data[indexPath.row])
                            //                                self.mapKitView.reloadInputViews()
                            //                           self.tableview.reloadRows(at: [indexPath], with: .fade)
                            
                        } } } } }
        
        
    } //備註暫時用不到
    func queryALLFirestore(){
       /* db.collection("userPost").addSnapshotListener { (query, error) in
            if let error = error{
                print("Map query Faild\(error)")
                return
            }
            
            guard let documentChange = query?.documentChanges else {return}
            for change in documentChange{
                let documentID = change.document.documentID
                //處理每一筆更新
                
                if change.type == .added{
                    
                    let userLocation =  change.document.data()["userLocation"] as? String ?? " "
                    let geoLocation = CLGeocoder()
                    geoLocation.geocodeAddressString(userLocation
                    ) { (placemarks, error) in
                        if let error = error{
                            print(error.localizedDescription)
                            return
                        }
                        
                        guard let placemark = placemarks?.first, let cordinate = placemark.location?.coordinate else {return}
                        print(cordinate.latitude)
                        var annotationCoordinate  = cordinate
                        annotationCoordinate.latitude += 0.0001
                        print(annotationCoordinate.latitude)
                        annotationCoordinate.longitude += 0.0001
                        //                        let annotation = AnnotationDetail(title: change.document.data()["productName"] as? String ?? "N/A",
                        //                                                          Subtitle: change.document.data()["postIntroduction"] as? String ?? "N/A",
                        //                                                          coordinate: annotationCoordinate,
                        //                                                          postIntroduction: change.document.data()["postIntroduction"] as? String ?? "N/A",
                        //                                                          nickName: change.document.data()["Name"] as? String ?? "N/A",
                        //                                                          postCategory: change.document.data()["postCategory"] as? String ?? "N/A",
                        //                                                          userLocation:change.document.data()["userLocation"] as? String ?? "N/A",
                        //                                                          googleName: change.document.data()["googleName"] as? String ?? "N/A",
                        //                                                          postUUID: change.document.data()["postUUID"] as? String ?? "N/A",
                        //                                                          postTime: change.document.data()["postTime"] as? String ?? "N/A",
                        //                                                          viewsCount: change.document.data()["viewsCount"] as? Int ?? 0)
                        let annotation = AnnotationDetail(title: change.document.data()["productName"] as? String ?? "N/A",
                                                          coordinate: annotationCoordinate,
                                                          postUUID: change.document.data()["postUUID"] as? String ?? "N/A",
                                                          mainCategory: change.document.data()["mainCategory"] as? String ?? "N/A", posterUID: change.document.data()["posterUID"] as? String ?? "N/A"
                        )
                        self.mapKitView.delegate = self
                        self.mapKitView.addAnnotation(annotation)
                        self.data.append(annotation)
                        
                        //  self.moveRegion(coodinate: cordinate)
                    }
                }
                else if change.type == .removed{ //刪除
                    if let perAnnotation = self.data.filter({ (perAnnotation) -> Bool in
                        perAnnotation.postUUID == documentID
                    }).first{
                        //                                perAnnotation.viewsCount = change.document.data()["viewsCount"] as! Int
                        //                            note.imageName = change.document.data()["imageName"] as? String
                        if let index = self.data.firstIndex(of: perAnnotation){
                            let indexPath = IndexPath(row: index, section: 0)
                            self.mapKitView.removeAnnotation(self.data[indexPath.row])
                            //                                self.mapKitView.reloadInputViews()
                            //                           self.tableview.reloadRows(at: [indexPath], with: .fade)
                            
                        }} } } }
        */
        
    } //備註暫時用不到
    
    
    @IBAction func BackToRootView(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: -> 尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴尾巴
}
