
import UIKit
import MapKit
import Firebase
import GoogleSignIn
import CloudKit
class myPostDetailVC: UIViewController      {
    var data : PostInfomation!
    var db = Firestore.firestore()
    var annotation : MKAnnotation?
    var tempIndex : IndexPath!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postimage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var niceNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    var image : UIImage!
    let database = CKContainer.default().publicCloudDatabase
    var receiverAnnotationData : AnnotationDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
 
       
        let filter: String! = self.data.postUUID
        print(filter!)
        let predicate: NSPredicate = NSPredicate(format: "content = %@", filter)
        let query = CKQuery(recordType: "Note", predicate: predicate)
//
        database.perform(query, inZoneWith: nil) { (records, _) in
            guard var records = records else {return}
            for record in records{

                let asset = record["myphoto"] as! CKAsset
                let imageData = NSData(contentsOf: asset.fileURL!)
                let image = UIImage(data: imageData! as Data)

                DispatchQueue.main.async {
                    self.postimage.image = image
                    self.maskView.alpha = 0
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.clearCache()
                }
            }
        }

        categoryLabel.text = "種類：\(data.postCategory)"
        niceNameLabel.text = "暱稱：\(data.nickname)"
        userLocationLabel.text = "供取貨位置：\(data.userLocation)"
        discriptionLabel.text = "物品簡介：\(data.postIntroduction)"

    }
     


    func clearCache(){

          let cacheURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("CloudKit")
            let fileManager = FileManager.default
            do {
                // Get the directory contents urls (including subfolders urls)
              let directoryContents = try FileManager.default.contentsOfDirectory( at: cacheURL, includingPropertiesForKeys: nil, options: [])
                for file in directoryContents {
                    do {
                        try fileManager.removeItem(at: file)
                    }
                    catch let error as NSError {
                        debugPrint("Ooops! Something went wrong: \(error)")
                    }

                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

    
}
