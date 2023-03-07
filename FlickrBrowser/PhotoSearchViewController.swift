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
    private let search = PassthroughSubject<String, Never>()

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        configureDataSource()
        self.bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.$items
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateSections()
            }
            .store(in: &cancellables)
        
        _ = self.viewModel.transform(search: search.eraseToAnyPublisher(),
                                                    select: selection.eraseToAnyPublisher())
    }
    
    func reload() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        let searchPrefix = sender.text ?? ""
        search.send(searchPrefix)
    }
    
    //MARK: - UICollectionView configuration
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.photos])
        snapshot.appendItems(viewModel.items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 140)
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.delegate = self
    }
}

//MARK: - UICollectionViewDiffableDataSource
extension PhotoSearchViewController {
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> PhotoItemCollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PhotoItemCollectionViewCell.identifier,
                    for: indexPath) as? PhotoItemCollectionViewCell
                cell?.viewModel = PhotoItemCellViewModel(item: item)
                return cell
            })
    }
}

//MARK: - UICollectionViewDelegate
extension PhotoSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selection.send(indexPath.row)
    }
}
