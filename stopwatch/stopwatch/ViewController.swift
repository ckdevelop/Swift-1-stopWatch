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
    var timer = Timer()
    var isPlaying = false
    var lapArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startButton.isHidden = false
        startButton.isEnabled = true
        resetButton.isHidden = false
        resetButton.isEnabled = true
        stopButton.isHidden = true
        stopButton.isEnabled = false
        lapButton.isHidden = true
        lapButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetAction(_ sender: AnyObject) {
        
        startButton.isHidden = false
        startButton.isEnabled = true
        resetButton.isHidden = false
        resetButton.isEnabled = true
        stopButton.isHidden = true
        stopButton.isEnabled = false
        lapButton.isHidden = true
        lapButton.isEnabled = false
        
        timer.invalidate()
        counter = 0
        timeLabel.text = "00:00:00"
        isPlaying = false
        
        lapArray.removeAllObjects()
        myTableView.reloadData()
    }

    @IBAction func startAction(_ sender: AnyObject) {
        if isPlaying {
            return
        }
        
        startButton.isHidden = true
        startButton.isEnabled = false
        resetButton.isHidden = true
        resetButton.isEnabled = false
        stopButton.isHidden = false
        stopButton.isEnabled = true
        lapButton.isHidden = false
        lapButton.isEnabled = true
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        
        isPlaying = true
    }
    
    @IBAction func lapAction(_ sender: AnyObject) {
        lapArray.add(timeLabel.text!)
        myTableView.reloadData()
        
        if (myTableView.contentSize.height > myTableView.frame.size.height) {
            myTableView .setContentOffset(CGPoint(x: 0, y: myTableView.contentSize.height - myTableView.frame.size.height), animated: false)
        }
    }
    
    @IBAction func stopAction(_ sender: AnyObject) {
        if !isPlaying {
            return
        }
        
        startButton.isHidden = false
        startButton.isEnabled = true
        resetButton.isHidden = false
        resetButton.isEnabled = true
        stopButton.isHidden = true
        stopButton.isEnabled = false
        lapButton.isHidden = true
        lapButton.isEnabled = false
        
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
        
        timer -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(timer)
        
        timer -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        
        let fraction = UInt8(timer * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        timeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "lapCell", for: indexPath)
        cell.textLabel?.text = lapArray.object(at: indexPath.row) as? String
    
        return cell
    }
}

