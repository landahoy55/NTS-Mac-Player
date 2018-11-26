//
//  NowPlayingViewController.swift
//  NTS Player
//
//  Created by P Malone on 25/11/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import Cocoa

class NowPlayingViewController: NSViewController {

    @IBOutlet var textLabel: NSTextField!
    
    let quotes = Quote.all
    

    var currentQuoteIndex: Int = 0 {
        didSet {
            updateQuote()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        currentQuoteIndex = 0
    }
    
    func updateQuote() {
        textLabel.stringValue = String(describing: quotes[currentQuoteIndex])
    }
}

extension NowPlayingViewController {
    
    
    //Nice way to loop through the array.
    @IBAction func previous(_ sender: NSButton) {
        currentQuoteIndex = (currentQuoteIndex - 1 + quotes.count) % quotes.count
    }
    
    @IBAction func next(_ sender: NSButton) {
        currentQuoteIndex = (currentQuoteIndex + 1) % quotes.count
    }
    
    
    @IBAction func quit(_ sender: NSButton) {
        NSApplication.shared.terminate(sender)
    }
    
}

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
