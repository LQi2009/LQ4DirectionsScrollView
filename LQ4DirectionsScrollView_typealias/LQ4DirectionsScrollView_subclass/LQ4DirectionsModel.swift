//
//  LQ4DirectionsModel.swift
//  LQMultidirectionScroll
//
//  Created by Artron_LQQ on 2017/10/11.
//  Copyright © 2017年 Artup. All rights reserved.
//

//protocol LQ4DirectionsProtocol {
//    associatedtype LQ4Model
//}
import UIKit

typealias LQ4Model = LQ4DirectionsModel
class LQ4DirectionsModel: NSObject {
    

    
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var name: String = ""
    
    var size: String {
        
        return "\(width)x\(height)cm"
    }
    
    var color: UIColor = UIColor.white
}
