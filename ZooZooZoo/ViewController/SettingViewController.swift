//
//  SettingViewController.swift
//  ZooZooZoo
//
//  Created by 千葉 俊輝 on 2016/04/02.
//  Copyright © 2016年 Toshiki Chiba. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
}

extension SettingViewController {
    class func getInstance() -> SettingViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewControllerWithIdentifier("SettingViewController") as? SettingViewController {
            return vc
        }
        
        return self.init()
    }
}

extension SettingViewController: UITableViewDelegate {
}

extension SettingViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingData.titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SettingData.cellName, forIndexPath: indexPath)
        cell.textLabel?.text = SettingData.titles[indexPath.row]
        return cell
    }
}

struct SettingData {
    static let titles: [String] = ["ライセンス"]
    static let cellName = "SettingCell"
}