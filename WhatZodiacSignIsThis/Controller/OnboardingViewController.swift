//
//  OnboardingViewController.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/2/23.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnBoardingSlide] = []
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = [OnBoardingSlide(image: UIImage(named: "OnboardingImage1") ?? UIImage()), OnBoardingSlide(image: UIImage(named: "OnboardingImage2") ?? UIImage()), OnBoardingSlide(image: UIImage(named: "OnboardingImage3") ?? UIImage())]

        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view
    }
    
    

    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        // Play sound when button pushed
        GamePlayOneViewController.shared.playSound(soundName: "ButtonSound", shouldLoop: false)
        
        
                     
        // If current page equals ast page
        if currentPage == slides.count-1 {
            // continue to next page
            // Navigate to GamePlayOneViewControlle
            if let gamePlayOneVC = storyboard?.instantiateViewController(withIdentifier: "GamePlayOneViewController") as? GamePlayOneViewController {
                    navigationController?.show(gamePlayOneVC, sender: nil)
                }
            
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = currentPage
            
            
        }
        
        
        
    }
    
}


// Like table views with collectionviews we have to confirm to the delegate and teh datasource
// Make sure to set the delate to self to be triggered
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardingCollectionViewCell", for: indexPath) as! OnBoardingCollectionViewCell
        
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        
        pageControl.currentPage = currentPage
    }
    
    
}
