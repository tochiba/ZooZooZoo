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
    @IBOutlet weak var tableView: SettingTableView!
}

class SettingTableView: UITableView {
    var timer: NSTimer = NSTimer()
    var counter: Int = 0

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if self.timer.valid {
            self.counter++
        }
        else {
            // Timer生成
            self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "resetTimer", userInfo: nil, repeats: false)
        }
        check()
    }
    
    func resetTimer() {
        self.counter = 0
        self.timer.invalidate()
    }
    
    private func check() {
        if self.counter > 10 {
            Config.setDevMode(!Config.isNotDevMode())
            self.reloadData()
            resetTimer()
        }
    }
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingData.titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SettingData.cellName, forIndexPath: indexPath)
        if Config.isNotDevMode() {
            cell.textLabel?.text = SettingData.titles[indexPath.row] + "ON"
        }
        else {
            cell.textLabel?.text = ""
        }
        return cell
    }
}

struct SettingData {
    static let titles: [String] = ["入稿ツールモード"]
    static let cellName = "SettingCell"
}