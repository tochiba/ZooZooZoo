//
//  AnimalMovie.swift
//  ZooZooZoo
//
//  Created by tochiba on 2016/03/30.
//  Copyright © 2016年 Toshiki Chiba. All rights reserved.
//

import Foundation
import NCMB

class AnimalVideo: NCMBObject, NSCoding {

    class func className() -> String {
        return "Video"
    }
    
    var id: String              = "" {
        didSet {
            self.setObject(id, forKey: AnimalVideoKey.idKey)
        }
    }

    var animalName: String      = "" {
        didSet {
            self.setObject(animalName, forKey: AnimalVideoKey.animalNameKey)
        }
    }

    var date: String            = "" {
        didSet {
            self.setObject(date, forKey: AnimalVideoKey.dateKey)
        }
    }

    var title: String           = "" {
        didSet {
            self.setObject(title, forKey: AnimalVideoKey.titleKey)
        }
    }

    var descri: String    = "" {
        didSet {
            self.setObject(descri, forKey: AnimalVideoKey.descriKey)
        }
    }

    var thumbnailUrl: String    = "" {
        didSet {
            self.setObject(thumbnailUrl, forKey: AnimalVideoKey.thumbnailUrlKey)
        }
    }

    var videoUrl: String        = "" {
        didSet {
            self.setObject(videoUrl, forKey: AnimalVideoKey.videoUrlKey)
        }
    }

    
    override init() {
        super.init(className: AnimalVideo.className())
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(className: AnimalVideo.className())
        
        if let i = aDecoder.decodeObjectForKey(AnimalVideoKey.idKey) as? String {
            self.id = i
            self.setObject(i, forKey: AnimalVideoKey.idKey)
        }
        if let a = aDecoder.decodeObjectForKey(AnimalVideoKey.animalNameKey) as? String {
            self.animalName = a
            self.setObject(a, forKey: AnimalVideoKey.animalNameKey)
        }
        if let date = aDecoder.decodeObjectForKey(AnimalVideoKey.dateKey) as? String {
            self.date = date
            self.setObject(date, forKey: AnimalVideoKey.dateKey)
        }
        if let title = aDecoder.decodeObjectForKey(AnimalVideoKey.titleKey) as? String {
            self.title = title
            self.setObject(title, forKey: AnimalVideoKey.titleKey)
        }
        if let d = aDecoder.decodeObjectForKey(AnimalVideoKey.descriKey) as? String {
            self.descri = d
            self.setObject(d, forKey: AnimalVideoKey.descriKey)
        }
        if let t = aDecoder.decodeObjectForKey(AnimalVideoKey.thumbnailUrlKey) as? String {
            self.thumbnailUrl = t
            self.setObject(t, forKey: AnimalVideoKey.thumbnailUrlKey)
        }
        if let v = aDecoder.decodeObjectForKey(AnimalVideoKey.videoUrlKey) as? String {
            self.videoUrl = v
            self.setObject(v, forKey: AnimalVideoKey.videoUrlKey)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: AnimalVideoKey.idKey)
        aCoder.encodeObject(animalName, forKey: AnimalVideoKey.animalNameKey)
        aCoder.encodeObject(date, forKey: AnimalVideoKey.dateKey)
        aCoder.encodeObject(title, forKey: AnimalVideoKey.titleKey)
        aCoder.encodeObject(descri, forKey: AnimalVideoKey.descriKey)
        aCoder.encodeObject(thumbnailUrl, forKey: AnimalVideoKey.thumbnailUrlKey)
        aCoder.encodeObject(videoUrl, forKey: AnimalVideoKey.videoUrlKey)
    }
}

struct AnimalVideoKey {
    static let idKey: String              = "id"
    static let animalNameKey: String      = "animalName"
    static let dateKey: String            = "date"
    static let titleKey: String           = "title"
    static let descriKey: String          = "descri"
    static let thumbnailUrlKey: String    = "thumbnailUrl"
    static let videoUrlKey: String        = "videoUrl"
}

class Like: NCMBObject {
    class func className() -> String {
        return "Like"
    }
    
    var id: String              = "" {
        didSet {
            self.setObject(id, forKey: LikeKey.idKey)
        }
    }

    var likeCount: Int          = 0 {
        didSet {
            self.setObject(likeCount, forKey: LikeKey.likeCountKey)
        }
    }
    
    override init() {
        super.init(className: Like.className())
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(className: Like.className())
    }
}


struct LikeKey {
    static let idKey: String            = "id"
    static let likeCountKey: String     = "likeCount"
}
