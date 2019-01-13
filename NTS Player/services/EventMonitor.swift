//
//  EventMonitor.swift
//  NTS Player
//
//  Created by P Malone on 26/11/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

//Reuseable class to test for global events.
//Will allow the app to close

import Cocoa

public class EventMonitor {
    
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent) -> Void
    
    //listen to events. Like keydown, left click.
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent) -> Void) {
        self.mask = mask
        self.handler = handler
    }

    deinit {
        stop()
    }

    //listens to event - returns object.
    public func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    //remove that object.
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
    
}
