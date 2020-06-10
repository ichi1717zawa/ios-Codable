//
//  PostVC.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/27.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit
import Firebase
import GoogleSignIn
import CloudKit
class PostVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate   {
    @IBOutlet weak var imageview: UIImageView!
    var myNickName : String!
    var notes = [CKRecord]()
        let testdata = [CKAsset]()
           let newNote = CKRecord(recordType: "Note")
     let database = CKContainer.default().publicCloudDatabase
    
    let sharepost = CoredataSharePost.share
    let shareInfo = CoredataShare.share
   
    let Category = ["書籍文具","保養彩妝","玩具公仔","電玩遊戲","生活居家","音樂電影","手機相關","電腦相關","飲品食品","男裝配件","女裝配件","婦幼專區","明星偶像","其他"]
//    let Category = ["書籍文具":"qwe"]
    let liveCategoryDetail = ["廚房用品","小型家電","生活雜貨","寢具用品","家具","日用品"]
    let foodCategoryDetail = ["生鮮","蔬果","飲品","名產小吃","甜點","零食"," 乾貨"]
    var tempCategoryDetail = [String]()
    
    var tempNumber : Int!
    var db :Firestore!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       switch pickerView {
        case PostCategory:
            return Category.count
        default:
            return tempCategoryDetail.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
              case PostCategory:
                  return Category[row]
              default:
                  return tempCategoryDetail[row]
              }
        }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case PostCategory:
            didselect = Category[row]
            if didselect == "生活居家" {
                tempCategoryDetail = liveCategoryDetail
                subPostCategory.alpha = 1
                subPostCategory.delegate = self
                subPostCategory.dataSource = self
                print(tempCategoryDetail)
                
            } else if didselect == "飲品食品" {tempCategoryDetail =  foodCategoryDetail ;subPostCategory.alpha = 1;subPostCategory.delegate = self
                ;subPostCategory.dataSource = self}
            else {subPostCategory.alpha = 0}
               print(tempCategoryDetail)
               print(didselect)
        default:
            didselect = tempCategoryDetail[row]
            print(didselect)
        }
    }
    
    var a :Timestamp?
    @IBOutlet weak var Introduction: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var PostCategory: UIPickerView!
    @IBOutlet weak var subPostCategory: UIPickerView!
    let locationManager = CLLocationManager()
    var didselect :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getLocation()
        
        shareInfo.loadData()
        locationTextField.delegate = self
        Introduction.delegate = self
        db = Firestore.firestore()
//        subPostCategory.delegate = self
//               subPostCategory.dataSource = self
        PostCategory.dataSource = self
        PostCategory.delegate = self
       
//        queryDatabase()
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func done(_ sender: Any) {
        var postUUID =  UUID().uuidString
//
        guard let transImage = self.imageview.image,let thumbImage = thumbnailImage(image: transImage),let image = thumbImage.jpegData(compressionQuality: 0.1) else {return}
             let fileName = "123.jpg"
            let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent(fileName)
        try? image.write(to: filePath!,options: [.atomic])
        let myphoto = CKAsset(fileURL: filePath!)
         newNote.setValue(myphoto, forKey: "myphoto")
        newNote.setValue(postUUID, forKey: "content")
        database.save(newNote) { (record, error) in
               if let error = error{
                   print(error)
               }
               guard   record  != nil else { return }
               
               print("saved record")
            
//        var annotatiobox : CLLocationCoordinate2D?
//            let request = NSFetchRequest<PostInfomation>(entityName: "Post")
//
//        postIn.postIntroduction = didselect ?? ""
            let postinformation = PostInfomation(context: self.sharepost.myContextPost) //有問題
 

//        postinformation.postCategory = didselect ?? Category[0]
//        postinformation.userLocation = locationTextField.text ?? "N/A"
//        postinformation.postIntroduction = Introduction.text ?? "N/A"
        
        
        let geoLocation = CLGeocoder()
            DispatchQueue.main.async {
                
            
            geoLocation.geocodeAddressString(self.locationTextField.text ?? "N/A"
            ) { (placemarks, error) in
                if let error = error{
                    print(error)
                }
              
               guard let placemark = placemarks?.first, let cordinate = placemark.location?.coordinate else {return}
                
               var annotationCoordinate  = cordinate
               
               
                
                    annotationCoordinate.latitude += 0.0001
                    annotationCoordinate.longitude += 0.0001
//                   let annotation = MKPointAnnotation()
//                   annotation.coordinate = annotationCoordinate
//                annotatiobox = annotationCoordinate
                postinformation.latitude = String(annotationCoordinate.latitude)
                postinformation.longitude = String(annotationCoordinate.longitude)
                postinformation.postCategory = self.didselect ?? "N/A"
                postinformation.postUUID = postUUID
                postinformation.postIntroduction = self.Introduction.text ?? "N/A"
                postinformation.userLocation = self.locationTextField.text ?? "N/A"
                
                self.sharepost.data.append(postinformation)
                self.sharepost.saveData()
           }
        }
//        sharepost.data.append(postinformation)
//        print(annotatiobox?.latitude)
        DispatchQueue.main.async {
          
            guard let authResultEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email else {return}
            //                let authResultEmail = "qweqwe"
                            
                            
                            self.db.collection("user").whereField("Gmail", isEqualTo: authResultEmail).getDocuments { (data, error) in
                                guard let data = data else {return}
                                    for i in data.documents{
                                        
                                        
                                        self.myNickName = (i.data()["nickName"] as! String)
                                        
                                        let parameters : [String:Any] = [
                                            "Name":"\(self.myNickName ?? "N/A" )",
                                        "postCategory":self.didselect  ?? self.Category[0] ,
                                        "userLocation":self.locationTextField.text  ?? "N/A" ,
                                        "postIntroduction":self.Introduction.text  ?? "N/A" ,
                                        "googleName":GIDSignIn.sharedInstance()?.currentUser.profile.name ?? "N/A",
                                        "postUUID":  postUUID ,
                                        "postTime":currentTime.share.time(),
                                        "viewsCount":0]
                                        self.db.collection("userPost").document("\(postUUID)").setData(parameters) { (error) in
                                        if let e = error{
                                            print("Error=\(e)")
                                            }
                                        }
                                        self.sharepost.saveData()
                                                  DispatchQueue.main.async {
                                                      self.navigationController?.popViewController(animated: true)
                                                  }
                                    }
            }
                                
//        let parameters : [String:Any] = [
//            "Name":"\(self.myNickName )",
//            "postCategory":self.didselect  ?? self.Category[0] ,
//            "userLocation":self.locationTextField.text  ?? "N/A" ,
//            "postIntroduction":self.Introduction.text  ?? "N/A" ,
//            "googleName":GIDSignIn.sharedInstance()?.currentUser.profile.name ?? "N/A",
//            "postUUID":  postUUID ,
//            "postTime":currentTime.share.time(),
//            "viewsCount":0]
            
           
//        "recordId":record?.recordID ?? "N/A"
//            self.db.collection("userPost").document("\(postUUID)").setData(parameters) { (error) in
//            if let e = error{
//                print("Error=\(e)")
//                }
//            }
            
        }
//            self.sharepost.saveData()
//            DispatchQueue.main.async {
//                self.navigationController?.popViewController(animated: true)
//            }
        
    }
  }

    
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getLocation()
    }
    
     func getLocation(){
              let locationManager = CLLocationManager()
                guard CLLocationManager.locationServicesEnabled() else{ return }//show some hint to user

                     //Ask permission
                     //Instacne method.
                    // locationManager.requestAlwaysAuthorization() 要求權限已在第一個畫面處理完畢 .desiredAccuracy = kCLLocationAccuracyBest
                     locationManager.desiredAccuracy = kCLLocationAccuracyBest
                     locationManager.activityType = .automotiveNavigation
                     locationManager.delegate = self
                     locationManager.startUpdatingLocation()
                     locationManager.allowsBackgroundLocationUpdates = true
    
        
                guard  let myLocation = locationManager.location else {return}
        
                let geocoder = CLGeocoder()
                 geocoder.reverseGeocodeLocation(myLocation) { (placemarks, error) in
                     if let error = error {
                         print("geocodeAddressSting:\(error)")
                         return
                     }
                    guard let placemark = placemarks?.first else {return}
                    let description = "\(placemark.country ?? "")"+"\(placemark.subAdministrativeArea ?? "")"+"\(placemark.locality ?? "")"
                    self.locationTextField.text = description
                    print(description)
                 }
        }
    @IBAction func camera(_ sender: Any) {
            
            let imagePicker = UIImagePickerController()//內建老師會再說
        imagePicker.sourceType = .photoLibrary //從相簿中選照片
            imagePicker.delegate = self
//            self.present(imagePicker,animated: true,completion: nil) //跳出選照片Controller
            self.present(imagePicker, animated: true)
        }
     
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            self.imageview.image = image
        }
          self.dismiss(animated: true, completion: nil)
    }
    
       func thumbnailImage(image:UIImage)->UIImage?{

            let thumbnailSize = CGSize(width: self.imageview.frame.size.width,height: self.imageview.frame.size.height); //設定縮圖大小
                   let scale = UIScreen.main.scale //找出目前螢幕的scale，視網膜技術為2.0
                   //產生畫布，第一個參數指定大小,第二個參數true:不透明（黑色底）,false表示透明背景,scale為螢幕scale
                   UIGraphicsBeginImageContextWithOptions(thumbnailSize,false,scale)

                   //計算長寬要縮圖比例，取最大值MAX會變成UIViewContentModeScaleAspectFill
                   //最小值MIN會變成UIViewContentModeScaleAspectFit
                   let widthRatio = thumbnailSize.width / image.size.width;
                   let heightRadio = thumbnailSize.height / image.size.height;

                   let ratio = min(widthRatio,heightRadio);

                   let imageSize = CGSize(width: image.size.width*ratio, height: image.size.height*ratio);

    //               let circlePath = UIBezierPath(ovalIn: CGRect(x: 0,y: 0,width: thumbnailSize.width,height: thumbnailSize.height))
    //               circlePath.addClip()

                   image.draw(in: CGRect(x: -(imageSize.width-thumbnailSize.width)/2.0, y: -(imageSize.height-thumbnailSize.height)/2.0,
                                         width: imageSize.width, height: imageSize.height))
                   //取得畫布上的縮圖
                   let smallImage = UIGraphicsGetImageFromCurrentImageContext();
                   //關掉畫布
                   UIGraphicsEndImageContext();
                   return smallImage

           }
    
}

    
 
