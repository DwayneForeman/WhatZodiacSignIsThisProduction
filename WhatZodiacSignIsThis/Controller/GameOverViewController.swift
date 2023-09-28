//
//  GameOverViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/22/23.
//

import UIKit

class GameOverViewController: UIViewController {
    
    var scoreLabelInt = GamePlayOneViewController.shared.scoreLabelInt

    override func viewDidLoad() {
        super.viewDidLoad()

        AudioManager.shared.playSound(soundName: "GameOverSound", shouldLoop: false)
        
     
        
        
    }
    

     
//     override func viewWillDisappear(_ animated: Bool) {
//         super.viewWillDisappear(animated)
//         // Stop the sound when the view is about to disappear
//         AudioManager.shared.player.stop()
//     }
     
    

    
}
