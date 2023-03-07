//
//  PhotoDetailViewController.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 7.03.2023.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    internal var viewModel: PhotoDetailViewModel!
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    func loadData() {
        self.title = viewModel.title
        self.loadImage()
    }

    func loadImage() {
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
