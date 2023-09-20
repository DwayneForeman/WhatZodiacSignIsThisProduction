//
//  UpgradeViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/18/23.
//

import UIKit

class UpgradeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func xButtonPressed(_ sender: UIButton) {
        // Play sound when button pushed
        GamePlayOneViewController.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
        performSegue(withIdentifier: "GoToGamePlayOneViewController", sender: nil)
        
    }
    

}
