//
//  UpgradeViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/18/23.
//

import UIKit
import RevenueCat
import StoreKit
import SAConfettiView

class UpgradeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let isUpgraded = UserDefaults.standard.value(forKey: "IsUpgraded") as? Bool {
            GameSetupManager.shared.isUpgraded = isUpgraded
        }
        else {
            // Default to false if the key doesn't exist in UserDefaults
            GameSetupManager.shared.isUpgraded = false
        }
        
        
        // Check to see if this is a premium user
        UpgradeManager.shared.checkForPremiumUser()
        
       // Fetch available offerings when the view loads.
        UpgradeManager.shared.fetchOfferings()
        
    }
    
    // Check to see if this is a premium user before navigating to next view controller
    override func viewWillDisappear(_ animated: Bool) {
        
        if let isUpgraded = UserDefaults.standard.value(forKey: "IsUpgraded") as? Bool {
            GameSetupManager.shared.isUpgraded = isUpgraded
        }
        else {
            // Default to false if the key doesn't exist in UserDefaults
            GameSetupManager.shared.isUpgraded = false
        }
        
        // Check to see if this is a premium user
        UpgradeManager.shared.checkForPremiumUser()
        
    }
    
    
    
    @IBAction func weeklySubscriptionPressed(_ sender: UIButton) {
        UpgradeManager.shared.initiateSubscription(packageIdentifier: "$rc_weekly", viewController: self)

        print("Weekly tapped")
    }
    
    
    @IBAction func monthlySubscriptionPressed(_ sender: UIButton) {
        UpgradeManager.shared.initiateSubscription(packageIdentifier: "$rc_monthly", viewController: self)
        print("Monthly tapped")
    }
    
    
    
    @IBAction func restorePurchasesPressed(_ sender: UIButton) {
        UpgradeManager.shared.restorePurchases(viewController: self)
    }
    

    @IBAction func xButtonPressed(_ sender: UIButton) {
        // Play sound when button pushed
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
        performSegue(withIdentifier: "GoToGamePlayOneViewController", sender: nil)
        
    }
    
    
    @IBAction func termsOfServicePressed(_ sender: UIButton) {
        if let termsOfServiceURL = URL(string: "http://www.WhatZodiacSignIsThis.com/terms") {
            UIApplication.shared.open(termsOfServiceURL)
        }
    }
    
    @IBAction func privacyPolicyPressed(_ sender: UIButton) {
        if let privacyPolicyURL = URL(string: "http://www.WhatZodiacSignIsThis.com/privacy"){
            UIApplication.shared.open(privacyPolicyURL)
        }
    }
}



