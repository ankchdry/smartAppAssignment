//
//  NetworkConstants.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation
import UIKit
struct NetworkConstants {
    
    // Production
    static let baseUrl = "https://api.themoviedb.org/3"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w185_and_h278_bestv2/"
    static let bigPosterBaseUrl = "https://image.tmdb.org/t/p/w370_and_h556_bestv2/"
    //The header fields
    enum HttpHeaderField: String {
        case contentType = "Content-Type"
    }
    
    //The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
}
