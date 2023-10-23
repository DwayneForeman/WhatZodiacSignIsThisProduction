//
//  GameOverViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 10/16/23.
//

import UIKit
import RevenueCat
import StoreKit
import SAConfettiView

class GameOverViewController: UIViewController {

    static let shared = GameOverViewController()
    
    var packagesAvailableForPurchase = [Package]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let isUpgraded = UserDefaults.standard.value(forKey: "IsUpgraded") as? Bool {
            GameSetupManager.shared.isUpgraded = isUpgraded
        }
                else {
                // Default to false if the key doesn't exist in UserDefaults
            GameSetupManager.shared.isUpgraded = false
        }
        
        print("View did load")
        
        // Check to see if this is a premium user
       checkForPremiumUser()
        
       // Fetch available offerings when the view loads.
       fetchOfferings()
    }
    

    
    
    
    
    
    func checkForPremiumUser(viewController: UIViewController? = nil){
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if let error = error {
                print("Error fetching customer info: \(error.localizedDescription)")
            } else if let customerInfo = customerInfo {
                if customerInfo.entitlements.all["premium"]?.isActive == true {
                    print("User has premium entitlement. Dismissing.")
                    
                    GameSetupManager.shared.isUpgraded = true
                    UserDefaults.standard.set(true, forKey: "isUpgraded")
                    
                    if let vc = viewController {
                        vc.dismiss(animated: true)
                    }
                } else {
                    print("User does not have premium entitlement.")
                }
            }
        }
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        checkForPremiumUser()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        checkForPremiumUser()
        
    }
    
    
    @IBAction func weeklySubscriptionPressed(_ sender: UIButton) {
        initiateSubscription(packageIdentifier: "$rc_weekly")

        print("Weekly tapped")
    }
    
    
    @IBAction func monthlySubscriptionPressed(_ sender: UIButton) {
        initiateSubscription(packageIdentifier: "$rc_monthly")
        print("Monthly tapped")
    }
    
    
    func fetchOfferings() {
        Purchases.shared.getOfferings { [weak self] (offerings, error) in
            if let currentOffering = offerings?.current {
                let packages = currentOffering.availablePackages

                // Clear the existing packagesAvailableForPurchase array
                self?.packagesAvailableForPurchase = packages

                for package in packages {
                    print("Available package: \(self?.convertPackageToString(package) ?? "N/A")")
                }
            }
        }
    }

    func convertPackageToString(_ package: Package) -> String {
        return "Package: \(package.storeProduct.localizedTitle) (Identifier: \(package.identifier))"
    }

    private func initiateSubscription(packageIdentifier: String) {
        if let package = packagesAvailableForPurchase.first(where: { $0.identifier == packageIdentifier }) {
            Purchases.shared.purchase(package: package) { (transaction, purchaserInfo, error, userCancelled) in
                if userCancelled {
                    print("User cancelled the purchase")
                } else if let error = error {
                    print("Purchase error: \(error.localizedDescription)")
                } else {
                    print("Purchase successful")
                    
                    GameSetupManager.shared.isUpgraded = true
                    UserDefaults.standard.set(true, forKey: "isUpgraded")
                    
                    if let premiumEntitlement = purchaserInfo?.entitlements["premium"], premiumEntitlement.isActive {
                        // User purchased successfully and has access to premium content

                        let confettiView = SAConfettiView(frame: self.view.bounds)
                        self.view.addSubview(confettiView)

                        // Start the confetti animation
                        confettiView.startConfetti()

                        // Calculate the duration of the confetti animation
                        let confettiDuration: TimeInterval = 4.5

                        // Schedule dismissal after the confetti animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + confettiDuration) {
                            // Stop confetti
                            confettiView.stopConfetti()
                            // Hide confetti
                            confettiView.isHidden = true
                            // Bring the main view to the front
                            self.view.bringSubviewToFront(self.view)

                            // Dismiss the view controller
                            self.dismiss(animated: true)
                        }
                    }
                }
            }
        } else {
            print("Package not found for identifier: \(packageIdentifier)")
        }
    }
    
    
    
     func restorePurchases() {
         Purchases.shared.restorePurchases { (purchaserInfo, error) in
             if let purchaserInfo = purchaserInfo {
                 print("Purchases restored: \(purchaserInfo)")
             } else if let error = error {
                 print("Restore error: \(error.localizedDescription)")
             }
         }
     }
    
    
    
    @IBAction func restorePurchasesPressed(_ sender: UIButton) {
        restorePurchases()
    }
    

    @IBAction func xButtonPressed(_ sender: UIButton) {
        // Play sound when button pushed
        AudioManager.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
        self.dismiss(animated: true)
        
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
