//
//  RecorderViewController.swift
//  Music Practice Companion App
//
//  Created by Hayden Kua on 04/01/2021.
//

import UIKit
import AVFoundation

class RecorderViewController: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    var numberOfRecords:Int = 0
    @IBOutlet var recordButtonLabel: UIButton!
    @IBOutlet var recordingTableView: UITableView!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    var recordTimer = Timer()
    var timerDisplayed = 0
    var recordingTimesArray:[String] = []
    let userDefaults = UserDefaults.standard
    //declaring variables and constants
    
    @IBAction func record(_ sender: Any) {
        //Check if we have an active recorder
        if audioRecorder == nil {
            numberOfRecords += 1
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            //gets the path, and the specific recording, and saves it.
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            //setting the settings of the recording
            
            //Start audio recording
            do {
                try recordingSession.setCategory(AVAudioSession.Category.record)
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                //changing how the button looks
                recordButtonLabel.layer.bounds = CGRect(x: 30, y: 30, width: 30, height: 30)
                recordButtonLabel.layer.cornerRadius = 5
                //enabling the button
                pauseButton.isEnabled = true
                
                recordTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
                
            } catch {
                displayAlert(title: "Error!", message: "Recording failed.")
            }
        } else {
            //stopping audio recording
            do {
                try recordingSession.setCategory(AVAudioSession.Category.playback)
            } catch {
                displayAlert(title: "Error!", message: "Recording failed.")
            }
            audioRecorder.stop()
            audioRecorder = nil
            
            UserDefaults.standard.setValue(numberOfRecords, forKey: "numberOfRecordings")
            recordingTableView.reloadData()
            pauseButton.isEnabled = false
            //changing how the button looks
            recordButtonLabel.layer.bounds = CGRect(x: 50, y: 50, width: 50, height: 50)
            recordButtonLabel.layer.cornerRadius = recordButtonLabel.bounds.size.width/2
            //disabling the button
            recordTimer.invalidate()
            timerDisplayed = 0
            //saving how long each recording is
            if let eventTimes = userDefaults.stringArray(forKey: "recordingTimesArray") {
                //appends new timing and saves them to user defaults
                recordingTimesArray = eventTimes
                recordingTimesArray.append(timerLabel.text!)
                userDefaults.setValue(recordingTimesArray, forKey: "recordingTimesArray")
            } else {
                //appennds the new timing and creates the array in user defaults
                recordingTimesArray = []
                recordingTimesArray.append(timerLabel.text!)
                userDefaults.setValue(recordingTimesArray, forKey: "recordingTimesArray")
            }
            timerLabel.text = "00:00:00"
        }
    }
    
    @objc func updateLabel() {
        timerDisplayed += 1
        //formatting the timer label
        let hours = Int(timerDisplayed) / 3600
        let minutes = Int(timerDisplayed) / 60 % 60
        let seconds = Int(timerDisplayed) % 60
        timerLabel.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        if audioRecorder.isRecording == true {
            audioRecorder.pause()
            //stops the timer
            recordTimer.invalidate()
        } else if audioRecorder.isRecording == false {
            audioRecorder.record()
            //resumes the timer
            recordTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        pauseButton.isEnabled = false
        //Recording Button Format
        recordButtonLabel.layer.cornerRadius = recordButtonLabel.bounds.size.width/2
        
        //Setting up session
        recordingSession = AVAudioSession.sharedInstance()
        
        //retreiving the number of recordings
        if let number:Int = UserDefaults.standard.object(forKey: "numberOfRecordings") as? Int {
            numberOfRecords = number
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission{ (hasPermission) in
            if hasPermission {
                print ("ACCEPTED")
            }
        }
        
        //Setting up recording times
        if let eventTimes = userDefaults.stringArray(forKey: "recordingTimesArray") {
            recordingTimesArray = eventTimes
        }
    }

    //Function that gets path to directory
    func getDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //searching for all urls in document directory
        let documentDirectory = paths[0]
        //takes the first url as the path
        return documentDirectory
    }
    
    //Function that displays an alert
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //SETTING UP TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecords
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Recording \(indexPath.row + 1)  (\(recordingTimesArray[indexPath.row]))"
        return cell
        //sets the default cell name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        } catch {
        }
        //gets and plays the recording
    }
    
}
