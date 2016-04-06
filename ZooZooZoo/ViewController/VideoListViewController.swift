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
    
    class func getInstanceWithMode(mode: Mode, color: UIColor=UIColor.whiteColor()) -> VideoListViewController {
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
        setupCellSize()
        reload()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupColloectionView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setData()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        setupCellSize()
        self.collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
            // TODO: お気に入り読み込み
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
            // TODO: お気に入り読み込み
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
        let spaceNum: Int = 0 //スペースの数
        let cellNum: Int = 1 //セルの数
        let screenSizeWidth = UIScreen.mainScreen().bounds.size.width
        let size = (screenSizeWidth - CGFloat(space * spaceNum)) / CGFloat(cellNum)
        self.cellSize = CGSizeMake(size, size * 0.6)
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("VideoCell", forIndexPath: indexPath)
        let video = self.videoList[indexPath.row]
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            imageView.image = nil
            if let url = NSURL(string: video.thumbnailUrl) {
                imageView.sd_setImageWithURL(url)
            }
        }
        if let timeLabel = cell.viewWithTag(2) as? UILabel {
            timeLabel.text = video.date
        }
        if let titleLabel = cell.viewWithTag(3) as? UILabel {
            titleLabel.text = video.title
        }
        if let likeLabel = cell.viewWithTag(4) as? UILabel {
            likeLabel.text = String(video.likeCount) + "Like♡"
        }
        return cell
    }
}

extension VideoListViewController: UICollectionViewDelegate {
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let v = self.videoList[indexPath.row]
        playVideo(v.id)

        if Config.isNotDevMode() {
            NIFTYManager.sharedInstance.incrementLike(v)
        }
        else {
            NIFTYManager.sharedInstance.deliverThisVideo(v)
        }
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