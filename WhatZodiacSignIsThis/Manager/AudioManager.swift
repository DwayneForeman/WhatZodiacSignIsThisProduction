//
//  AudioManager.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/24/23.
//

import UIKit
import AVFoundation


class AudioManager: UIViewController {
    
  
    
    // Making Audio manager a Singleton which can be shared throughout appp
    static let shared = AudioManager()
    
    
    // Creating var of AVAudioPlayer type so we can use its features
    // AVAudioPlay is a data type from the AVFoundation
    var player: AVAudioPlayer!
    
   
    
        
        // Creating a function with code needed to play the file
        func playSound(soundName: String, shouldLoop: Bool) {
            
            // create local variable as we are going to use this to tansfer the value we get after we capture it when unwrapping it with if let soundSettingFromUserDefault
            var isSoundEnablabed = true
            
            // Capturing the UserDfeaults value. Need to be unwrapped because there is a possiblity there many be NO settings saved by the user
            if let soundSettingFromUserDefaults = UserDefaults.standard.value(forKey: "SoundEnabled") {
                
                // updatting our local variable to equal whatever the value of our user default sound settings currently is
                isSoundEnablabed = soundSettingFromUserDefaults as! Bool
                print("Sound enabled is \(isSoundEnablabed)")
                
            }
            
            
            if isSoundEnablabed == true {
            
              
                
            DispatchQueue.main.async {
                // Stop prervious sound
                self.player?.stop()
                
                // Setting are URL to equal the location of where our sound file is held
                let url = Bundle.main.url(forResource: soundName, withExtension: "mp3")
                print(url!)
                
                // Then we put the url file into our player
                self.player = try! AVAudioPlayer(contentsOf: url!)
                // Then we play the sound
                self.player.play()
                
                // Then we loop it
                if shouldLoop {
                    self.player.numberOfLoops = -1
                }
            }
        }
    }
}
