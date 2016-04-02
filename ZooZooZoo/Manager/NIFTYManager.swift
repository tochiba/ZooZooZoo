//
//  NIFTYManager.swift
//  ZooZooZoo
//
//  Created by 千葉 俊輝 on 2016/04/03.
//  Copyright © 2016年 Toshiki Chiba. All rights reserved.
//

import Foundation
import NCMB

protocol NIFTYManagerDelegate: class {
    func didFinishLoad()
}

class NIFTYManager {
    static let sharedInstance = NIFTYManager()
    
    // TODO: NCMBObject継承したモデル書き込み
    // TODO: NCMBObject継承したモデルの読み込み
    // TODO: Like
    // TODO: 時間順、新着順、人気順にソート
}

// TODO: NCMBObject継承したモデル作成