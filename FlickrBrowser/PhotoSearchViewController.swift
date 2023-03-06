//
//  PhotoSearchViewController.swift
//  FlickrBrowser
//
//  Created by Murat Remzi Tezyapar on 6.03.2023.
//

import UIKit
import Combine

class PhotoSearchViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<PhotoSearchViewModel.Section, PhotoListItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<PhotoSearchViewModel.Section, PhotoListItem>
    
    internal var viewModel: PhotoSearchViewModel!
    private var dataSource: DataSource!
    private var cancellables: [AnyCancellable] = []
    private let selection = PassthroughSubject<Int, Never>()

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


