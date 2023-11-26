//
//  FavoriteListVc.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 25/11/2023.
//

import UIKit
import RealmSwift
class FavoriteListVc: BaseVc {
    
    var viewModel = FavoriteListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationController()
        
        viewModel.onDataFetch = { [weak self] imagesData in
            guard let strongSelf = self else { return }
            strongSelf.imagesData = imagesData
            strongSelf.updateUI()
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
            strongSelf.fetchData()
            AlertManager.showAlert(in: strongSelf, title: "Success!", message: "Image has been removed from favorites")
        }
        
        viewModel.onDeleteFailed = { [weak self] in
            guard let strongSelf = self else { return }
            AlertManager.showAlert(in: strongSelf, title: "Removing failed!", message: "Removing from favorites has been failed")
        }
        
        fetchData()
    }
    
    private func setUpNavigationController() {
        self.title = Constants.FavList
    }
    
    override func fetchData() {
        viewModel.fetchData()
    }
}

extension FavoriteListVc {
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
                if let imageData = strongSelf.imagesData?.data[indexPath.item], !imageData.isInvalidated  {
                    strongSelf.viewModel.handleFavoriteButtonTap(at: imageData)
                }
            }
        }
        
        if let model = obj.first(where:{$0.id == self.imagesData?.data[indexPath.item].id}), !model.isInvalidated {
            cell.configure(with: model)
        } else {
            if let imageData = self.imagesData?.data[indexPath.item],
               !imageData.isInvalidated {
                cell.configure(with: imageData)
            }
        }
        return cell
    }
}
