//
//  ViewController.swift
//  LQMultidirectionScroll
//
//  Created by Artron_LQQ on 2017/9/29.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.red
        btn.setTitle("开始", for: .normal)
        btn.frame = CGRect(x: 100, y: 200, width: 100, height: 40)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(start), for: .touchUpInside)
    }
    
    @objc func start() {
        let test = TestViewController()
        self.present(test, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

