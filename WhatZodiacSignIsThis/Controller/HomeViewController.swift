//
//  HomeViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/16/23.
//

import UIKit

class HomeViewController: UIViewController {


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AudioManager.shared.player.stop()
    }

    

    
    @IBAction func levelOneButtonPressed(_ sender: UIButton) {
        
        // Play sound when button pushed
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
        // Set the segue identfiier in storyboard to GoToGamePlayOneViewController, also, set the segue "kind" to push and non animate
        performSegue(withIdentifier: "GoToGamePlayOneViewController", sender: nil)
        
    }
    
    
    @IBAction func levelTwoButtonPressed(_ sender: UIButton) {
        
        // Play sound when button pushed
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
        // Set the segue identfiier in storyboard to GoToGamePlayTwoViewController, also, set the segue "kind" to push and non animate
        performSegue(withIdentifier: "GoToGamePlayTwoViewController", sender: nil)
        
    }
    
    @IBAction func levelThreeButtonPressed(_ sender: Any) {
        
        // Play sound when button pushed
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
        // Set the segue identfiier in storyboard to GoToGamePlayThreeViewController, also, set the segue "kind" to push and non animate
        performSegue(withIdentifier: "GoToGamePlayThreeViewController", sender: nil)
        
    }
    

}
