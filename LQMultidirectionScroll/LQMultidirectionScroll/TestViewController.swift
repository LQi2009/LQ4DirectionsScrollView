//
//  TestViewController.swift
//  LQMultidirectionScroll
//
//  Created by Artron_LQQ on 2017/10/12.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    var dataSource: [[LQ4DirectionsModel]] = []
    lazy var label: UILabel = {
        
        let lab = UILabel()
        lab.frame = CGRect(x: 20, y: 340, width: 260, height: 100)
        lab.textColor = UIColor.black
        lab.backgroundColor = UIColor.brown
        lab.numberOfLines = 0
        self.view.addSubview(lab)
        return lab
    }()
    
    deinit {
        print("TestViewController deinit")
    }
    
    @objc func start() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        loadData()
        label.text = "滑动看看"
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.red
        btn.setTitle("返回", for: .normal)
        btn.frame = CGRect(x: 10, y: 20, width: 100, height: 40)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(start), for: .touchUpInside)
        
        let frame = CGRect(x: 20, y: 100, width: 200, height: 200)

        let scroll = LQ4DirectionsScrollView(withDatas: dataSource, frame: frame, didSelected: {[weak self] (model) in
            print("commit selected -- \(model.name)-\(model.size)")
            self?.alert("\(model.name) 色-大小: \(model.size)")
        }) {[weak self] (model) in
            print("backgroundView scrolled --\(model.name)-\(model.size)")
            self?.label.text = "\(model.name)\n大小: \(model.size)"
            self?.label.backgroundColor = model.color
        }
        
        scroll.backgroundColor = UIColor.brown
//        scroll.edgeInset = UIEdgeInsets(top: 30, left: 40, bottom: 40, right: 50)
        let image = UIImage(named: "7.jpg")
        
        scroll.backgroundView = UIImageView(image: image)
        self.view.addSubview(scroll)
    }

    func alert(_ text: String) {
        let alert = UIAlertController(title: nil, message: "你选择了 \(text)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "我知道了", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func create2() {
        
        let frame = CGRect(x: 40, y: 60, width: 200, height: 400)
        
        let scroll = LQ4DirectionsScrollView<LQ4DirectionsModel>(frame: frame).didScrolled { (model) in
            
            }.didSelected { (model) in
                
        }
        
        scroll.dataSource = dataSource
        
        scroll.backgroundColor = UIColor.brown
        //        scroll.edgeInset = UIEdgeInsets(top: 30, left: 40, bottom: 40, right: 50)
        let image = UIImage(named: "7.jpg")
        
        scroll.backgroundView = UIImageView(image: image)
        self.view.addSubview(scroll)
    }
    
    func create1() {
        
        let frame = CGRect(x: 40, y: 60, width: 200, height: 400)

        let scroll = LQ4DirectionsScrollView<LQ4DirectionsModel>(frame: frame)
        scroll.dataSource = dataSource
        
        scroll.backgroundColor = UIColor.brown
        //        scroll.edgeInset = UIEdgeInsets(top: 30, left: 40, bottom: 40, right: 50)
        let image = UIImage(named: "7.jpg")
        
        scroll.backgroundView = UIImageView(image: image)
        self.view.addSubview(scroll)

        scroll.didScrolled { (model) in
            print("over scrolled --\(model.name)-\(model.size)")
            
            
        }
        
        scroll.didSelected { (model) in
            print("over selected -- \(model.name)-\(model.size)")
        }

    }
    func loadData() {
        
        let widths = [400, 200, 300, 400, 500, 300]
        let height = [500, 300, 300, 300, 400, 200]
        let colors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.cyan, UIColor.blue, UIColor.purple, self.radomColor()]
        let names = ["红", "橙", "黄", "绿", "青", "蓝", "紫", "随机"]
        
        for i in 0..<widths.count {
            var tmpArr: [LQ4DirectionsModel] = []
            
            for j in 0..<colors.count {
                let model = LQ4DirectionsModel()
                model.width = CGFloat(widths[i])
                model.height = CGFloat(height[i])
                model.color = colors[j]
                model.name = names[j]
                tmpArr.append(model)
            }
            
            dataSource.append(tmpArr)
        }
    }
    
    func radomColor() -> UIColor {
        
        let red = arc4random() % 255
        let green = arc4random() % 255
        let blue = arc4random() % 255
        
        return UIColor.init(displayP3Red: CGFloat(red)/CGFloat(255.0), green: CGFloat(green)/CGFloat(255.0), blue: CGFloat(blue)/CGFloat(255.0), alpha: 1.0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
