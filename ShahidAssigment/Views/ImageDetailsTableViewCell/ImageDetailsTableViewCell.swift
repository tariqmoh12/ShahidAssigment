//
//  ImageDetailsTableViewCell.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 25/11/2023.
//

import Foundation
import UIKit
import SwiftyGif
import RealmSwift

class ImageTableViewCell: UITableViewCell {

    // MARK: - Properties

    var favoriteButtonTapHandler: (() -> Void)?

    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        contentView.addSubview(cellImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(favoriteButton)
        self.contentView.layer.cornerRadius = 20
        self.contentView.backgroundColor = .main
        self.backgroundColor = .main
        self.selectionStyle = .none
        setupConstraints()
    }

    private func setupConstraints() {
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        cellImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: descriptionLabel.topAnchor, trailing: contentView.trailingAnchor)
        descriptionLabel.anchor(top: cellImageView.bottomAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 10, bottom: -10, right: 5))
        favoriteButton.anchor(top: cellImageView.topAnchor, trailing: cellImageView.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: -25), size: CGSize(width: 40, height: 40))
    }

    // MARK: - Public Methods

    func configure(with item: ImageModel) {
        let obj = RealmManager.shared.getObjects(ImageModel.self)
        let imageName = obj.contains(where: {$0.id == item.id}) ? "ic_isFavorite" : "ic_unFavorite"
        if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) {
            favoriteButton.setImage(image, for: .normal)
            favoriteButton.tintColor = UIColor.red // Adjust tint color as needed
        }

        let url = URL(string: item.images?.downsized?.url ?? "")
        let loader = UIActivityIndicatorView(style: .medium)
        cellImageView.contentMode = .scaleAspectFit
        cellImageView.setGifFromURL(url!, customLoader: loader)
        descriptionLabel.text = item.title
    }

    // MARK: - Private Methods

    @objc private func favoriteButtonTapped() {
        favoriteButtonTapHandler?()
    }
}
