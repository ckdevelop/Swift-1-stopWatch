//
//  ViewController.swift
//  stopwatch
//
//  Created by Chris Chen on 8/27/16.
//  Copyright © 2016 ChunHan Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var lapButton: UIButton!
    @IBOutlet var myTableView: UITableView!
    
    var counter = 0.00
    var timer = NSTimer()
    var isPlaying = false
    var lapArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startButton.hidden = false
        startButton.enabled = true
        resetButton.hidden = false
        resetButton.enabled = true
        stopButton.hidden = true
        stopButton.enabled = false
        lapButton.hidden = true
        lapButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetAction(sender: AnyObject) {
        
        startButton.hidden = false
        startButton.enabled = true
        resetButton.hidden = false
        resetButton.enabled = true
        stopButton.hidden = true
        stopButton.enabled = false
        lapButton.hidden = true
        lapButton.enabled = false
        
        timer.invalidate()
        counter = 0
        timeLabel.text = "00:00:00"
        isPlaying = false
        
        lapArray.removeAllObjects()
        myTableView.reloadData()
    }

    @IBAction func startAction(sender: AnyObject) {
        if isPlaying {
            return
        }
        
        startButton.hidden = true
        startButton.enabled = false
        resetButton.hidden = true
        resetButton.enabled = false
        stopButton.hidden = false
        stopButton.enabled = true
        lapButton.hidden = false
        lapButton.enabled = true
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        
        isPlaying = true
    }
    
    @IBAction func lapAction(sender: AnyObject) {
        lapArray.addObject(timeLabel.text!)
        myTableView.reloadData()
        
        if (myTableView.contentSize.height > myTableView.frame.size.height) {
            myTableView .setContentOffset(CGPointMake(0, myTableView.contentSize.height - myTableView.frame.size.height), animated: false)
        }
    }
    
    @IBAction func stopAction(sender: AnyObject) {
        if !isPlaying {
            return
        }
        
        startButton.hidden = false
        startButton.enabled = true
        resetButton.hidden = false
        resetButton.enabled = true
        stopButton.hidden = true
        stopButton.enabled = false
        lapButton.hidden = true
        lapButton.enabled = false
        
        timer.invalidate()
        isPlaying = false
    }
    
    func updateCounter() {
        counter = counter + 0.01
        self.updateTimer()
    }
    
    func updateTimer() {
        var timer = counter
        
        let minutes = UInt8(timer / 60.0)
        
        timer -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(timer)
        
        timer -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        
        let fraction = UInt8(timer * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        timeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCellWithIdentifier("lapCell", forIndexPath: indexPath)
        cell.textLabel?.text = lapArray.objectAtIndex(indexPath.row) as? String
    
        return cell
    }
}

