//
//  InterfaceController.swift
//  BitWatch WatchKit Extension
//
//  Created by Fox Peterson on 4/25/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import BitWatchKit
import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    
    @IBOutlet weak var image: WKInterfaceImage!
    
    @IBOutlet weak var lastUpdated: WKInterfaceLabel!
    
    let tracker = Tracker()
    var updating = false
    
    private func updatePrice(price:NSNumber) {
        priceLabel.setText(Tracker.priceFormatter.stringFromNumber(price))
    }
    
    private func updateDate(date: NSDate) {
        self.lastUpdated.setText("Last updated \(Tracker.dateFormatter.stringFromDate(date))")
    }
    
    private func update(){
        if !updating {
            updating = true
            let originalPrice = tracker.cachedPrice()
            tracker.requestPrice{ (price, error) -> () in
                if error == nil {
                    self.updatePrice(price!)
                    self.updateDate(NSDate())
                    self.updateImage(originalPrice, newPrice: price!)
                }
                self.updating = false
            }
        }
    }
    
    private func updateImage(originalPrice: NSNumber, newPrice: NSNumber) {
        if originalPrice.isEqualToNumber(newPrice) {
            // 1
            image.setHidden(true)
        } else {
            // 2
            if newPrice.doubleValue > originalPrice.doubleValue {
                image.setImageNamed("Up")
            } else {
                image.setImageNamed("Down")
            }
            image.setHidden(false)
        }
    }
    
    @IBOutlet weak var priceLabel: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        // Configure interface objects here. This is basically the "main"
        super.awakeWithContext(context)
        updatePrice(tracker.cachedPrice())
        
        image.setHidden(true)
        updateDate(tracker.cachedDate())
        
    }
    
    

    @IBAction func refreshTapped() {
        update()
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        update()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
