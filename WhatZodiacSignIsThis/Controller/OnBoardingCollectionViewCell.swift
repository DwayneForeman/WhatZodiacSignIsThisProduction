//
//  OnBoardingCollectionViewCell.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 9/3/23.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var slideImageView: UIImageView!
    
    func setup(_ slide: OnBoardingSlide) {
        slideImageView.image = slide.image
    }
    
}
