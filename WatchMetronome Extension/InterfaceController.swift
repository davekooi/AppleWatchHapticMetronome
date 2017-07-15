//
//  InterfaceController.swift
//  WatchMetronome Extension
//
//  Created by David Kooistra on 7/14/17.
//  Copyright © 2017 David. All rights reserved.
//

import WatchKit
import Foundation

extension InterfaceController: WKCrownDelegate {
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        print("\(rotationalDelta)")
        
        crownAccumulator += rotationalDelta
        if crownAccumulator > 0.1 {
            mySliderValue += 1
            crownAccumulator = 0.0
        } else if crownAccumulator < -0.1 {
            mySliderValue -= 1
            crownAccumulator = 0.0
        }
        
        
    }
}


class InterfaceController: WKInterfaceController {
    
    var isRunning = false

    var time = 0
    
    var timer = Timer()
    
    var crownAccumulator = 0.0
    
    var metroToggle = false
    
    @IBOutlet var myLabel: WKInterfaceLabel!
    @IBOutlet var startStopButton: WKInterfaceButton!
    @IBOutlet var slider: WKInterfaceSlider!
    
    @IBAction func pressedSlider(_ value: Float) {
        
        mySliderValue = Int(value)

    }
    
    var mySliderValue : Int = 0 {
        didSet {
            if mySliderValue < 40 || mySliderValue > 218 {
                mySliderValue = oldValue
            }
            myLabel.setText("\(mySliderValue)")
            slider.setValue(Float(mySliderValue))
        }
    }
    
    
    
    @IBAction func PressedStartStopButton() {
        
        if isRunning {
            startStopButton.setTitle("START")
            isRunning = false
            timer.invalidate()
        }
        else {
            startStopButton.setTitle("STOP")
            isRunning = true
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(Int(mySliderValue)/60), target: self, selector: #selector(incr), userInfo: nil, repeats: true)
        }
        
    }
    
    func incr() {
        time += 1
        // myLabel.setText(String(time))
        if(metroToggle) {
            myLabel.setTextColor(.blue)
            metroToggle = false
        }
        else {
            myLabel.setTextColor(.yellow)
            metroToggle = true
        }
        print(String(mySliderValue))
        print(String(Int(mySliderValue)))
        
    }
    
    override func willActivate() {
        super.willActivate()
        crownSequencer.focus()
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        crownSequencer.delegate = self as WKCrownDelegate
        // Configure interface objects here.
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
