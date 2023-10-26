//
//  MenuViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 10/1/23.
//

import UIKit
import RevenueCat

class MenuViewController: UIViewController {
    
    
    @IBOutlet var menuButtons: [UIButton]!
    
    @IBOutlet weak var homeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpgradeManager.shared.checkForPremiumUser()
        homeButton.tintColor = .black
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        homeButton.tintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeButton.tintColor = .black
    }
    
    
    @IBAction func transparentButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        
        print("Button pressed with tag: \(sender.tag)") // Add this line
        
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
        // Check the current tint color of the pressed button
        if sender.tintColor == .white {
            sender.tintColor = .black
            
            // Loop through all buttons to find and reset other buttons to white
            for button in menuButtons {
                if button != sender {
                    button.tintColor = .white
                }
            }
        }
        
      
            if sender.tag == 1 {
                print("HomeButtonTapped")
                
                
            } else if sender.tag == 2 {
                // Grab a hold of this current app
                if let bundleIdentifier = Bundle.main.bundleIdentifier,
                // This is the detination
              let settingsURL = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                    // Here's us opening the destination
                    UIApplication.shared.open(settingsURL)
                }
            }
            
            
            else if sender.tag == 4 {
                // Create URL
                if let rateUsURL = URL(string: "App Link goes here") {
                    // Open URL
                    UIApplication.shared.open(rateUsURL)
                }
            }
            
            else if sender.tag == 5 {
                // Share the app
                        let text = "LMFAO! This app is JOKES!!"
                if let appURL = URL(string: "https://www.yourappstorelink.com") {
                    let activityViewController = UIActivityViewController(activityItems: [text, appURL], applicationActivities: nil)
                    present(activityViewController, animated: true, completion: nil)
                }
            }
            
            else if sender.tag == 6 {
                // Restore Purchases
                UpgradeManager.shared.restorePurchases(viewController: self)
                
            }
            
            else if sender.tag == 7 {
                // Go to terms webpage
                if let termsURL = URL(string: "https://www.WhatZodiacSignIsThis.com/terms") {
                    // Open URL
                    UIApplication.shared.open(termsURL)
                    print(sender.tintColor!)
                }
            }
            
            else {
                
                if sender.tag == 8 {
                    if let contactUsURL = URL(string: "https://www.WhatZodiacSignIsThis.com/contact") {
                        UIApplication.shared.open(contactUsURL)
                        print(sender.tintColor!)
                    }
                }
            }
        }
}
