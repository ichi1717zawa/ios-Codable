import Foundation
import CoreData
import UIKit
import MapKit
class PostInfomation : NSManagedObject    {
    let mycontextPost = CoredataSharePost.share.myContextPost
    
    let shareuserInfo = CoredataShare.share
    @NSManaged  var postCategory : String
    @NSManaged  var userLocation : String
    @NSManaged  var nickname: String
    @NSManaged  var postIntroduction: String
    @NSManaged  var postID: String
    @NSManaged  var latitude: String
    @NSManaged  var longitude: String
    @NSManaged  var googleName: String
    @NSManaged  var postUUID: String
    @NSManaged  var postTime: String
    @NSManaged  var viewsCount: Int
    
    
    override func awakeFromInsert() {
        //        let mycontextPost = CoredataSharePost.share.myContextPost
        //        let request = NSFetchRequest<UserInfomation>(entityName: "UserInfo")
        //        let results = try! mycontextPost.fetch(request)
        
        //         let resultst = try? mycontextPost.fetch(request)
        
        
        //        let shareuserinfo = UserInfomation(context: shareuserInfo.myContext)
        //        self.nickname = results[0].nickname
        //        self.userLocation = shareuserinfo.userLocation
        //        self.postID = UUID().uuidString
        
        
    }
    
    
    
    
}
