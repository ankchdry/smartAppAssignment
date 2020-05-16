//
//  ScrollableContentView.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import UIKit

class ScrollableContentView: UIView {
    
    var scrollView: UIScrollView!
    var contentView: ContentView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpLayout()
    }
    
    func setDataSource(for movie: MovieBrief) {
        contentView.titleLabel.text = movie.title ?? ""
        contentView.dateLabel.text = movie.releaseDate ?? ""
        contentView.ratingLabel.text = movie.popularity?.description ?? ""
        contentView.durationLabel.text = "2 hr 57 min"
        contentView.overviewLabel.text = movie.overview ?? ""
    }
    
    func setUpLayout() {
        scrollView = UIScrollView.init()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        let leadingAnchor = scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        let trailingAnchor = scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        let bottomAnchor = scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        let heightAnchor = scrollView.heightAnchor.constraint(equalToConstant: CGFloat(UIScreen.main.bounds.height * 0.8))
        
        NSLayoutConstraint.activate([leadingAnchor, trailingAnchor, bottomAnchor, heightAnchor])
        
        contentView = ContentView.init()
        contentView.backgroundColor = UIColor.backgroundColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: UIScreen.main.bounds.height * 0.7),
        ])
    }
}

class ContentView: UIView {
    // Components
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    var ratingLabel: UILabel!
    var durationLabel: UILabel!
    var overviewLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Impelemented via frame.
        self.backgroundColor = UIColor.backgroundColor
        self.layoutComponents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layoutComponents()
    }
    
    func layoutComponents() {
        titleLabel = UILabel.init()
        titleLabel.font = Font.bold(size: 14.0, font: .SharpSans).fetch()
        titleLabel.textColor = UIColor.textColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        ])
        
        dateLabel = UILabel.init()
        dateLabel.font = Font.medium(size: 14.0, font: .SharpSans).fetch()
        dateLabel.textColor = UIColor.textColor
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ])
        
        ratingLabel = UILabel.init()
        ratingLabel.font = Font.medium(size: 14.0, font: .SharpSans).fetch()
        ratingLabel.textColor = UIColor.textColor
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            ratingLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            ratingLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            ratingLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.3))
        ])
        
        durationLabel = UILabel.init()
        durationLabel.font = Font.medium(size: 14.0, font: .SharpSans).fetch()
        durationLabel.textColor = UIColor.textColor
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(durationLabel)
        NSLayoutConstraint.activate([
            durationLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 12),
            durationLabel.topAnchor.constraint(equalTo: ratingLabel.topAnchor, constant: 0),
            durationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        ])
        
        overviewLabel = UILabel.init()
        overviewLabel.font = Font.medium(size: 14.0, font: .SharpSans).fetch()
        overviewLabel.numberOfLines = 0
        overviewLabel.textColor = UIColor.textColor
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(overviewLabel)
        
        NSLayoutConstraint.activate([
            overviewLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: 0),
            overviewLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 12),
            overviewLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 0),
            overviewLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
}
