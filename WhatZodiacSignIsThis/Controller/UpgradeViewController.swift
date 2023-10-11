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
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
        performSegue(withIdentifier: "GoToGamePlayOneViewController", sender: nil)
        
    }
    
    
    @IBAction func termsOfServicePressed(_ sender: UIButton) {
        if let termsOfServiceURL = URL(string: "http://www.WhatSignIsThis.com/terms") {
            UIApplication.shared.open(termsOfServiceURL)
        }
    }
    
    @IBAction func privacyPolicyPressed(_ sender: UIButton) {
        if let privacyPolicyURL = URL(string: "http://www.WhatSignIsThis.com/privacy"){
            UIApplication.shared.open(privacyPolicyURL)
        }
    }
}



