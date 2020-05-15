//
//  MovieDetailsViewModel.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class MovieDetailsViewModel: ViewModelType {
    var movieListData = BehaviorRelay<MovieBrief?>.init(value: nil)
}
