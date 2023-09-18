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
        GamePlayOneViewController.shared.player.stop()
    }

    

    
    @IBAction func levelOneButtonPressed(_ sender: UIButton) {
        
        // Set the segue identfiier in storyboard to GoToGamePlayOneViewController, also, set the segue "kind" to push and non animate
        performSegue(withIdentifier: "GoToGamePlayOneViewController", sender: nil)
        
    }
    
    
    @IBAction func levelTwoButtonPressed(_ sender: UIButton) {
        
        // Set the segue identfiier in storyboard to GoToGamePlayTwoViewController, also, set the segue "kind" to push and non animate
        performSegue(withIdentifier: "GoToGamePlayTwoViewController", sender: nil)
        
    }
    
    @IBAction func levelThreeButtonPressed(_ sender: Any) {
        
        // Set the segue identfiier in storyboard to GoToGamePlayThreeViewController, also, set the segue "kind" to push and non animate
        performSegue(withIdentifier: "GoToGamePlayThreeViewController", sender: nil)
        
    }
    

}
