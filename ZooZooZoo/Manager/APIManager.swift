//
//  APIManager.swift
//  ZooZooZoo
//
//  Created by 千葉 俊輝 on 2016/03/27.
//  Copyright © 2016年 Toshiki Chiba. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    static let sharedInstance = APIManager()
    
    func load() {
        Alamofire.request(.GET, API.YoutubeSearchURL + "Cat" + API.Key)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)
                print(json)
        }
    }
}

struct API {
    static let Key = "&key=XXXXXXXXXXXXXX"
    static let YoutubeSearchURL = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&order=date&q="
    static let YoutubeChanelURL = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&order=viewCount&channelId="
}
