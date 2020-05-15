//
//  Extension+UIImage.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation
import AlamofireImage
extension UIImageView {
    func setImage(for url: String) {
        guard let url = URL.init(string: url) else { return }
        var urlRequest = URLRequest.init(url: url)
        urlRequest.url = URL.init(string: (urlRequest.url?.absoluteString ?? "") + "?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        self.af_setImage(withURLRequest: urlRequest)
    }
}
