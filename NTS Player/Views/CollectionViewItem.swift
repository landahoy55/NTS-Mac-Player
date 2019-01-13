//
//  CollectionViewItem.swift
//  NTS Player
//
//  Created by P Malone on 02/12/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import Cocoa


protocol ChannelSelectionDelegate : class {
    func changeChannel(channel: String)
}

class CollectionViewItem: NSCollectionViewItem {

    //Get model object in...
    var result: Result? {
        didSet {
            print("Result set")
            guard let result = result else { return }
            self.titleLabel.stringValue = result.now.broadcastTitle.uppercased()
            self.channelLabel.stringValue = "LIVE ON \(result.channelName)"
            self.cityLabel.stringValue = result.now.embeds.details.locationLong?.uppercased() ?? ""
            print(result.now.embeds.details.media.backgroundLarge)
            self.loadImage(urlString: result.now.embeds.details.media.backgroundLarge)
            
        }
    }
    
    weak var delegate: ChannelSelectionDelegate?
    
    
    @IBOutlet weak var channelLabel: NSTextField!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var cityLabel: NSTextField!
    @IBOutlet weak var artistImageView: NSImageView!
    @IBOutlet weak var playButton: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.cgColor
        
        //artistImageView.imageFrameStyle = .photo
        artistImageView.imageScaling = .scaleProportionallyDown
    }
    
    
    
    @IBAction func playButton(_ sender: NSButton) {
        
        guard let channel = result?.channelName else { return }
        delegate?.changeChannel(channel: channel)
        
    }
    
    
    //move out of here.
    func loadImage(urlString: String) {
        
        print("Loading Image")
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            guard let data = data else { return }
            // let image = UIImage(data: data)
            let image = NSImage(data: data)
            
            DispatchQueue.main.async {
                self.artistImageView.image = image
            }
            
        }.resume()
    }
    
}
