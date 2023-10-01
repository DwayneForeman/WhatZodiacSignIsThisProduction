//
//  GameOverViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/22/23.
//

import UIKit

class GameOverViewController: UIViewController {
    
    //var scoreLabelInt = GamePlayOneViewController.shared.scoreLabelInt

    override func viewDidLoad() {
        super.viewDidLoad()

        AudioManager.shared.playSound(soundName: "GameOverSound", shouldLoop: false)
        
    }
    

    
}
