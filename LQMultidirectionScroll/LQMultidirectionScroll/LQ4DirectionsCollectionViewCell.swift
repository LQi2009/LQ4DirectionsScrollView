//
//  LQ4DirectionsCollectionViewCell.swift
//  LQMultidirectionScroll
//
//  Created by Artron_LQQ on 2017/10/11.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

typealias LQ4CollectionCell = LQ4DirectionsCollectionViewCell
class LQ4DirectionsCollectionViewCell<T>: UICollectionViewCell {
    
    let bgview = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(bgview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(_ model: T) {
        let md = model as! LQ4DirectionsModel
        
//        self.backgroundColor = md.color
        bgview.backgroundColor = md.color
        var width = self.contentView.frame.width
        var height = md.height*width/md.width
        if height > self.contentView.frame.height {
            height = self.contentView.frame.height
            width = height*md.width/md.height
        }
        bgview.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        bgview.center = self.contentView.center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
