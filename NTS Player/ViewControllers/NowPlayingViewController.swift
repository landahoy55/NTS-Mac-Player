//
//  NowPlayingViewController.swift
//  NTS Player
//
//  Created by P Malone on 25/11/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import Cocoa
import AVFoundation
import AVKit

class NowPlayingViewController: NSViewController {

    var NTS: NTS?
    var streamPlayer: StreamPlayer?
    var player = AVPlayer()
    
    //Replace with collection view in code...
    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
    
        //Simple networking
        
        guard let url = URL(string: "https://www.nts.live/api/v2/live") else { return }
        let task = URLSession.shared.ntsTask(with: url) { nts, response, error in
         if let nts = nts {
           print(nts.results[0].now.broadcastTitle)
           print(nts.results[1].now.broadcastTitle)
            
           self.NTS = nts
           
            DispatchQueue.main.async {
                 self.collectionView.reloadData()
            }
         }
       }
       task.resume()

       view.layer?.backgroundColor = .black
        
    }
    
    
    fileprivate func configureCollectionView() {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = NSSize(width: 299, height: 300)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        //flowLayout.headerReferenceSize = CGSize(width: 50, height: 50)

        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
        collectionView.layer?.backgroundColor = NSColor.yellow.cgColor
        collectionView.layer?.borderColor = NSColor.black.cgColor
    }
}

//extension NowPlayingViewController {
//
//
//    @IBAction func quit(_ sender: NSButton) {
//        NSApplication.shared.terminate(sender)
//    }
//
//}

//Storyboard instantiation
extension NowPlayingViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> NowPlayingViewController {
       
        let sb = NSStoryboard(name: "Main", bundle: nil)
        let id = NSStoryboard.SceneIdentifier(stringLiteral: "NowPlayingViewController")
       
        guard let vc = sb.instantiateController(withIdentifier: id) as? NowPlayingViewController else {
            fatalError("Check Main.storyboard")
        }
        
        return vc
    }
}

extension NowPlayingViewController: NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return 2
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        
        guard let collectionviewItem = item as? CollectionViewItem else { return item }
        guard let NTS = NTS else { return item }
        
        collectionviewItem.result = NTS.results[indexPath.item]
        collectionviewItem.delegate = self
        
        return item
    
    }
    
    
    
//    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
//
//        print("Triggeringggggg")
//
//        let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderView"), for: indexPath) as! HeaderView
//
//
//        return view
//    }
 
}

//Header
//extension NowPlayingViewController: NSCollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
//
//        print("Delegate method for size...")
//
//        return NSSize(width: 600, height: 50)
//
//    }
//
//
//
//}

extension NowPlayingViewController: ChannelSelectionDelegate {
    
    func changeChannel(channel: String) {
//        streamPlayer = StreamPlayer()
//        streamPlayer?.play()

        print("Change channel function")
        
        if (player.rate != 0 && player.error == nil) {
            print("Playing...")

            player.pause()
            return
        }
        
        player(url: "https://stream-relay-geo.ntslive.net/stream")
        
    }
    
    func player(url: String) {
        
        print("Player function", url)
        
        guard let url = URL(string: url) else { return }
        
        let playerItem = AVPlayerItem(url: url)
        
        player = AVPlayer(playerItem: playerItem)
        player.allowsExternalPlayback = true
        player.play()
        
    }
    
}
