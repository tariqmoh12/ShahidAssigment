//
//  BaseVc.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 25/11/2023.
//

import UIKit

class BaseVc: UIViewController {
    
    var imagesData: ImagesModel?
    var offset: Int?
    var isLoading: Bool = false
    var isPagination = true
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        configureSubviews()
    }
    
    func registerCells() {
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }
    
    func configureSubviews() {
        self.view.addSubview(collectionView)
        collectionView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
        collectionView.backgroundColor = .main
    }
    
    func fetchData() {
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func handleFavoriteButtonTap(at model: ImageModel) {
        
        let obj = RealmManager.shared.getObjects(ImageModel.self)
        if !(obj.contains(where: { $0.id == model.id })) {
            if !model.isInvalidated {
                RealmManager.shared.saveObject(model) { [weak self] result in
                    guard let strongSelf = self else { return }
                    
                    switch result {
                    case .success:
                        print("Save successful")
                        strongSelf.collectionView.reloadData()
                        AlertManager.showAlert(in: strongSelf, title: "Success!", message: "Image has been added to favorites")
                        
                    case .failure(let error):
                        AlertManager.showAlert(in: strongSelf, title: "Failed!", message: "Save failed with error: \(error.localizedDescription)")
                    }
                }}
            
        } else {
            if !model.isInvalidated {
                RealmManager.shared.deleteObject(model) { [weak self] result in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .success:
                        strongSelf.collectionView.reloadData()
                        AlertManager.showAlert(in: strongSelf, title: "Success!", message: "Image has been removed from favorites")
                        
                    case .failure(let error):
                        AlertManager.showAlert(in: strongSelf, title: "Failed!", message: "Deletion failed with error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}


extension BaseVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesData?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 3 * 10) / 2
        let cellHeight: CGFloat = 300
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedImageId = self.imagesData?.data[indexPath.item].id {
            let newViewController = ImageDetailsVc(id: selectedImageId)
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
}

