//
//  PhotoItemCollectionViewCell.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 7.03.2023.
//

import UIKit

class PhotoItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: PhotoItemCellViewModel! {
        didSet { setUpViewModel() }
    }
    
    public static let identifier = "photo_item_cell"

    private func setUpViewModel() {
        titleLabel.text = viewModel.title
        
        if let url = viewModel.imageURL {
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                } catch {
                    self.imageView.image = nil
                }
            }
        }
    }
}
