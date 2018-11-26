//
//  AppDelegate.swift
//  NTS Player
//
//  Created by P Malone on 24/11/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import Cocoa
import AVFoundation
import AVKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        //When event happens outside of app...
        //Weak self to remove retain cycles.
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown, .beginGesture], handler: { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        })
        
        //Set up to create a menu bar app.
        
        //        if let button = statusItem.button {
        //            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        //            button.image?.isTemplate = true
        //            button.action = #selector(playStation(_:))
        //        }
        //
        //        contructMenu()

        
        
        //Popover app
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.image?.isTemplate = true
            button.action = #selector(togglePopover(_:))
        }
        
        popover.contentViewController = NowPlayingViewController.freshController()
        
    }
    
    //Mark:- Functionality for popover app
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    //Set up
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    
    //Close
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    
    
    
    //Mark:- Funcitonality for menu bar item
    
    var player = AVPlayer()
   
    @objc func playStation(_ sender: Any?) {
        
        let item = sender as! NSMenuItem
        
        if (player.rate != 0 && player.error == nil) {
            print("Playing...", item.title)
            player.pause()
            return
        }
        
        switch item.tag {
        case 1:
            player(url: "http://stream-relay-geo.ntslive.net/stream")
        case 2:
            player(url: "http://stream-relay-geo.ntslive.net/stream2")
        default:
            player(url: "http://stream-relay-geo.ntslive.net/stream")
        }
        
    }
    
    func player(url: String) {
        let urlString = url
        guard let url = URL(string: urlString) else { return }
        
        let playerItem = AVPlayerItem(url: url)
        
        player = AVPlayer(playerItem: playerItem)
        player.play()
        
        let menuItem = menu.items[0]
        menuItem.title = "Pause"
    }

    
    let menu = NSMenu()
    
    //Key equivalent is a shortcut
    func contructMenu() {
        
        //do this with a forloop, taking in station objects...
        
        let item1 = NSMenuItem(title: "NTS 1", action: #selector(AppDelegate.playStation(_:)), keyEquivalent: "1")
        item1.tag = 1
        menu.addItem(item1)
        
        let item2 = NSMenuItem(title: "NTS 2", action: #selector(AppDelegate.playStation(_:)), keyEquivalent: "2")
        item2.tag = 2
        menu.addItem(item2)
        
        
        //seperator line... nice!
        menu.addItem(NSMenuItem.separator())
        
        //Terminates the app...
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

