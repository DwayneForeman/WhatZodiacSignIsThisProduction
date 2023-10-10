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
        AudioManager.shared.playSound(soundName: "LetsPlaySound", shouldLoop: false)
        
    }
    
    @IBAction func letsPlayButtonPressed(_ sender: UIButton) {
        
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
    }
    
    
    @IBAction func termsLinkPressed(_ sender: UIButton) {
        
        if let termsURL = URL(string: "http://www.WhatZodiacSignIsThis.com/terms") {
            UIApplication.shared.open(termsURL)
        }
    }
    
    
    @IBAction func privacyLinkPressed(_ sender: UIButton) {
        
        if let privacyURL = URL(string: "http://www.WhatZodiacSignIsThis.com/privacy") {
            UIApplication.shared.open(privacyURL)
        }
        
    }
    
}
