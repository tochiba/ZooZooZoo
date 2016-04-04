//
//  ActivityManager.swift
//  ZooZooZoo
//
//  Created by 千葉 俊輝 on 2016/04/04.
//  Copyright © 2016年 Toshiki Chiba. All rights reserved.
//

import Foundation
import UIKit

class ActivityManager: NSObject {
    
    class private func getActivityViewController(vc: UIViewController?, video: AnimalVideo) -> UIActivityViewController {
        
        // 共有する項目
        let shareText = "\(video.title) #ZooZooZoo \n\(URL.YoutubeShare)\(video.id)\n"
        let shareWebsite = NSURL(string: URL.AppStore)!
        let activityItems = [shareText, shareWebsite]
        
        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = vc?.view
        
        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypePrint
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        let completionHandler:UIActivityViewControllerCompletionWithItemsHandler = { (str, isFinish, arr, error) in
            if isFinish {
                //vc?.showToast("投稿が完了しました", title: "シェア")
            }
            else {
                //NADInterstitial.sharedInstance().showAd()
            }
        }
        activityVC.completionWithItemsHandler = completionHandler
        return activityVC
    }
    
    class func showActivityView(viewController: UIViewController, video: AnimalVideo) {
        weak var vc = viewController
        vc?.presentViewController(getActivityViewController(vc, video: video), animated: true, completion: nil)
    }
}