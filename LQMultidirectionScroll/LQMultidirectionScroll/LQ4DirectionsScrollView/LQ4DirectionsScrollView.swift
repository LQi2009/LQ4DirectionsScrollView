//
//  LQ4DirectionsScrollView.swift
//  LQMultidirectionScroll
//
//  Created by Artron_LQQ on 2017/10/11.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

class LQ4DirectionsScrollView<T>: UIView, UITableViewDelegate, UITableViewDataSource {
    
    typealias LQ4DirectionsScrollViewHandle = (_ model: T) -> Void
    
    var dataSource: [[T]] = []
    var edgeInset: UIEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
    /// 有效滑动距离, 值越小, 滑动越灵敏
    var effectiveSlidingDistance: CGFloat = 30.0
    var backgroundView: UIView? {
        didSet{
            fourDirTable.backgroundView = backgroundView
        }
    }
    
    /// 横向初始索引位置
    var beginHorizontalIndex: Int = 0 {
        didSet{
            currentIndex = beginHorizontalIndex
        }
    }
    
    /// 竖向初始索引位置
    var beginVerticalIndex: Int = 0 {
        didSet{
            currentSection = beginVerticalIndex
        }
    }
    
    private var fourDirTable: UITableView!
    private var beginOffset: CGFloat = 0
    private var isBeginDrag: Bool = false
    private var currentSection: Int = 0
    private var currentIndex: Int = 0
    private var didSelectedHandle: LQ4DirectionsScrollViewHandle?
    private var didScrolledHandle: LQ4DirectionsScrollViewHandle?
    
    deinit {
        print("LQ4DirectionsScrollView deinit")
    }
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - datas: 数据源
    ///   - frame: frame
    ///   - didSelected: 选择回调
    ///   - didScrolled: 滚动回调
    init(withDatas datas: [[T]], frame: CGRect, didSelected: LQ4DirectionsScrollViewHandle?, didScrolled: LQ4DirectionsScrollViewHandle?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        if self.dataSource.count > 0 {
            self.dataSource.removeAll()
        }
        
        self.dataSource += datas
        didScrolledHandle = didScrolled
        didSelectedHandle = didSelected
        self.frame = frame
        
        setupMainView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        setupMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    func didSelected(_ handle: @escaping LQ4DirectionsScrollViewHandle) -> LQ4DirectionsScrollView {
        
        didSelectedHandle = handle
        return self
    }
    
    @discardableResult
    func didScrolled(_ handle: @escaping LQ4DirectionsScrollViewHandle) -> LQ4DirectionsScrollView {
        
        didScrolledHandle = handle
        return self
    }
    
    private func setupMainView() {
        
        let table = UITableView(frame: self.bounds, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.isPagingEnabled = true
        table.separatorStyle = .none
        table.keyboardDismissMode = .onDrag
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = self.backgroundColor
        self.addSubview(table)
        fourDirTable = table
        
        table.register(LQ4DirectionTableViewCell<T>.self, forCellReuseIdentifier: "LQ4DirectionTableViewCellReuseIdentifier")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        fourDirTable.backgroundColor = self.backgroundColor
        fourDirTable.scrollToRow(at: IndexPath.init(row: 0, section: currentSection), at: .middle, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LQ4DirectionTableViewCellReuseIdentifier", for: indexPath) as! LQ4DirectionTableViewCell<T>
        
        cell.edgeInset = edgeInset
        cell.currentIndex = currentIndex
        cell.effectiveSlidingDistance = effectiveSlidingDistance
        if backgroundView != nil {
            cell.backgroundColor = UIColor.clear
        } else {
            cell.backgroundColor = self.backgroundColor
        }
        
        let models = dataSource[indexPath.section]
        
        cell.configDatas(models)
        
        cell.didScrolled { [weak self](index) in
            
            self?.currentIndex = index
            if let handle = self?.didScrolledHandle {
                handle(models[index])
            }
        }
        
        cell.didSelected {[weak self] (index) in
            if let handle = self?.didSelectedHandle {
                handle(models[index])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height
    }
    
//   MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if isBeginDrag {
            return
        }
        isBeginDrag = true
        beginOffset = scrollView.contentOffset.y
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        if isBeginDrag {
            // 计算滑动幅度
            let currentOffset = scrollView.contentOffset.y - beginOffset
            //向上滑动
            if currentOffset - effectiveSlidingDistance > 0 {
                // 如果滑动达到一定幅度, 则滚动到下一个
                currentSection += 1
                if currentSection >= dataSource.count {
                    currentSection = dataSource.count - 1
                }
            } else if currentOffset + effectiveSlidingDistance < 0  {
                // 如果滑动达到一定幅度, 则滚动到前一个
                currentSection -= 1
                if currentSection < 0 {
                    currentSection = 0
                }
            }
        }
        
        let indexPath = IndexPath(row: 0, section: currentSection)
        let arr = dataSource[currentSection]
        let model = arr[currentIndex]
        
        let table = scrollView as! UITableView
        table.scrollToRow(at: indexPath, at: .middle, animated: true)
        
        if isBeginDrag {
            isBeginDrag = false
            if let handle = didScrolledHandle {
                handle(model)
            }
        }
    }
}
