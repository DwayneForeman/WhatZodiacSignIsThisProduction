//
//  LetsPlayViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/6/23.
//

import UIKit

class LetsPlayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GamePlayOneViewController.shared.playSound(soundName: "LetsPlaySound", shouldLoop: false)
        
    }
    
    @IBAction func letsPlayButtonPressed(_ sender: UIButton) {
        
        GamePlayOneViewController.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
    }
    
    
    
    
}
