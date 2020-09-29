//
//  dataModel.swift
//  ios-Codable
//
//  Created by ichi1717zawa on 2020/9/28.
//

import Foundation

struct openData: Codable {
     var TestTarget :String
     var 補助受理單位名稱 :String
     var 住址 :String
     var 電話01 :String
     var F5 :String?
    
    enum CodingKeys: String, CodingKey {
        case TestTarget = "編號"
        case 補助受理單位名稱
        case 住址
        case 電話01
        case F5
      }
}
