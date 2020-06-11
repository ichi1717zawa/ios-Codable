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
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var PickViewControlView: UIView!
    var myNickName : String!
    var notes = [CKRecord]()
    let testdata = [CKAsset]()
    let newNote = CKRecord(recordType: "Note")
    let database = CKContainer.default().publicCloudDatabase
    let sharepost = CoredataSharePost.share
    let shareInfo = CoredataShare.share
    enum detailCategory : String {
         case 書籍文具票券 = "書籍文具票券"
         case 產品3C = "3c產品"
        case 玩具電玩 = "玩具電玩"
        case 生活居家與家電 = "生活居家與家電"
        case 影視音娛樂 = "影視音娛樂"
        case 飲品食品 = "飲品食品"
        case 保養彩妝 = "保養彩妝"
        case 男裝配件 = "男裝配件"
        case 女裝婦幼 = "女裝婦幼"
        
    }
    let Category = ["物品種類","書籍文具票券","3c產品","玩具電玩","生活居家與家電","影視音娛樂","飲品食品","保養彩妝","男裝配件","女裝婦幼"]
     /*書籍文具票券*/let  bookandTicket = ["書籍","雜誌","文具","票券"]
    /*3c產品*/let  electronic3C = ["電腦與周邊配件","手機與周邊配件","相機與周邊配件","平板與周邊配件","耳機喇叭麥克風"]
    /*玩具電玩*/let  toyGame = ["電腦遊戲與周邊","主機遊戲與周邊","掌上型遊戲與周邊","公仔模型","玩偶娃娃","桌遊牌卡","其他玩具"]
    /*生活居家與家電*/let liveCategoryDetail = ["家具","收納","寢具燈具","健身器材","廚房衛浴","居家裝飾","小型家電","中大型家電","五金修繕","單車汽機車與周邊"]
    /*影視音娛樂*/let  musicVideo = ["樂器","影音設備","CD_DVD","偶像明星"]
   /*飲品食品*/ let foodCategoryDetail = ["生鮮蔬果","休閒零食","各地名產","熟食小吃","米麵乾貨","蛋糕甜點","飲料_沖泡品"]
    /*保養彩妝*/ let protecFace = ["彩妝用品","清潔保養","美髮護理","身體清潔保養","美甲用品","香水香氣","男性保養","其他小物", ]
    /*男裝配件*/ let manTool = ["上衣類","下身類","鞋襪周邊","各式男包","飾品手錶"]
    /*女裝婦幼*/ let WomanTool = ["上衣類","下身類","一件式","鞋襪周邊","各式女包","飾品手錶","男女童裝","哺育用品","嬰幼兒配件",]
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
                UIView.animate(withDuration: 0.3) {
                    self.subPostCategory.alpha = 1
                }
                
                subPostCategory.delegate = self
                subPostCategory.dataSource = self
                caterogyTextField.text = didselect
                UIView.animate(withDuration: 0.3) {
                self.PostCategory.frame.origin.x = 10
                }
                 
                print(tempCategoryDetail)
                
            } else if didselect == "飲品食品" {
               
                tempCategoryDetail =  foodCategoryDetail;
                UIView.animate(withDuration: 0.3) {
                self.subPostCategory.alpha = 1};
                subPostCategory.delegate = self;
                subPostCategory.dataSource = self ;
                caterogyTextField.text = didselect
                UIView.animate(withDuration: 0.3) {
                self.PostCategory.frame.origin.x = 10
                }
            }
                
            else {subPostCategory.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    self.PostCategory.center.x = super.view.center.x
                }
                  
            }
 
               print(tempCategoryDetail)
               print(didselect)
                caterogyTextField.text = didselect
           
             
        default:
            didselect = tempCategoryDetail[row]
            print(didselect)
            caterogyTextField.text = didselect
//            self.PostCategory.frame.origin.x = 10
//             self.PostCategory.center.x = super.view.center.x
        }
    }
    
 
    var a :Timestamp?
    @IBOutlet weak var Introduction: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var caterogyTextField: UITextField!
    @IBOutlet weak var PostCategory: UIPickerView!
    @IBOutlet weak var subPostCategory: UIPickerView!
    let locationManager = CLLocationManager()
    var didselect :String?
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        let emptyView = UIView()
        caterogyTextField.inputView = emptyView
//        getLocation()
        shareInfo.loadData()
        locationTextField.delegate = self
        Introduction.delegate = self
        db = Firestore.firestore()
//        subPostCategory.delegate = self
//               subPostCategory.dataSource = self
        PostCategory.dataSource = self
        PostCategory.delegate = self
        caterogyTextField.delegate = self
        
        
       
//        queryDatabase()
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func categoryTextFieldTouch(_ sender: Any) {
        maskView.alpha = 1
        UIView.animate(withDuration: 0.3) {
            self.PostCategory.alpha = 1
            self.PickViewControlView.alpha = 1
        }
         
       }
    func textFieldDidEndEditing(_ textField: UITextField) {
        maskView.alpha = 0
        PostCategory.alpha = 0
        subPostCategory.alpha = 0
        PickViewControlView.alpha = 0
        print("done")
    }
    @IBAction func done(_ sender: Any) {
        let postUUID =  UUID().uuidString
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
                                        "postCategory":self.didselect  ?? "N/A" ,
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
    
      
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
             print("qw")
           return true
        }
        else if action == #selector(cut(_:)) {
            print("we")
           return false
        }
        else if action == #selector(selectAll(_:)) {
            print("we")
           return false
        }
          return false
    }
}

 
