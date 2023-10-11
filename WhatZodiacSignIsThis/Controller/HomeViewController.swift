//
//  HomeViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/16/23.
//

import UIKit

class HomeViewController: UIViewController {

    static let shared = HomeViewController()
    
    @IBOutlet weak var soundButton: UIButton!
    var soundIsEnabled = true

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        AudioManager.shared.player?.stop()

        
        // Grab the value from userdefaulst storrage when view loads
        // We need to unwrap since there will be a chance this can be nil is user never switched the dound settings which will cause app to crash
        if let soundSettingFromUserDefaults = UserDefaults.standard.value(forKey: "SoundEnabled") {
            
            // set the value eequal to our glocal var soundIsEnabled
            soundIsEnabled = soundSettingFromUserDefaults as! Bool
            
        }
            
        // Now checking with soundEnbaled being false per above line so we can set the button image according upon loa dup
            if soundIsEnabled == false {
                soundButton.setImage(UIImage(named: "SpeakerButtonSlash.pdf"), for: .normal)
            } else {
                soundButton.setImage(UIImage(named: "SpeakerButton.pdf"), for: .normal)
            }
        
    }

    
    @IBAction func anyButtonPressed(_ sender: UIButton) {
            AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
    }
    
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        
        soundIsEnabled = !soundIsEnabled
        
        // Save the audio seettings to user defaults
        UserDefaults.standard.set(soundIsEnabled, forKey: "SoundEnabled")
        
        // Now checking with soundEnbaled being false per above line
            if soundIsEnabled == false {
                soundButton.setImage(UIImage(named: "SpeakerButtonSlash.pdf"), for: .normal)
            } else {
                soundButton.setImage(UIImage(named: "SpeakerButton.pdf"), for: .normal)
            }
    }
}
