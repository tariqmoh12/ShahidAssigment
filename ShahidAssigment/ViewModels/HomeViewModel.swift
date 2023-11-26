//
//  HomeViewModel.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 24/11/2023.
//

import Foundation

class HomeViewModel {
    
    var onImagesUpdate: ((ImagesModel?) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onSaveSuccess: (() -> Void)?
    var onSaveFailed: (() -> Void)?
    var onDeleteSuccess: (() -> Void)?
    var onDeleteFailed: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    var limit: Int = 20
    var offset: Int?
    
    private var images: ImagesModel? {
        didSet {
            onImagesUpdate?(images)
        }
    }
    
    private var isLoading = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    
    func fetchData(offset: Int) {
        Task {
            do {
                isLoading = true
                let result: ImagesModel = try await NetworkingManager.fetchData(for: ImagesModel.self, from: Apis.getHomeImages(limit: limit, offset: offset).url)
                
                DispatchQueue.main.async {
                    if let existingImages = self.images {
                        existingImages.data.append(objectsIn: result.data)
                        existingImages.pagination = result.pagination
                        self.onImagesUpdate?(existingImages)
                    } else {
                        self.images = result
                    }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print(error.localizedDescription)
                    self.onError?(error)
                }
            }
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
