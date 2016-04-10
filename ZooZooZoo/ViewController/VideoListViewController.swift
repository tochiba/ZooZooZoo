//
//  VideoListViewController.swift
//  ZooZooZoo
//
//  Created by tochiba on 2016/03/31.
//  Copyright © 2016年 Toshiki Chiba. All rights reserved.
//

import Foundation
import WebImage
import XCDYouTubeKit
import SwiftRefresher

class VideoListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var cellSize: CGSize = CGSizeZero
    private var videoList: [AnimalVideo] = []
    private var isLoading: Bool = false
    
    var queryString: String = ""

    enum Mode {
        case Category
        case Favorite
        case New
        case Popular
    }
    var mode: Mode = .Category
    
    class func getInstance(query: String, color: UIColor=UIColor.whiteColor()) -> VideoListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewControllerWithIdentifier("VideoListViewController") as? VideoListViewController {
            vc.queryString = query
            vc.view.backgroundColor = color
            vc.collectionView.backgroundColor = color
            return vc
        }
        
        return self.init()
    }
    
    class func getInstanceWithMode(mode: Mode, color: UIColor=UIColor(red: 138/255, green: 200/255, blue: 135/255, alpha: 0.4)) -> VideoListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewControllerWithIdentifier("VideoListViewController") as? VideoListViewController {
            vc.view.backgroundColor = color
            vc.collectionView.backgroundColor = color
            vc.mode = mode
            return vc
        }
        
        return self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.hidden = false
        self.indicator.startAnimating()
        
        let refresher = Refresher { [weak self] () -> Void in
            self?.reload()
            self?.loadData()
            self?.collectionView.reloadData()
            self?.collectionView.srf_endRefreshing()
        }
        self.collectionView.srf_addRefresher(refresher)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupColloectionView()
    }
       
    override func viewDidLayoutSubviews() {
        setupCellSize()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        setData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func deviceOrientationDidChange(notification: NSNotification) {
        setupCellSize()
    }
}

extension VideoListViewController {
    private func setData() {
        switch self.mode {
        case .Category:
            if Config.isNotDevMode() {
                NIFTYManager.sharedInstance.search(self.queryString, aDelegate: self)
            }
            else {
                APIManager.sharedInstance.search(self.queryString, aDelegate: self)
            }
            return
        case .Favorite:
            FavoriteManager.sharedInstance.load(self)
            return
        case .New:
            if Config.isNotDevMode() {
                NIFTYManager.sharedInstance.search(true, aDelegate: self)
            }
            else {
                self.videoList = []
                self.collectionView.reloadData()
            }
            return
        case .Popular:
            if Config.isNotDevMode() {
                NIFTYManager.sharedInstance.search(false, aDelegate: self)
            }
            else {
                self.videoList = []
                self.collectionView.reloadData()
            }
            return
        }
    }
    
    private func loadData() {
        switch self.mode {
        case .Category:
            if Config.isNotDevMode() {
                self.videoList = NIFTYManager.sharedInstance.getAnimalVideos(self.queryString)
            }
            else {
                self.videoList = APIManager.sharedInstance.getAnimalVideos(self.queryString)
            }
            return
        case .Favorite:
            self.videoList = FavoriteManager.sharedInstance.getFavoriteVideos()
            return
        case .New:
            if Config.isNotDevMode() {
                self.videoList = NIFTYManager.sharedInstance.getAnimalVideos("New")
            }
            return
        case .Popular:
            if Config.isNotDevMode() {
                self.videoList = NIFTYManager.sharedInstance.getAnimalVideos("Popular")
            }
            return
        }
    }
    
    private func setupColloectionView() {
        if let nvc = self.parentViewController as? UINavigationController {
            for vc in nvc.viewControllers {
                if let vlc = vc as? VideoListViewController {
                    vlc.collectionView.scrollsToTop = false
                }
            }
        }
        self.collectionView.scrollsToTop = true
    }
    
    private func setupCellSize() {
        let space: Int = 1 //マージン
        var spaceNum: Int = 0 //スペースの数
        var cellNum: Int = 1 //セルの数
        
        if UIApplication.isLandscape() {
            if UIApplication.isPad() {
                spaceNum = 2
                cellNum  = 3
            }
            else {
                spaceNum = 1
                cellNum  = 2
            }
        }
        else {
            if UIApplication.isPad() {
                spaceNum = 1
                cellNum  = 2
            }
            else {
                spaceNum = 0
                cellNum  = 1
            }
        }
        
        let screenSizeWidth = self.view.frame.size.width//UIScreen.mainScreen().bounds.size.width
        let size = (screenSizeWidth - CGFloat(space * spaceNum)) / CGFloat(cellNum)
        self.cellSize = CGSizeMake(size, size * 0.6)
        self.collectionView.reloadData()
    }
    
    private func reload() {
        if isLoading == true {
            return
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.isLoading = true
            dispatch_async(dispatch_get_main_queue(), {
                self.loadData()
                self.indicator.startAnimating()
                self.indicator.hidden = true
                self.collectionView.reloadData()
                self.isLoading = false
            })
        })
    }
    
    private func playVideo(id: String) {
        let vc = XCDYouTubeVideoPlayerViewController(videoIdentifier: id)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerPlaybackDidFinish:", name: MPMoviePlayerPlaybackDidFinishNotification, object: vc.moviePlayer)
        self.presentMoviePlayerViewControllerAnimated(vc)
    }
    
    func moviePlayerPlaybackDidFinish(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

extension VideoListViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videoList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("VideoCell", forIndexPath: indexPath) as? CardCollectionCell {
            let video = self.videoList[indexPath.row]
            
            cell.imageView.image = nil
            if let url = NSURL(string: video.thumbnailUrl) {
                cell.imageView.sd_setImageWithURL(url)
            }
            cell.titleLabel.text = video.title
            
            cell.setup(video, delegate: self)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension VideoListViewController: UICollectionViewDelegate {
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let v = self.videoList[indexPath.row]
//        playVideo(v.id)
//
//        if Config.isNotDevMode() {
//            NIFTYManager.sharedInstance.incrementLike(v)
//            if self.mode == .Favorite {
//                FavoriteManager.sharedInstance.removeFavoriteVideo(v)
//            }
//            else {
//                FavoriteManager.sharedInstance.addFavoriteVideo(v)
//            }
//        }
//        else {
//            NIFTYManager.sharedInstance.deliverThisVideo(v)
//        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
}

extension VideoListViewController: UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.cellSize
    }
}

extension VideoListViewController: SearchAPIManagerDelegate {
    func didFinishLoad() {
        reload()
    }
}

extension VideoListViewController: NIFTYManagerDelegate {
    func didLoad() {
        reload()
    }
}

extension VideoListViewController: FavoriteManagerDelegate {
    func didLoadFavoriteData() {
        reload()
    }
}

extension VideoListViewController: CardCollectionCellDelegate {
    func didPushFavorite() {
        reload()
    }
    
    func didPushSetting() {
        
    }
    
    func didPushPlay() {
        
    }
}