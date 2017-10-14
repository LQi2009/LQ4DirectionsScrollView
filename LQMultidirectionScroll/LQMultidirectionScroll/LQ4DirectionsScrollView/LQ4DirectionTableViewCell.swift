//
//  LQ4DirectionTableViewCell.swift
//  LQMultidirectionScroll
//
//  Created by Artron_LQQ on 2017/10/11.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

typealias LQ4DirectionTableViewCellActionHandle = (_ index: Int) -> Void
class LQ4DirectionTableViewCell<T>: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var edgeInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var currentIndex: Int = 0
    /// 有效滑动距离, 值越小, 滑动越灵敏
    var effectiveSlidingDistance: CGFloat = 30.0
    
    private var dataSource: [T] = []
    private var multCollection: UICollectionView!
    private var didScrolledHandle: LQ4DirectionTableViewCellActionHandle?
    private var didSelectedHandle: LQ4DirectionTableViewCellActionHandle?
    private var beginOffset: CGFloat = 0
    private var isBeginDrag: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configDatas(_ datas: [T]) {
        
        if dataSource.count > 0 {
            dataSource.removeAll()
        }
        
        dataSource += datas
    }
    
    func didScrolled(_ handle: @escaping LQ4DirectionTableViewCellActionHandle) {
        didScrolledHandle = handle
    }
    
    func didSelected(_ handle: @escaping LQ4DirectionTableViewCellActionHandle) {
        didSelectedHandle = handle
    }
    
    private func setupMainView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        self.contentView.addSubview(collection)
        multCollection = collection
        collection.backgroundColor = self.backgroundColor
        collection.register(LQ4CollectionCell<T>.self, forCellWithReuseIdentifier: "LQ4DirectionsCellReuseIdentifier")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        multCollection.frame = self.bounds
        
        let indexPath = IndexPath(item: 0, section: currentIndex)
        multCollection?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LQ4DirectionsCellReuseIdentifier", for: indexPath) as! LQ4CollectionCell<T>
        
        let model = dataSource[indexPath.section]
        cell.configData(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let handle = didSelectedHandle {
            handle(indexPath.section)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return (edgeInset.left + edgeInset.right)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return (edgeInset.left + edgeInset.right)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.frame.width - edgeInset.left - edgeInset.right, height: self.frame.height - edgeInset.bottom - edgeInset.top)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return edgeInset
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if isBeginDrag {
            return
        }
        isBeginDrag = true
        
        // 距离开始的offset, 用于计算滑动幅度
        beginOffset = scrollView.contentOffset.x
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        if isBeginDrag {
            
            let currentOffset = scrollView.contentOffset.x - beginOffset
            //向左滑动
            if currentOffset - effectiveSlidingDistance > 0 {
                // 如果滑动达到一定幅度, 则滚动到下一个
                currentIndex += 1
                if currentIndex >= dataSource.count {
                    currentIndex = dataSource.count - 1
                }
            } else if currentOffset + effectiveSlidingDistance < 0  {
                // 如果滑动达到一定幅度, 则滚动到前一个
                currentIndex -= 1
                if currentIndex < 0 {
                    currentIndex = 0
                }
            }
        }
        
        let indexPath = IndexPath(item: 0, section: currentIndex)
        
        let collection = scrollView as! UICollectionView
        collection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if isBeginDrag {
            isBeginDrag = false
            if let handle = didScrolledHandle {
                handle(currentIndex)
            }
        }
    }
}
