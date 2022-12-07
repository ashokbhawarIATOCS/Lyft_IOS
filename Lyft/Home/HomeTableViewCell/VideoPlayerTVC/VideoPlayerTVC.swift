//
//  VideoPlayerTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 04/11/22.
//

import UIKit
import AVFoundation

class VideoPlayerTVC: UITableViewCell {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var videoPlayerButton: UIButton!
    @IBOutlet weak var thumnailImageView: UIImageView!
    
    //create your closure here
    var pausePalyButtonPressed : (() -> ()) = {}
    
    // I have put the avplayer layer on this view
         @IBOutlet weak var videoPlayerSuperView: UIView!
         var avPlayer: AVPlayer?
         var avPlayerLayer: AVPlayerLayer?
         var paused: Bool = false
     
    //This will be called everytime a new value is set on the videoplayer item
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        videoPlayerSuperView.backgroundColor = .clear
        self.setupMoviePlayer()
        
        if avPlayer != nil {
            avPlayer?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        }
        
    }
    
    func setupMoviePlayer(){
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        avPlayer?.volume = 3
        avPlayer?.actionAtItemEnd = .pause
        avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: videoPlayerSuperView.frame.height)
        self.videoPlayerSuperView.layer.insertSublayer(avPlayerLayer!, at: 0)

        // This notification is fired when the video ends, you can handle it in the method.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
                if #available(iOS 10.0, *) {
                    let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
                    let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
                    if newStatus != oldStatus {
                       DispatchQueue.main.async {[weak self] in
                           if newStatus == .playing || newStatus == .paused {
                               self?.videoPlayerSuperView.activityStopAnimating()
                           } else {
                               self?.videoPlayerSuperView.activityStartAnimating()
                           }
                       }
                    }
                } else {
                    // Fallback on earlier versions
                    self.videoPlayerSuperView.activityStopAnimating()
                }
            }
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func videoPlayerButtonAction(_ sender: Any) {
        videoPlayerButton.isHidden = true
        thumnailImageView.isHidden = true
        pausePalyButtonPressed()
    }
        func stopPlayback(){
            self.avPlayer?.pause()
        }
    
        func startPlayback(){
            self.avPlayer?.play()
        }

        // A notification is fired and seeker is sent to the beginning to loop the video again
    @objc func playerItemDidReachEnd(notification: Notification) {
            let p: AVPlayerItem = notification.object as! AVPlayerItem
            p.seek(to: CMTime.zero)
        }

}


