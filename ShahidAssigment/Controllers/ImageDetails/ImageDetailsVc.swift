//
//  ImageDetailsVc.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 25/11/2023.
//

import UIKit

class ImageDetailsVc: UIViewController {
    
    var id: String?
    var isLoading: Bool = false
    var image: ImageModel?
    var viewModel = ImageDetailsViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationController()
        registerCells()
        configureSubviews()
        fetchData()
    }
    
    init(id: String) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUpNavigationController() {
        self.title = Constants.details
    }
    
    
    func registerCells() {
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
    }
    
    func configureSubviews() {
        self.view.addSubview(tableView)
        tableView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
        tableView.backgroundColor = .main
        tableView.separatorStyle = .none
    }
    
    func fetchData() {
        
        guard let id = id else { return }
        LoadingViewManager.showLoader(in: self)
        viewModel.onImagesUpdate = {[weak self] image in
            guard let strongSelf = self else { return }
            strongSelf.image = image
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
        
        viewModel.onDeleteSuccess = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.fetchData()
            AlertManager.showAlert(in: strongSelf, title: "Success!", message: "Image has been removed from favorites")
        }
        
        viewModel.fetchData(id: id)
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ImageDetailsVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell else {
            return UITableViewCell()
        }
        
        cell.favoriteButtonTapHandler = { [weak self] in
            guard let strongSelf = self else { return }
            let obj = RealmManager.shared.getObjects(ImageModel.self)
            if let model = obj.first(where:{$0.id == strongSelf.id}) {
                strongSelf.viewModel.handleFavoriteButtonTap(at: model)
            } else {
                if let imageData = strongSelf.image {
                    strongSelf.viewModel.handleFavoriteButtonTap(at: imageData)
                }
            }
        }
        
        if let image = image {
            cell.configure(with: image)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let cellHeight = screenHeight / 3
        return cellHeight
    }
}
