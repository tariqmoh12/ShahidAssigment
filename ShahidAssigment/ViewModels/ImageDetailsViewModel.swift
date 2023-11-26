//
//  ImageDetailsViewModel.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 24/11/2023.
//

import Foundation

class ImageDetailsViewModel {
    var onImagesUpdate: ((ImageModel?) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onSaveSuccess: (() -> Void)?
    var onSaveFailed: (() -> Void)?
    var onDeleteSuccess: (() -> Void)?
    var onDeleteFailed: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    var limit: Int = 20
    var offset: Int?
    
    private var image: ImageModel? {
        didSet {
            onImagesUpdate?(image)
        }
    }
    
    private var isLoading = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    
    func fetchData(id: String) {
        Task {
            do {
                isLoading = true
                let result: ImageDetailsModel = try await NetworkingManager.fetchData(for: ImageDetailsModel.self, from: Apis.getImageDetails(id:id).url)
                
                DispatchQueue.main.async {
                    self.image = result.data
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
            
            if !savedObj.isInvalidated {
                RealmManager.shared.deleteObject(savedObj) { [weak self] result in
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
                        print("Save successful")
                        strongSelf.onSaveSuccess?()
                    case .failure(_):
                        strongSelf.onSaveFailed?()
                    }
                }
            }
        }
    }
}
