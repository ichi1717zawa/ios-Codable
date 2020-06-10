////
////  Map.swift
////  ShareBox
////
////  Created by 廖逸澤 on 2020/5/23.
////  Copyright © 2020 廖逸澤. All rights reserved.
////
//
//import UIKit
//import Firebase
//import GoogleSignIn
//import CoreLocation
//import MapKit
//
//extension MapVC  {
//
//
//
//
//    //MARK: -> FirstStep
//    func creatLocationManerger(){
//
//         //class mathod
//             guard CLLocationManager.locationServicesEnabled() else{ return }//show some hint to user
//
//             //Ask permission
//             //Instacne method.
//             locationManager.requestAlwaysAuthorization() //要求權限
//             locationManager.desiredAccuracy = kCLLocationAccuracyBest
//             locationManager.activityType = .automotiveNavigation
//             locationManager.delegate = self
//             locationManager.startUpdatingLocation()
//             locationManager.allowsBackgroundLocationUpdates = true
//    let  souceCoordinate = CLLocationCoordinate2D(latitude: 25.005754, longitude: 121.526193)
//    let  souceCoordinate2 = CLLocationCoordinate2D(latitude: 25.014257, longitude: 121.526193)
//    let  souceCoordinate3 = CLLocationCoordinate2D(latitude: 25.064257, longitude: 121.526193)
//    let  annotationArray = [souceCoordinate,souceCoordinate2,souceCoordinate3]
////        for i in annotationArray{
////            let annotation = MKPointAnnotation()
////            annotation.coordinate = i
////             addAnnotation(i, annotation: annotation)
////
////        }
//       addAnnotation( )
//        moveRegion(coodinate: souceCoordinate)
//
//    }
//
//
//
//
//    func addAnnotation( ){
//
//        for i in CoredataSharePost.share.data{
//
//            let userLocation = i.userLocation
//            let annotation = MKPointAnnotation()
//            annotation.coordinate.latitude = Double(i.latitude)!
//            annotation.coordinate.longitude = Double(i.longitude)!
//              annotation.title = i.postCategory
//              annotation.subtitle = i.postIntroduction
//            self.mapKitView.addAnnotation(annotation)
////            let geoLocation = CLGeocoder()
//          print(  CoredataSharePost.share.data[0].postCategory)
////                 geoLocation.geocodeAddressString(userLocation
////                 ) { (placemarks, error) in
////                     if let error = error{
////                         print(error)
////                     }
////
////                    guard let placemark = placemarks?.first, let cordinate = placemark.location?.coordinate else {return}
////
////                    var annotationCoordinate  = cordinate
////                         annotationCoordinate.latitude += 0.0001
////                         annotationCoordinate.longitude += 0.0001
////                        let annotation = MKPointAnnotation()
////                        annotation.coordinate = annotationCoordinate
////                        annotation.title = i.postCategory
////
////                        annotation.subtitle = i.postIntroduction
////                    self.testArray.append(annotation)
////                      print(self.testArray[0].title)
////                    print(self.testArray.count)
////
////
//////                      self.mapKitView.addAnnotation(annotation)
////                    self.mapKitView.addAnnotations(self.testArray)
////                    self.moveRegion(coodinate: cordinate)
////                 }
//
//
//
//        }
//
//    }
//
//      //MARK: ->增加地點跟註解
////    func addAnnotation(_ coordinate: CLLocationCoordinate2D,annotation:MKPointAnnotation){
////
//////                let sharePostData = CoredataSharePost.share.data
//////
////                    var annotationCoordinate = coordinate
////                    annotationCoordinate.latitude += 0.0001
////                    annotationCoordinate.longitude += 0.0001
////                    let annotation = MKPointAnnotation()
////
//////
//////                    annotation.coordinate = annotationCoordinate
////
////
////
////                    annotation.title = "肯德基"
////                    annotation.subtitle = "真好吃真好吃 "
////                    mapKitView.addAnnotation(annotation)
////
////
////
////                   }
//
//    //sender 在這裡的指的是segment ,可以使用Any或直接指定型別
//       @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
//           let index = sender.selectedSegmentIndex
//           switch index
//           {
//           case 0 :
//               mapKitView.mapType = .standard
//           case 1 :
//               mapKitView.mapType = .satellite
//           case 2 :
//               mapKitView.mapType = .hybrid
//           case 3 :
//               mapKitView.mapType = .satelliteFlyover
//               //Tokyo SkyTree
//               let coordinate = CLLocationCoordinate2DMake(35.710063, 139.8107)
//               let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 700, pitch: 65, heading: 0)
//               mapKitView.camera = camera
//           default:
//               mapKitView.mapType = .standard
//           }
//
//
//       }
//
//
//
//
//    //MARK: ->位置更新
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//       //位置的更新需要移動才會回傳
//           guard let coodinate = locations.last?.coordinate else {
//               return
//           }
//           print("coodinate:\(coodinate.latitude),\(coodinate.longitude)") //經緯度
//        print(locations)
//           //只做一次
//           DispatchQueue.once(token: "addAnnotation") {
//               addAnnotation(coodinate)
//           }
//           DispatchQueue.once(token: "moveRegion") {
//               moveRegion(coodinate: coodinate)
//           }
////        FIRFirestoreService.shared.mapcreate(locations: locations) //呼叫儲存至Database
//
//
//       }
////
//          //MARK: ->將畫面縮到自己的位置
//       func moveRegion(coodinate: CLLocationCoordinate2D){
//           let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//           let region = MKCoordinateRegion(center: coodinate, span: span)
//           mapKitView.setRegion(region, animated: true)
//
//       }
//
//
//
//
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//               if annotation is MKUserLocation{
//                   return nil} //可更改使用者圖標
//               let reuseId = "\(AnnotationDetail.self)"
//           var result = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId, for: annotation) as? AnnotationDetail
//
//
////               if result == nil{
////                   //creat it
////   //                result = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
////                   result = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
////
////               }
//
//               result?.canShowCallout = true
//   //            result?.animatesDrop = true
////               result?.pinTintColor = .green
//               let image = UIImage(named: "pointRed")
//               result?.image = image
//
//               //Add left callout accessoryview
//               let imageview = UIImageView(image: image)
//
//           let testview = UIImageView(image: UIImage(named: "testp"))
//           testview.frame.size.height = 300
//           testview.frame.size.width = 300
//   //        test.addSubview(testview)
//               result?.leftCalloutAccessoryView = imageview
//               //add right calllout acceesoryview
//   //        let button = UIButton(type: .detailDisclosure)
//   //            button.addTarget(self, action: #selector(buttonPressd(sender:)), for: .touchUpInside)
//   //            result?.rightCalloutAccessoryView = button
//           result?.rightCalloutAccessoryView = Detailbutton
//               return result
//           }
//
//
////      func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
////
////            if annotation is MKUserLocation{
////                return nil} //可更改使用者圖標
////            let reuseId = "stroe"
////            var result = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) //as? MKPinAnnotationView轉型的話可以自定義
//////        var result = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId, for: annotation) as? MKPinAnnotationView
////
////
////            if result == nil{
////                //creat it
//////                result = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
////                result = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
////
////            }
////
////            result?.canShowCallout = true
//////            result?.animatesDrop = true
//////            result?.pinTintColor = .green
////            let image = UIImage(named: "pointRed")
////            result?.image = image
////
////            //Add left callout accessoryview
////            let imageview = UIImageView(image: image)
////
////        let testview = UIImageView(image: UIImage(named: "testp"))
////        testview.frame.size.height = 300
////        testview.frame.size.width = 300
//////        test.addSubview(testview)
////            result?.leftCalloutAccessoryView = imageview
////            //add right calllout acceesoryview
//////        let button = UIButton(type: .detailDisclosure)
//////            button.addTarget(self, action: #selector(buttonPressd(sender:)), for: .touchUpInside)
//////            result?.rightCalloutAccessoryView = button
////        result?.rightCalloutAccessoryView = Detailbutton
////            return result
////        }
//
//
//
//    @objc func buttonPressd(sender:Any){
//          let test = UIViewController()
//
//        self.performSegue(withIdentifier: "postDetail", sender: nil)
//       let postdetail = PostDetailVC()
//       postdetail.indexDetil = indexDetail
//
//        print("self.mapKitView.annotations.endIndex\(self.mapKitView.annotations.first)")
//        print("buttonPressed!")
//        print(index,sender)
////          naviagateTo(adress: "台北市館前路45號")
//      }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "postDetail"{
//            let postDetailVC = segue.destination as! PostDetailVC
//
//            postDetailVC.indexDetil = indexDetail
//
//        }
//    }
//
//
//    func naviagateTo(adress:String){
//
//            // 異部執行
//            // Address -> Lat ,Lon
//
//             let gecord1 = CLGeocoder()   //可以轉地址經緯度
//
//            gecord1.geocodeAddressString(adress) { (placemarks, error) in
//                if let error = error {
//                    print("geocodeAddressSting:\(error)")
//                    return
//                }
//                guard let placemark = placemarks?.first,
//                    let coordinate = placemark.location?.coordinate else{
//                        assertionFailure("Invalid placemark")
//                        return
//                }
//                print("Lat, Lon \(coordinate.latitude ), \(coordinate.longitude )")
//
//
//                //prepare source map item
//                let souceCoordinate = CLLocationCoordinate2D(latitude: 24.686525, longitude: 121.815312)
//                let sourcePlacemark = MKPlacemark(coordinate: souceCoordinate )
//                let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//
//                //Prerare taget map item
//                let targetPlacemark = MKPlacemark(placemark: placemark)
//                let targetMapItem = MKMapItem(placemark: targetPlacemark)
//                let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
//    //            targetMapItem.openInMaps(launchOptions: options)
//                MKMapItem.openMaps(with: [sourceMapItem,targetMapItem], launchOptions: options)
//            }
//
//
//
//
//
//            let geocoder2 = CLGeocoder()
//            let homeLocation = CLLocation(latitude: 25.045164, longitude: 121.515154)
//            geocoder2.reverseGeocodeLocation(homeLocation) { (placemarks, error) in
//                if let error = error {
//                    print("geocodeAddressSting:\(error)")
//                    return
//                }
//                guard let placemark = placemarks?.first,
//                    let coordinate = placemark.location?.coordinate else{
//                        assertionFailure("Invalid placemark")
//                        return
//                }
//                let description = placemark.description
//                let postalCode = placemark.postalCode ?? "n/a" //設預設值避開optional
//                let contryCode = placemark.isoCountryCode ?? "n/a" //設預設值避開optional
//                print("\(description),\(postalCode),\(contryCode)")
//            }
//        }
//
//
//
//
//
//
//
//}
