//
//  MovieListViewController.swift
//  AssignmentSmartApp
//
//  Created by Ankit Chaudhary on 14/05/20.
//  Copyright © 2020 spectorAi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
class MovieListViewController: UIViewController, BindableType {
    
    var viewModel: MovieListViewModel!
    var disposeBag = DisposeBag.init()
    
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    
    // Toolbar Element
    var deleteButton: UIBarButtonItem!
    
    var editButton = UIBarButtonItem.init(image: UIImage.init(named: "delete"), style: .plain, target: nil, action: nil)
    var doneButton = UIBarButtonItem.init(title: "Done", style: .plain, target: nil, action: nil)
    
    // MARK:- Collection View Cell Configuration Method
    private lazy var dataSource = RxCollectionViewSectionedAnimatedDataSource<MovieListSectionModel>(configureCell: configureCell)
    private lazy var configureCell: RxCollectionViewSectionedAnimatedDataSource<MovieListSectionModel>.ConfigureCell = { (dataSource, collectionView, indexPath, item) in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as! MovieListCollectionViewCell
        cell.movieImage.setImage(for: NetworkConstants.imageBaseUrl + (item.identity.posterPath ?? ""))
        cell.movieImage.contentMode = .scaleAspectFit
        cell.movieTitle.text = item.identity.title ?? ""
        cell.movieDescription.text = item.identity.overview ?? ""
        cell.inEditingMode = self.isEditing
        return cell
    }
    
    // MARK:- ViewDidLoad 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationTitle(to: self.viewModel.movieListType.navigationTitle())
        
        self.registerNavigationActions()
        self.registerCollectionViewDelegatetActionAndNibs()
        
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    // MARK:- Override Editing Method
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.movieListCollectionView.allowsMultipleSelection = true
        let indexPaths = movieListCollectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = movieListCollectionView.cellForItem(at: indexPath) as! MovieListCollectionViewCell
            cell.inEditingMode = editing
        }
    }
    
    // Register components and subscribe to their observable sequence.
    // MARK:- Navigation button & Subscribtion Methods
    func registerNavigationActions() {
        // Combine multiple button into single observable.
        let navigationRightButtonObserver = Observable.of(editButton.rx.tap, doneButton.rx.tap).merge()
        
        // Subscribe to navigation right button click.
        navigationRightButtonObserver.bind { [weak self] (event) in
            guard let strongSelf = self else { return }
            if strongSelf.isEditing {
                strongSelf.setEditing(false, animated: true)
                strongSelf.navigationItem.rightBarButtonItem = strongSelf.editButton
                strongSelf.navigationController?.isToolbarHidden = true
            } else {
                strongSelf.setEditing(true, animated: true)
                strongSelf.navigationItem.rightBarButtonItem = strongSelf.doneButton
                strongSelf.createAndRegisterToolbarItemAndActions()
            }
        }.disposed(by: disposeBag)
    }
    
    // MARK:- Toolbar Items & Subscribtion Methods
    func createAndRegisterToolbarItemAndActions() {
        self.navigationController?.isToolbarHidden = false
        
        // Configure global delete button.
        deleteButton = UIBarButtonItem.init(image: UIImage.init(named: "delete"), style: .plain, target: nil, action: nil)
        
        deleteButton.rx.tap.bind { [weak self] (event) in
            guard let strongSelf = self else { return }
            if let selectedCells = strongSelf.movieListCollectionView.indexPathsForSelectedItems {
                let items = selectedCells.map { $0.item }.sorted().reversed()
                let itemSources = strongSelf.dataSource[0].items.enumerated().filter { !(items.contains($0.offset)) }.map{ $0.element }
                let model = strongSelf.dataSource[0].model
                let sectionModelList = [MovieListSectionModel.init(model: model, items: Array(itemSources))]
                strongSelf.viewModel.data.accept(sectionModelList)
                strongSelf.deleteButton.isEnabled = false
            }
        }.disposed(by: disposeBag)
        
        deleteButton.isEnabled = false
        
        // Toolbar items.
        let items: [UIBarButtonItem] = [UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), deleteButton]
        toolbarItems = items
    }
    
    // MARK:- Collection View Delegate Subscribtion Methods
    func registerCollectionViewDelegatetActionAndNibs() {
        self.movieListCollectionView.backgroundColor = UIColor.backgroundColor
        
        // Using composition layout for 100% width and automatic height dimension.
        movieListCollectionView.collectionViewLayout = self.structureLayout()
        
        // Register cell
        self.movieListCollectionView.register(UINib.init(nibName: MovieListCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        
        // didSelectItemAtIndexPath closure via RxDataSources.
        self.movieListCollectionView.rx.itemSelected.bind { [weak self] (indexPath) in
            guard let strongSelf = self else { return }
            if strongSelf.isEditing {
                strongSelf.deleteButton.isEnabled = true
            } else {
                let sceneCoordinator = (UIApplication.shared.delegate as! AppDelegate).sceneCoordinator
                let movieDetailsViewModel = MovieDetailsViewModel.init()
                movieDetailsViewModel.movieListData.accept(strongSelf.dataSource[indexPath.section].items[indexPath.row].identity)
                let movieDetailsScene = Scene.movieDetails(movieDetailsViewModel)
                sceneCoordinator?.transition(to: movieDetailsScene, type: .push)
            }
        }.disposed(by: disposeBag)
        
        self.movieListCollectionView.rx.itemDeselected.bind { [weak self] (indexPath) in
            guard let strongSelf = self else { return }
            if strongSelf.isEditing {
                if strongSelf.movieListCollectionView.indexPathsForSelectedItems?.count == 0 {
                    strongSelf.deleteButton.isEnabled = false
                }
            }
        }.disposed(by: disposeBag)
    }
    
    // MARK:- Collection View Data Source
    func bindViewModel() {
        viewModel.data
            .asDriver()
            .drive(movieListCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        self.viewModel.fetchMovieList()
    }
}


// MARK:- Collection View Composition Layout
extension MovieListViewController {
    private func structureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(97))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
