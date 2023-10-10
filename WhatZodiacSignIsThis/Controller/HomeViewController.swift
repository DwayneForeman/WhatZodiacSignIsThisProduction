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

    
    @IBAction func anyButtonPressed(_ sender: UIButton) {
            AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
    }

}
