//
//  StreamPlayer.swift
//  NTS Player
//
//  Created by P Malone on 06/12/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

class StreamPlayer {
    
    var player = AVPlayer()
    //var channel: String
    
//    init(channel_: String) {
//        channel = channel_
//    }

    init() {
       print("Player created")
    }
    
    
//    "http://stream-relay-geo.ntslive.net/stream2"
    func play() {
        
        let urlString = "http://stream-relay-geo.ntslive.net/stream"
        guard let url = URL(string: urlString) else { return }
        
        let playerItem = AVPlayerItem(url: url)
        
        player = AVPlayer(playerItem: playerItem)
        player.play()
        
    }
    
    
    
//    @objc func playStation(_ sender: Any?) {
//
//        let item = sender as! NSMenuItem
//
//        if (player.rate != 0 && player.error == nil) {
//            print("Playing...", item.title)
//            player.pause()
//            return
//        }
//
//        switch item.tag {
//        case 1:
//            player(url: "http://stream-relay-geo.ntslive.net/stream")
//        case 2:
//            player(url: "http://stream-relay-geo.ntslive.net/stream2")
//        default:
//            player(url: "http://stream-relay-geo.ntslive.net/stream")
//        }
//
//    }
//
//    func player(url: String) {
//        let urlString = url
//        guard let url = URL(string: urlString) else { return }
//
//        let playerItem = AVPlayerItem(url: url)
//
//        player = AVPlayer(playerItem: playerItem)
//        player.play()
//
//    }
    
}
