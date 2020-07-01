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
import FirebaseStorage
class PostVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UITextViewDelegate   {
    
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var PickViewControlView: UIView!
    @IBOutlet weak var mainCategoryTextField: UITextField!
    @IBOutlet weak var productName: UITextField!
    var myNickName : String!
    var notes = [CKRecord]()
    let testdata = [CKAsset]()
    let newNote = CKRecord(recordType: "Note")
    let database = CKContainer.default().publicCloudDatabase
    let sharepost = CoredataSharePost.share
    let shareInfo = CoredataShare.share
    var tempCategoryDetail = [String]()
     var tempNumber : Int!
    let myUID : String! = Auth.auth().currentUser?.uid
     var db :Firestore!
    
    
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
 
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
             
            switch pickerView {
            case PostCategory:
                didselect = Category[row]
                if didselect == "書籍文具票券" { showSubCategoryShow(WhichSubcategoryShow: bookandTicket) }
                else if didselect == "3c產品" { showSubCategoryShow(WhichSubcategoryShow: electronic3C) }
                    else if didselect == "玩具電玩" {  showSubCategoryShow(WhichSubcategoryShow: toyGame) }
                    else if didselect == "生活居家與家電" {  showSubCategoryShow(WhichSubcategoryShow: liveCategoryDetail) }
                    else if didselect == "影視音娛樂" {  showSubCategoryShow(WhichSubcategoryShow: musicVideo) }
                    else if didselect == "飲品食品" {  showSubCategoryShow(WhichSubcategoryShow: foodCategoryDetail) }
                    else if didselect == "保養彩妝" {  showSubCategoryShow(WhichSubcategoryShow: protecFace) }
                    else if didselect == "男裝配件" {  showSubCategoryShow(WhichSubcategoryShow: manTool) }
                    else if didselect == "女裝婦幼" {  showSubCategoryShow(WhichSubcategoryShow: WomanTool) }
                    
                else if didselect == "物品種類" {
                    UIView.animate(withDuration: 0.3) {
                    self.subPostCategory.alpha = 0;
                   self.PostCategory.center.x = super.view.center.x
                        self.mainCategoryTextField.text = ""
                     }
                    }
                caterogyTextField.text = ""
                    
                    
//                else {subPostCategory.alpha = 0
//                    UIView.animate(withDuration: 0.3) {
//                        self.PostCategory.center.x = super.view.center.x
//                    }
//
//                }
//     caterogyTextField.text = didselect
//                   print(tempCategoryDetail)
//                   print(didselect)
////                    caterogyTextField.text = didselect
               
                 
            default:
                didselect = tempCategoryDetail[row]
                 caterogyTextField.text = didselect
                print(didselect)
               
    //            self.PostCategory.frame.origin.x = 10
    //             self.PostCategory.center.x = super.view.center.x
            }
        }
    func showSubCategoryShow(WhichSubcategoryShow:[String]){
//        caterogyTextField.text = ""
        tempCategoryDetail = WhichSubcategoryShow
                        UIView.animate(withDuration: 0.3) {
                            self.subPostCategory.alpha = 1
                        }
                        
                        subPostCategory.delegate = self
                        subPostCategory.dataSource = self
//                        caterogyTextField.text = didselect
//        caterogyTextField.placeholder = didselect
        mainCategoryTextField.text = didselect
        print(caterogyTextField.placeholder)
                        UIView.animate(withDuration: 0.3) {
                        self.PostCategory.frame.origin.x = 0
                        }
                         
//                        print(tempCategoryDetail)
                
    }
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
    
    
    
 
    var a :Timestamp?
    @IBOutlet weak var Introduction: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var caterogyTextField: UITextField!
    @IBOutlet weak var PostCategory: UIPickerView!
    @IBOutlet weak var subPostCategory: UIPickerView!
    let locationManager = CLLocationManager()
    var didselect :String?
    
    
   
    var viewHeight :CGFloat!
    var navagationBarHegiht:CGFloat!
    var tabarItemHeight:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Introduction.layer.cornerRadius = 20.0
        
        
        viewHeight = self.view.frame.height
        navagationBarHegiht = self.navigationController?.navigationBar.frame.height
     
        self.myToolBar.alpha = 0
        let emptyView = UIView()
        caterogyTextField.inputView = emptyView
//        getLocation()
        shareInfo.loadData()
        locationTextField.delegate = self
        Introduction.delegate = self
        productName.delegate = self
        db = Firestore.firestore()
        PostCategory.dataSource = self
        PostCategory.delegate = self
        caterogyTextField.delegate = self
        
        
       
//        queryDatabase()
       
    }
   
    @IBAction func tap(_ sender: Any) {
             chosePhoto()
        
    }
    
    func chosePhoto( ) {
              
              
        let alerController = UIAlertController(title: "從相簿選擇照片或使用相機拍攝", message:nil, preferredStyle: .actionSheet)
             
        let photoLibrary = UIAlertAction(title: "相簿", style: .default) { (action) in
            let imagePicker = UIImagePickerController()//內建老師會再說
                         imagePicker.sourceType = .photoLibrary //從相簿中選照片
                             imagePicker.delegate = self
                 //            self.present(imagePicker,animated: true,completion: nil) //跳出選照片Controller
                             self.present(imagePicker, animated: true)
            
        }
        let camera = UIAlertAction(title: "相機", style: .default) { (action) in
            
            
        }
        let cancelaction = UIAlertAction(title: "取消", style: .cancel) { (cancel) in }
        alerController.addAction(camera)
              alerController.addAction(photoLibrary)
        alerController.addAction(cancelaction)
              present(alerController,animated: true)

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
    
    
    
    func pushDataToGoogle (data:Data,uuid:String){
         let data = data
                       
                      
          let ref = Storage.storage(url: "gs://noteapp-3d428.appspot.com").reference()
        let imageRef = ref.child("images/\(uuid)")
        let task = imageRef.putData(data as Data,metadata: nil){(metadata,error)in
              if let error = error{
                  print("uplad image fail\(error)")
              }
            
          }
          task.resume()
        
                  
    }
    //MARK: ->done送出
    @IBAction func done(_ sender: Any) {
        let serialQueue: DispatchQueue = DispatchQueue(label: "serialQueue")
          let delayQueue = DispatchQueue(label: "delayQueue")
         let ctx = CIContext()
        adressToCoreLocation(adress: self.locationTextField.text ?? "N/A") { (adressdata) in
//            
        let image = self.imageview.image
      
            let postUUID =  UUID().uuidString
            let filePath2 = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last?.appendingPathComponent(postUUID)
//            let filePath3 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent(postUUID)
            guard let transImage = self.imageview.image,let thumbImage = self.thumbnailImage(image: transImage),
                let imageData = thumbImage.jpegData(compressionQuality: 0.3) else {return}
            
            
            try? imageData.write(to: filePath2!, options: .atomicWrite)
            
//            let ciImage = CIImage(image: self.thumbnailImage(image: image!)!)
//            try! ctx.writePNGRepresentation(of: ciImage!, to: filePath3!, format: CIFormat.RGBA8, colorSpace: ctx.workingColorSpace!, options: [:])

//             try! ctx.writeHEIFRepresentation(of: ciImage!, to: filePath3!, format: CIFormat.RGBA8, colorSpace: ctx.workingColorSpace!, options: [:])
//            let data = try! Data(contentsOf: filePath3!)
//                        let ima = UIImage(ciImage: ciImage!)
//                        self.imageview.image = ima
            
            
//             let fileName = "tempImage.jpg"
//            let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent(fileName)
            
//        try? image.write(to: filePath2!,options: [.atomic])
            
//            let  compressData  = try? (imageData as NSData).compressed(using: .lzma) //壓縮檔案
            
            
           serialQueue.sync {
                self.pushDataToGoogle(data: imageData, uuid: postUUID)
           }
          
            
          
       
            delayQueue.asyncAfter(deadline: DispatchTime.now() + 2) {
                
                
//                guard let myGoogleName = GIDSignIn.sharedInstance()?.currentUser.profile.name else {return}
//                guard let authResultEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email else {return }
                self.db.collection("user").whereField("uid", isEqualTo: self.myUID!).getDocuments { (data, error) in
                    guard let data = data else {return}
                    for i in data.documents{
                        self.myNickName = (i.data()["nickName"] as! String)
                        let parameters : [String:Any] = [
                            "Name":"\(self.myNickName ?? "N/A" )",
                            "postCategory":self.didselect  ?? "N/A" ,
                            "userLocation":self.locationTextField.text  ?? "N/A" ,
                            "postIntroduction":self.Introduction.text  ?? "N/A" ,
                            "posterUID":self.myUID ?? "N/A" ,
                            "postUUID":  postUUID ,
                            "postTime":currentTime.share.time(),
                            "timeStamp": Timestamp(date: Date()),
                            "viewsCount":0,
                            "productName":self.productName.text ?? "N/A",
                            "favoriteCounts":0,
                            "userShortLocation":adressdata,
                            "mainCategory":self.mainCategoryTextField.text ?? "N/A",
                            "gmail":i.data()["Gmail"] as? String ?? i.data()["byuserKeyGmail"] as? String ?? "N/A" ]
                        
                        //save to allpost
                        self.db.collection("userPost").document("\(postUUID)").setData(parameters) { (error) in
                            if let e = error{
                                print("Error=\(e)")
                            }
                        }
                        //save to mypost
                        self.db.collection("user").document(self.myUID).collection("myPost").document(postUUID).setData(["we":1]) { (error) in
                            if let e = error{
                                print("Error=\(e)")
                            }
                        }
                        
                            self.navigationController?.popViewController(animated: true)
                        
                    }
                }
            }
          
            
//            try? compressData?.write(to: filePath2!, options: .atomicWrite)
//        let myphoto = CKAsset(fileURL: filePath!)
//            let compressedData = CKAsset(fileURL: filePath2!)
//            self.newNote.setValue(compressedData, forKey: "myphoto")
//        self.newNote.setValue(postUUID, forKey: "content")
//            self.database.save(self.newNote) { (record, error) in
//               if let error = error{
//                   print(error)
//               }
//               guard   record  != nil else { return }
//               print("saved record")
                
//        var annotatiobox : CLLocationCoordinate2D?
//            let request = NSFetchRequest<PostInfomation>(entityName: "Post")
//
//        postIn.postIntroduction = didselect ?? ""
//            let postinformation = PostInfomation(context: self.sharepost.myContextPost) //有問題
 

//        postinformation.postCategory = didselect ?? Category[0]
//        postinformation.userLocation = locationTextField.text ?? "N/A"
//        postinformation.postIntroduction = Introduction.text ?? "N/A"
        
        
//        let geoLocation = CLGeocoder()
//            DispatchQueue.main.async {
//
//
//            geoLocation.geocodeAddressString(self.locationTextField.text ?? "N/A"
//            ) { (placemarks, error) in
//                if let error = error{
//                    print(error)
//                }
//
//               guard let placemark = placemarks?.first, let cordinate = placemark.location?.coordinate else {return}
//
//               var annotationCoordinate  = cordinate
//
//
//
//                    annotationCoordinate.latitude += 0.0001
//                    annotationCoordinate.longitude += 0.0001
////                   let annotation = MKPointAnnotation()
////                   annotation.coordinate = annotationCoordinate
////                annotatiobox = annotationCoordinate
//                postinformation.latitude = String(annotationCoordinate.latitude)
//                postinformation.longitude = String(annotationCoordinate.longitude)
//                postinformation.postCategory = self.didselect ?? "N/A"
//                postinformation.postUUID = postUUID
//                postinformation.postIntroduction = self.Introduction.text ?? "N/A"
//                postinformation.userLocation = self.locationTextField.text ?? "N/A"
//
//                self.sharepost.data.append(postinformation)
//                self.sharepost.saveData()
//           }
//        }
//            DispatchQueue.main.async {
//                guard let myGoogleName = GIDSignIn.sharedInstance()?.currentUser.profile.name else {return}
//                guard let authResultEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email else {return}
//                self.db.collection("user").whereField("Gmail", isEqualTo: authResultEmail).getDocuments { (data, error) in
//                    guard let data = data else {return}
//                    for i in data.documents{
//                        self.myNickName = (i.data()["nickName"] as! String)
//                        let parameters : [String:Any] = [
//                            "Name":"\(self.myNickName ?? "N/A" )",
//                            "postCategory":self.didselect  ?? "N/A" ,
//                            "userLocation":self.locationTextField.text  ?? "N/A" ,
//                            "postIntroduction":self.Introduction.text  ?? "N/A" ,
//                            "googleName":myGoogleName ,
//                            "postUUID":  postUUID ,
//                            "postTime":currentTime.share.time(),
//                            "timeStamp": Timestamp(date: Date()),
//                            "viewsCount":0,
//                            "productName":self.productName.text ?? "N/A",
//                            "favoriteCounts":0,
//                            "userShortLocation":adressdata,
//                            "mainCategory":self.mainCategoryTextField.text ?? "N/A",
//                            "gmail":authResultEmail]
//
//                        //save to allpost
//                        self.db.collection("userPost").document("\(postUUID)").setData(parameters) { (error) in
//                            if let e = error{
//                                print("Error=\(e)")
//                            }
//                        }
//                        //save to mypost
//                        self.db.collection("user").document(myGoogleName).collection("myPost").document(postUUID).setData(["we":1]) { (error) in
//                            if let e = error{
//                                print("Error=\(e)")
//                            }
//                        }
////                        self.sharepost.saveData()
//                        DispatchQueue.main.async {
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                }
//            }
        }
    }
//    }

    
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
           tabarItemHeight = self.tabBarController?.tabBar.frame.height
       
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
                    let description = /*"\(placemark.country ?? "")"+*/"\(placemark.subAdministrativeArea ?? "")"+"\(placemark.locality ?? "")"
                    self.locationTextField.text = description
                     
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
        let filePath2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("testData")
         
       
        
      
        if let image = info[.originalImage] as? UIImage{
           
            
           
//            try! data?.write(to: filePath2!)
            self.imageview.image = image
            
            guard let transImage = self.imageview.image,let thumbImage = self.thumbnailImage(image: transImage),
                let imageData = thumbImage.jpegData(compressionQuality: 0.1) else {return}
            print(thumbImage.size.width)
            print(thumbImage.size.height)
            
            try? imageData.write(to: filePath2!, options: .atomicWrite)
//             do {
//
//                        let ctx = CIContext()
//                        let ciImage = CIImage(image: image)
//
//                try ctx.writeHEIFRepresentation(of: ciImage!, to: filePath2!, format: CIFormat.RGBA8, colorSpace: ctx.workingColorSpace!, options: [:])
//                let newci = CIImage(contentsOf: filePath2!)
////                let ima = UIImage(ciImage: ciImage!)
//               guard let source = CGImageSourceCreateWithURL(filePath2! as CFURL, nil) else { return  }
//                   guard let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else { return  }
//                self.imageview.image = UIImage(cgImage:   cgImage )
//
//
//
//                    } catch {
//                        print("ERROR", error.localizedDescription)
//                    }
        }
        
          self.dismiss(animated: true, completion: nil)
    }
    
    
       func thumbnailImage(image:UIImage)->UIImage?{
         let imageScale = image.size.width / image.size.height
        if imageScale >= 1 {
            let thumbnailSize = CGSize(width: super.view.frame.size.width * 0.5    ,
                                       height: (super.view.frame.size.width * 0.75 ) * 0.5  ); //設定縮圖大小
                               let scale = UIScreen.main.scale //找出目前螢幕的scale，視網膜技術為2.0
                               //產生畫布，第一個參數指定大小,第二個參數true:不透明（黑色底）,false表示透明背景,scale為螢幕scale
                               UIGraphicsBeginImageContextWithOptions(thumbnailSize,false,scale)

                               //計算長寬要縮圖比例，取最大值MAX會變成UIViewContentModeScaleAspectFill
                               //最小值MIN會變成UIViewContentModeScaleAspectFit
                               let widthRatio = thumbnailSize.width / image.size.width;
                               let heightRadio = thumbnailSize.height / image.size.height;

                               let ratio = min(widthRatio,heightRadio);

            //                   let imageSize = CGSize(width: image.size.width*ratio, height: image.size.height*ratio);
                   
            let imageSize = CGSize(width:  thumbnailSize.width   , height:  thumbnailSize.height );

                //               let circlePath = UIBezierPath(ovalIn: CGRect(x: 0,y: 0,width: thumbnailSize.width,height: thumbnailSize.height))
                //               circlePath.addClip()

                               image.draw(in: CGRect(x: -(imageSize.width-thumbnailSize.width), y: -(imageSize.height-thumbnailSize.height),
                                                     width: imageSize.width, height: imageSize.height))
                               //取得畫布上的縮圖
                               let smallImage = UIGraphicsGetImageFromCurrentImageContext();
                               //關掉畫布
                               UIGraphicsEndImageContext();
                               return smallImage
        } else if imageScale <= 1 {
            let thumbnailSize = CGSize(width:  super.view.frame.size.width * 0.5      ,
                                       height: (super.view.frame.size.width * 1.33 ) * 0.5  )   ; //設定縮圖大小
                                          let scale = UIScreen.main.scale //找出目前螢幕的scale，視網膜技術為2.0
                                          //產生畫布，第一個參數指定大小,第二個參數true:不透明（黑色底）,false表示透明背景,scale為螢幕scale
                                          UIGraphicsBeginImageContextWithOptions(thumbnailSize,false,scale)

                                          //計算長寬要縮圖比例，取最大值MAX會變成UIViewContentModeScaleAspectFill
                                          //最小值MIN會變成UIViewContentModeScaleAspectFit
                                          let widthRatio = thumbnailSize.width / image.size.width;
                                          let heightRadio = thumbnailSize.height / image.size.height;

                                          let ratio = min(widthRatio,heightRadio);

                       //                   let imageSize = CGSize(width: image.size.width*ratio, height: image.size.height*ratio);
                              
//                               let imageSize = CGSize(width:  thumbnailSize.width   , height:  thumbnailSize.height );
              let imageSize = CGSize(width:  thumbnailSize.width   , height:  thumbnailSize.height );

                           //               let circlePath = UIBezierPath(ovalIn: CGRect(x: 0,y: 0,width: thumbnailSize.width,height: thumbnailSize.height))
                           //               circlePath.addClip()

                                          image.draw(in: CGRect(x: -(imageSize.width-thumbnailSize.width), y: -(imageSize.height-thumbnailSize.height),
                                                                width: imageSize.width, height: imageSize.height))
                                          //取得畫布上的縮圖
                                          let smallImage = UIGraphicsGetImageFromCurrentImageContext();
                                          //關掉畫布
                                          UIGraphicsEndImageContext();
                                          return smallImage
        }
        return nil
       

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
    
    
    func adressToCoreLocation(adress:String,complite: @escaping (String) -> Void )  {
            let gecord = CLGeocoder()   //可以轉地址經緯度
                
        gecord.geocodeAddressString(adress) { (placemarks, error) in
                    if let error = error {
                        print("geocodeAddressSting:\(error)")
                        return
                            
                    }
                    guard let placemark = placemarks?.first,
                        
                        let coordinate = placemark.location?.coordinate else{
                            assertionFailure("Invalid placemark")
                            
                            return
                    }
            
//            let locationManager = CLLocationManager()
                          guard CLLocationManager.locationServicesEnabled() else{ return }//show some hint to user

                          let geocoder = CLGeocoder()
                           geocoder.reverseGeocodeLocation(placemark.location!) { (placemarks, error) in
                               if let error = error {
                                   print("geocodeAddressSting:\(error)")
                                   return
                               }
                              guard let placemark = placemarks?.first else {return}
                              let description = /*"\(placemark.country ?? "")"+*/"\(placemark.subAdministrativeArea ?? "")"+"\(placemark.locality ?? "")"
//                              self.locationTextField.text = description
                              print(description)
                            complite(description)
                           }
                    print("Lat, Lon \(coordinate.latitude ), \(coordinate.longitude )")
//            self.LocationToadress(CLLocation:placemark.location!,placemarks: placemarks!)
           
                }
        
    }
//    func LocationToadress(CLLocation:CLLocation,placemarks:[CLPlacemark]){
//               let locationManager = CLLocationManager()
//                 guard CLLocationManager.locationServicesEnabled() else{ return }//show some hint to user
//
//                 let geocoder = CLGeocoder()
//                  geocoder.reverseGeocodeLocation(CLLocation) { (placemarks, error) in
//                      if let error = error {
//                          print("geocodeAddressSting:\(error)")
//                          return
//                      }
//                     guard let placemark = placemarks?.first else {return}
//                     let description = /*"\(placemark.country ?? "")"+*/"\(placemark.subAdministrativeArea ?? "")"+"\(placemark.locality ?? "")"
//                     self.locationTextField.text = description
//                     print(description)
//                  }
//         }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
//         NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//
//           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
     }
     
     override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          NotificationCenter.default.removeObserver(self)
      }
     
     @objc func keyboardWillHide(notification : Notification)  {
      self.view.transform = CGAffineTransform(translationX: 0, y: 0)
      }


    @objc func keyBoardWillShow ( notification : Notification ){
        self.myToolBar.alpha = 1
         if let userInfo = notification.userInfo,
             let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect{
        
//            self.view.transform = CGAffineTransform(translationX: 0, y:
//                -(keyboardRectangle.height - tabarItemHeight - productName.frame.size.height  )
//
//            )
            
            print( self.tabBarController?.tabBar.frame.height)
            self.tabBarController?.tabBar.frame.height

         } 
    }
    
    
    
    @IBOutlet weak var myToolBar: UIToolbar!
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
 
    @IBAction func removeTextViewEdit(_ sender: UIBarButtonItem) {
        self.Introduction.text = ""
    }
    
    
}

 
