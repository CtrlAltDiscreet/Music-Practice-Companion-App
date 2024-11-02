//
//  MetronomeViewController.swift
//  Music Practice Companion App
//
//  Created by Hayden Kua on 11/10/2020.
//

import UIKit
import AVFoundation

class MetronomeViewController: UIViewController {
    
    @IBOutlet var tempoLabel: UILabel!
    @IBOutlet var slider: UISlider!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var beatButton: UIButton!
    @IBOutlet var keepTappingLabel: UILabel!
    @IBOutlet var visualIndicator: UIButton!
    
    var startTimeOne: Date?
    var startTimeTwo: Date?
    
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    var timerTwo: Timer?
    var rate: Float = 1.0 {
        didSet {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(1/rate), target: self, selector: #selector(beat), userInfo: nil, repeats: true) //this is a timer that I used to create the beats of the metronome.
            let tempoMarking = Int(metronome.getTempo(rawValue: rate))
            tempoLabel.text = "\(tempoMarking)"
            //this gives the tempomarking
        }
    }
    let metronome = Metronome()

    override func viewDidLoad() {
        super.viewDidLoad()
        slider.maximumValue = 2.5
        slider.minimumValue = 0.5
        tempoLabel.text = "30"
        self.keepTappingLabel.isHidden = true
        visualIndicator.tintColor = UIColor.white
    }
    
    
    @IBAction func sliderChanged(_ sender: Any) {
        rate = 1
        rate = rate * slider.value
    }
    
    @objc func beat() {
        let pathToSound = Bundle.main.path(forResource: "click", ofType: "mp3")
        let url = URL(fileURLWithPath: pathToSound!)
        // this gets the "beat" sound
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            fatalError("Could not use audiofile")
        }
        //visual indicator
        if visualIndicator.tintColor == UIColor.white {
            visualIndicator.tintColor = UIColor.black
            timerTwo = Timer.scheduledTimer(timeInterval: TimeInterval(0.05), target: self, selector: #selector(changeColour), userInfo: nil, repeats: true)
            
        } else {
            visualIndicator.tintColor = UIColor.white
        }
    }
    
    @objc func changeColour() {
        visualIndicator.tintColor = UIColor.white
        timerTwo?.invalidate()
    }
    
    //Setting up the play/pause button
    @IBAction func playPauseButtonToggled(_ sender: Any) {
        if timer?.isValid == true {
            timer?.invalidate()
            differences = []
            arrayOfDates = []
            count = 0
            sum = Float(0)
        } else {
            rate = 1
            rate = rate * slider.value
        }
    }
    
    var count = 0
    var arrayOfDates: [Date] = []
    var differences: [Float] = []
    var sum = Float(0)
    //initialising the variables needed later

    @IBAction func beatButtonTapped(_ sender: Any) {
        beat()
        timer?.invalidate()
        if count == 0 {
            self.keepTappingLabel.isHidden = false
            arrayOfDates.append(Date())
            count += 1
            //appends the date of the inital click the first time the button is pressed
        } else if count <= 2 {
            let difference = Float(Date().timeIntervalSince(arrayOfDates[count-1]))
            //finds the difference between the current date and the tap
            differences.append(difference)
            arrayOfDates.append(Date())
            //appends to the differences and array arrays.
            count += 1
        } else {
            for item in differences {
                sum += item
                //finds the sum of the elements in the array
            }
            let average = sum/Float(differences.count)
            //finds average of time differences
            rate = 1/average
            print(differences, average)
            differences = []
            arrayOfDates = []
            count = 0
            sum = Float(0)
            self.keepTappingLabel.isHidden = true
            //hides the label
        }
    }
    
}

