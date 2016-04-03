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
    func didLoad()
}

class NIFTYManager {
    static let sharedInstance = NIFTYManager()
    private var animalVideoDic: [String:[AnimalVideo]] = [:]
    weak var delegate: NIFTYManagerDelegate?
    
    func deliverThisVideo(video: AnimalVideo) {
        if !isDelivered(video) {
            backgroundSaveObject(video)
        }
    }
    
    private func isDelivered(video: AnimalVideo) -> Bool {
        // TODO: 読み込まれてない場合があるのでその対応
        let items = getAnimalVideos(video.animalName, isEncoded: true)

        if let _ = items.indexOf({$0.id == video.id}) {

            return true
        }
        
        return false
    }
    
    private func backgroundSaveObject(video: AnimalVideo) {
        video.saveInBackgroundWithBlock({ error in
            if error != nil {
                // Error
            }
        })
    }

    func getAnimalVideos(query: String, isEncoded: Bool=false) -> [AnimalVideo] {
        
        var encodedString = ""
        if !isEncoded {
            guard let encoded = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
                return []
            }
            encodedString = encoded
        }
        else {
            encodedString = query
        }
        
        guard let array = self.animalVideoDic[encodedString] else {
            return []
        }
        
        return array
    }

    func search(query: String, aDelegate: NIFTYManagerDelegate?) {
        self.delegate = aDelegate
        
        guard let encodedString = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            return
        }
        
        let q = NCMBQuery(className: AnimalVideo.className())
        q.limit = 200
        q.whereKey(AnimalVideoKey.animalNameKey, equalTo: encodedString)
        q.findObjectsInBackgroundWithBlock({
            (array, error) in
            if error == nil {
                var aArray: [AnimalVideo] = []
                for a in array {
                    
                    if let _a = a as? NCMBObject {
                        if  let i = _a.objectForKey(AnimalVideoKey.idKey) as? String,
                            let ana = _a.objectForKey(AnimalVideoKey.animalNameKey) as? String,
                            let d = _a.objectForKey(AnimalVideoKey.dateKey) as? String,
                            let t = _a.objectForKey(AnimalVideoKey.titleKey) as? String,
                            let th = _a.objectForKey(AnimalVideoKey.thumbnailUrlKey) as? String {
                                
                                let an = AnimalVideo()
                                an.id = i
                                an.animalName = ana
                                an.date = d
                                an.title = t
                                an.thumbnailUrl = th
                                if let de = _a.objectForKey(AnimalVideoKey.videoUrlKey) as? String {
                                    an.descri = de
                                }
                                if let v = _a.objectForKey(AnimalVideoKey.videoUrlKey) as? String {
                                    an.videoUrl = v
                                }
                                aArray.append(an)
                        }
                    }
                }
                self.animalVideoDic[encodedString] = aArray
            }
            self.delegate?.didLoad()
        })
    }
    

    // TODO: Like
    // TODO: 時間順、新着順、人気順にソート
}
