//
//  MovieDetailsViewController.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailsViewController: UIViewController, BindableType {
    
    var viewModel: MovieDetailsViewModel!
    var disposeBag = DisposeBag.init()
    @IBOutlet weak var wideImagePoster: UIImageView!
    var scrollabelContentView: ScrollableContentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func createScrollableView() {
        scrollabelContentView = ScrollableContentView.init()
        scrollabelContentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollabelContentView)
        
        NSLayoutConstraint.activate([
            scrollabelContentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            scrollabelContentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            scrollabelContentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            scrollabelContentView.heightAnchor.constraint(equalToConstant: 300.0)
        ])
    }
    
    func bindViewModel() {
        viewModel.movieListData.bind { [weak self] (movieBrief) in
            guard let strongSelf = self, let `movieBrief` = movieBrief else  { return }
            strongSelf.wideImagePoster.setImage(for: NetworkConstants.bigPosterBaseUrl + (movieBrief.posterPath ?? ""))
            strongSelf.wideImagePoster.contentMode = .scaleAspectFill
            strongSelf.createScrollableView()
            strongSelf.scrollabelContentView.setDataSource(for: movieBrief)
        }.disposed(by: disposeBag)
    }
}
