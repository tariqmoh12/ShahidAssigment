//
//  HomeVC.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 24/11/2023.
//

import UIKit

class HomeVc: BaseVc {
    
    var viewModel = HomeViewModel()
    
    lazy var favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Favorite List",
            style: .plain,
            target: self,
            action: #selector(favoriteListButtonTapped)
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.imagesData?.data.removeAll()
        fetchData()
    }
    
    private func setUpNavigationController() {
        navigationController?.navigationBar.barTintColor = .main
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = favoriteButton
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        self.title = Constants.homeName
    }
    
    override func fetchData() {
        
        LoadingViewManager.showLoader(in: self)
        
        viewModel.onImagesUpdate = {[weak self] images in
            guard let strongSelf = self else { return }
            strongSelf.imagesData = images
            strongSelf.offset = images?.pagination?.offset
            strongSelf.updateUI()
        }
        
        viewModel.onLoadingStateChanged = {[weak self] isLoading in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = isLoading
            DispatchQueue.main.async {
                if !isLoading {
                    LoadingViewManager.hideLoader(in: strongSelf)
                }
            }
        }
        
        viewModel.onError = { [weak self] error in
            guard let strongSelf = self else { return }
            AlertManager.showAlert(in: strongSelf, title: "Error!", message: "\(error.localizedDescription)")
        }
        
        viewModel.onSaveSuccess = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.updateUI()
            AlertManager.showAlert(in: strongSelf, title: "Success!", message: "Image has been saved to favorites")
        }
        
        viewModel.onSaveFailed = { [weak self] in
            guard let strongSelf = self else { return }
            AlertManager.showAlert(in: strongSelf, title: "Saving failed!", message: "Image saving has been failed")
        }
        
        viewModel.onDeleteSuccess = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.imagesData?.data.removeAll()
            strongSelf.fetchData()
            AlertManager.showAlert(in: strongSelf, title: "Success!", message: "Image has been removed from favorites")
        }
        
        viewModel.onDeleteFailed = { [weak self] in
            guard let strongSelf = self else { return }
            AlertManager.showAlert(in: strongSelf, title: "Removing failed!", message: "Removing from favorites has been failed")
        }
        
        viewModel.fetchData(offset: offset ?? 0)
    }
    
    
    @objc func favoriteListButtonTapped() {
        let newViewController = FavoriteListVc.loadFromNib()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}


extension HomeVc {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let obj = RealmManager.shared.getObjects(ImageModel.self)
        cell.favoriteButtonTapHandler = { [weak self] in
            guard let strongSelf = self else { return }
            if let model = obj.first(where:{$0.id == strongSelf.imagesData?.data[indexPath.item].id}), !model.isInvalidated {
                strongSelf.viewModel.handleFavoriteButtonTap(at: model)
            } else {
                if let imageData = strongSelf.imagesData?.data[indexPath.item], !imageData.isInvalidated {
                    strongSelf.viewModel.handleFavoriteButtonTap(at: imageData)
                }
            }
        }
        
        
        if let model = obj.first(where:{$0.id == self.imagesData?.data[indexPath.item].id}), !model.isInvalidated {
            cell.configure(with: model)
        } else {
            if let imageData = self.imagesData?.data[indexPath.item], !imageData.isInvalidated {
                cell.configure(with: imageData)
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItemIndex = collectionView.numberOfItems(inSection: 0) - 1
        if indexPath.item == lastItemIndex && imagesData?.pagination?.count != 0 {
            if isPagination {
                offset = (offset ?? 0) + 1
                fetchData()
            }
        }
    }
}

