//
//  Extension+String.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation
import UIKit
extension String {
    func fetchImage() -> UIImage {
        return UIImage.init(named: self)!
    }
}
