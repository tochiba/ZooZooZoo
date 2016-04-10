//
//  VideoViewController.swift
//  ZooZooZoo
//
//  Created by 千葉 俊輝 on 2016/04/10.
//  Copyright © 2016年 Toshiki Chiba. All rights reserved.
//

import Foundation
import UIKit
import XCDYouTubeKit

class VideoViewController: XCDYouTubeVideoPlayerViewController {
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}