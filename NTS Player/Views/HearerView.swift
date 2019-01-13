//
//  HearerView.swift
//  NTS Player
//
//  Created by P Malone on 06/12/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import Cocoa

class HeaderView: NSView {

    
    @IBOutlet weak var textLabel: NSTextField!
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        print("********** Header View")
        self.layer?.backgroundColor = .black
        
    }
    
}
