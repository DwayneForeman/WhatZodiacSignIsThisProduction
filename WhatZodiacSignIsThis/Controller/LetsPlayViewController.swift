//
//  LetsPlayViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/6/23.
//

import UIKit
import RevenueCat

class LetsPlayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AudioManager.shared.playSound(soundName: "LetsPlaySound", shouldLoop: false)
        
    }
    
    
  
    
    
    @IBAction func letsPlayButtonPressed(_ sender: UIButton) {
        
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
        // Check if the user has already upgraded.
        
                Purchases.shared.getCustomerInfo { [weak self] info, error in
                    if let error = error {
                        print("Error fetching customer info: \(error.localizedDescription)")
                    } else if let info = info {
                        if info.entitlements.all["premium"]?.isActive == true {
                            print("User has premium entitlement. Dismissing.")
                            
                            DispatchQueue.main.async {
                                self?.performSegue(withIdentifier: "GoToMainScreen", sender: nil)
                            }
                            
                        } else {
                            print("User does not have premium entitlement.")
                            self?.performSegue(withIdentifier: "GoToOnboarding", sender: nil)
                        }
                    }
                }
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
