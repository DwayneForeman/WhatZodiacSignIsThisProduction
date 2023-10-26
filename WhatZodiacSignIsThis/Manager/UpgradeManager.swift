//
//  UpgradeManager.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 10/23/23.
//

import UIKit
import RevenueCat
import StoreKit
import SAConfettiView




class UpgradeManager: UIViewController {

    static let shared = UpgradeManager()
    
    var packagesAvailableForPurchase = [Package]()
    
    
    
    //MARK: - Check if user is Upgraded
    
    
    func checkForPremiumUser(){
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if let error = error {
                print("Error fetching customer info: \(error.localizedDescription)")
            } else if let customerInfo = customerInfo {
                if customerInfo.entitlements.all["premium"]?.isActive == true {
                    print("User has premium entitlement. Dismissing.")
                    
                    GameSetupManager.shared.isUpgraded = true
                    UserDefaults.standard.set(true, forKey: "isUpgraded")
                    
                } else {
                    print("User does not have premium entitlement.")
                }
            }
        }
    }
    
    
    
    
    //MARK: - Fetch Offerings
    
    
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
    
    
    
    
    
    
    
    
    //MARK: - Make Purchase
    
    func initiateSubscription(packageIdentifier: String, viewController: UIViewController) {
            if let package = packagesAvailableForPurchase.first(where: { $0.identifier == packageIdentifier }) {
                Purchases.shared.purchase(package: package) { (transaction, purchaserInfo, error, userCancelled) in
                    if userCancelled {
                        print("User cancelled the purchase")
                    } else if let error = error {
                        print("Purchase error: \(error.localizedDescription)")
                    } else {
                        print("Purchase successful")
                        if let premiumEntitlement = purchaserInfo?.entitlements["premium"], premiumEntitlement.isActive {
                            // User purchased successfully and has access to premium content
                            
                            GameSetupManager.shared.isUpgraded = true
                            UserDefaults.standard.set(true, forKey: "isUpgraded")
                            
                            let confettiView = SAConfettiView(frame: viewController.view.bounds)
                            viewController.view.addSubview(confettiView)

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
                                viewController.view.bringSubviewToFront(self.view)

                                // Dismiss the view controller
                                if viewController is UpgradeViewController {
                                    viewController.performSegue(withIdentifier: "GoToGamePlayOneViewController", sender: nil)
                                } else {
                                    viewController.dismiss(animated: true)
                                }
                            }
                        }
                    }
                }
            } else {
                print("Package not found for identifier: \(packageIdentifier)")
            }
        }
    
    
    
    
    func convertPackageToString(_ package: Package) -> String {
        return "Package: \(package.storeProduct.localizedTitle) (Identifier: \(package.identifier))"
    }
    
    
    
    
    //MARK: - Restore Purchases
    
    func restorePurchases(viewController: UIViewController) {
        Purchases.shared.restorePurchases { purchaserInfo, error in
            
            self.checkForPremiumUser()
            
            guard let purchaserInfo = purchaserInfo, error == nil else { return }
            
            if purchaserInfo.entitlements.all["premium"]?.isActive == true {
                DispatchQueue.main.async {
                    
                    print("Upgrade Manager: Purchases successfully restored.")
                    print("Upgrade Manager: Purchaser info: \(purchaserInfo)")
                    
                    let successfullyRestored = UIAlertController(title: "Success", message: "Your purchase has been successfully restored. Get your game on!", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "Okay", style: .default){ _ in
                        viewController.dismiss(animated: true)
                    }
                    successfullyRestored.addAction(okay)
                    viewController.present(successfullyRestored, animated: true)
                }
            }
            
            else {
                print("According to the Upgrade Manager: User does not have premium entitlement.")
                DispatchQueue.main.async {
                    let purchaseNotFound = UIAlertController(title: "Subscription Not Found", message: "You currenlty have no active subscriptions. Please upgrade to premium.", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "Okay", style: .default) { _ in
                        viewController.dismiss(animated: true)
                    }
                    purchaseNotFound.addAction(okay)
                    viewController.present(purchaseNotFound, animated: true)
                    
                
                }
            }
        }
    }
}
