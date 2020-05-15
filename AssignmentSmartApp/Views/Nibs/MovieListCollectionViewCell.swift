//
//  MovieListCollectionViewCell.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkmarkButton: UIButton!
    var inEditingMode: Bool = false {
        didSet {
            updateCheckmarkState(show: inEditingMode)
        }
    }

    override var isSelected: Bool {
        didSet {
            if inEditingMode {
                checkmarkButton.setImage(((isSelected == true) ? UIImage.init(named: "checkboxSelected") : UIImage.init(named: "checkboxUnselected")) , for: .normal)
            }
        }
    }
    
    @IBOutlet weak var imageLeadingAnchor: NSLayoutConstraint!
    
    
    func updateCheckmarkState(show: Bool) {
        if show == true {
            self.checkmarkButton.isHidden = false
            if imageLeadingAnchor.constant == 53 { return }
            UIView.animate(withDuration: 0.5) {
                self.imageLeadingAnchor.constant += 45
                self.containerView.layoutIfNeeded()
            }
        } else {
            self.checkmarkButton.isHidden = true
            if imageLeadingAnchor.constant == 8 { return }
            UIView.animate(withDuration: 0.5) {
                self.imageLeadingAnchor.constant -= 45
                self.containerView.layoutIfNeeded()
            }
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

