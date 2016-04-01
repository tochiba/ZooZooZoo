//
//  ViewController.swift
//  ZooZooZoo
//
//  Created by 千葉 俊輝 on 2016/03/26.
//  Copyright © 2016年 Toshiki Chiba. All rights reserved.
//

import UIKit
import TabPageViewController

struct VideoCategory {
    static let category: [String] = ["うさぎ", "ハムスター","モモンガ","ナマケモノ","ペンギン"]
    static let categoryColor: [UIColor] = [
        UIColor(red: 251/255, green: 252/255, blue: 149/255, alpha: 1.0),
        UIColor(red: 252/255, green: 150/255, blue: 149/255, alpha: 1.0),
        UIColor(red: 149/255, green: 218/255, blue: 252/255, alpha: 1.0),
        UIColor(red: 149/255, green: 252/255, blue: 197/255, alpha: 1.0),
        UIColor(red: 252/255, green: 182/255, blue: 106/255, alpha: 1.0),
        UIColor(red: 246/255, green: 175/255, blue:  32/255, alpha: 1.0)]
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController {
    private func setupView() {
        let tc = TabPageViewController.create()
        tc.isInfinity = true
        
        for tuple in VideoCategory.category.enumerate() {
            tc.tabItems.append((VideoListViewController.getInstance(tuple.element, color: VideoCategory.categoryColor[tuple.index]), tuple.element))
        }
        
        //let nc = UINavigationController()
        let nc = self.navigationController!
        nc.viewControllers = [tc]
        
        var option = TabPageOption()
        option.currentColor = UIColor(red: 246/255, green: 175/255, blue: 32/255, alpha: 1.0)
        tc.option = option
        self.presentViewController(nc, animated: false, completion: nil)
    }
}
