//
//  ImageView.swift
//  NTS Player
//
//  Created by P Malone on 02/12/2018.
//  Copyright © 2018 landahoy55. All rights reserved.
//

import Cocoa
    
class customAspectFillImageNSImageView: NSImageView {
        
        var scaleAspectFill : Bool = false
        
        
        override func awakeFromNib() {
            // Scaling : .scaleNone mandatory
            if scaleAspectFill { self.imageScaling = .scaleNone }
        }
        
        override func draw(_ dirtyRect: NSRect) {
            
            if scaleAspectFill, let _ = self.image {
                
                // Compute new Size
                let imageViewRatio   = self.image!.size.height / self.image!.size.width
                let nestedImageRatio = self.bounds.size.height / self.bounds.size.width
                var newWidth         = self.image!.size.width
                var newHeight        = self.image!.size.height
                
                
                if imageViewRatio > nestedImageRatio {
                    
                    newWidth = self.bounds.size.width
                    newHeight = self.bounds.size.width * imageViewRatio
                } else {
                    
                    newWidth = self.bounds.size.height / imageViewRatio
                    newHeight = self.bounds.size.height
                }
                
                self.image!.size.width  = newWidth
                self.image!.size.height = newHeight
                
            }
            
            // Draw AFTER resizing
            super.draw(dirtyRect)
        }
}
