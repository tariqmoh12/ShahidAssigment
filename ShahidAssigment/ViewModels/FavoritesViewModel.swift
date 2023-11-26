//
//  FavoritesViewModel.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 24/11/2023.
//

import Foundation
import RealmSwift

class FavoriteListViewModel {
    
    var imagesData: ImagesModel?
    var onDataFetch: ((ImagesModel?) -> Void)?
    var onSaveSuccess: (() -> Void)?
    var onSaveFailed: (() -> Void)?
    var onDeleteSuccess: (() -> Void)?
    var onDeleteFailed: (() -> Void)?
    
    func fetchData() {
        let results: Results<ImageModel>? = RealmManager.shared.getObjects(ImageModel.self)
        imagesData = ImagesModel()
        if let results = results {
            imagesData?.data.append(objectsIn: results)
            onDataFetch?(imagesData)
        }
    }
    
    func handleFavoriteButtonTap(at model: ImageModel) {
        
        let obj = RealmManager.shared.getObjects(ImageModel.self)
        if let savedObj = obj.first(where:{$0.id == model.id}) {
            
            if !model.isInvalidated {
                
                RealmManager.shared.deleteObject(model) { [weak self] result in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .success:
                        strongSelf.onDeleteSuccess?()
                    case .failure(_):
                        strongSelf.onDeleteFailed?()
                    }
                }
            }
        } else {
            if !model.isInvalidated {
                RealmManager.shared.saveObject(model) { [weak self] result in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .success:
                        strongSelf.onSaveSuccess?()
                    case .failure(_):
                        strongSelf.onSaveFailed?()
                    }
                }
            }
        }
    }
}
