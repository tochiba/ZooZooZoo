//
//  BannerView.swift
//  ZooZooZoo
//
//  Created by 千葉 俊輝 on 2016/04/12.
//  Copyright © 2016年 Toshiki Chiba. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class BannerView: GADBannerView, GADBannerViewDelegate {
    func setup(viewController: UIViewController, unitID: String, isDebug: Bool=false) {
        self.delegate = self
        self.adUnitID = unitID
        self.rootViewController = viewController
        self.adSize = kGADAdSizeSmartBannerPortrait
        let request = GADRequest()
        if isDebug {
            request.testDevices = [""]
        }
        self.loadRequest(request)
    }
}