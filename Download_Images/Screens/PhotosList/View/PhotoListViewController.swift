//
//  ViewController.swift
//  Download_Images
//
//  Created by VAIBHAV JOSHI on 13/04/24.
//

import UIKit

class PhotoListViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadMoreButton: UIButton!
    
    private let photosModelList = PhotoListViewModel()
    var currentPage = 1
    var viewType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        let newLayout = UICollectionViewFlowLayout()
        newLayout.minimumLineSpacing = 0
        newLayout.minimumInteritemSpacing = 0
        newLayout.scrollDirection = (viewType == 0) ? .horizontal : .vertical
        collectionView.collectionViewLayout = newLayout
        collectionView.register(identifier: PhotoCell.identifier)
        collectionView.isPagingEnabled = (viewType == 3) ? false : true
        fetchPhotos(pageNumber: currentPage)
    }
    
    @IBAction func loadMoreButtonAction(_ sender: UIButton) {
        currentPage = currentPage + 1
        fetchPhotos(pageNumber: currentPage)
    }
    
    func prefetchImagesForVisibleItems(_ completion: (() -> Void)? = nil) {
        
        let urlsToPrefetch = collectionView.indexPathsForVisibleItems.compactMap { indexPath in
            return photosModelList.photoURL(for: indexPath.row)
        }
        
        urlsToPrefetch.forEach { urlString in
            if let url = URL(string: urlString) {
                ImageDownloaderFactory.shared.getImage(for: url) { _  in
                    
                }
            }
        }
    }

    private func fetchPhotos(pageNumber: Int) {
        Loader.shared.show()
        photosModelList.fetchPhotos(page: pageNumber) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self.photosModelList.photos.append(contentsOf: photos)
                    self.collectionView.reloadData()
                    self.prefetchImagesForVisibleItems {
                        Loader.shared.hide()
                    }
                case .failure(let error):
                    Loader.shared.hide()
                    print("Error fetching photos: \(error.localizedDescription)")
                    // Handle error gracefully
                }
            }
        }
    }
}

extension PhotoListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosModelList.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        if let photoURL = photosModelList.photoURL(for: indexPath.row) {
            cell.configure(with: photoURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadMoreButton.isHidden = (indexPath.row == photosModelList.photos.count - 1) || (indexPath.row == photosModelList.photos.count - 2) ? false : true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (viewType == 2) ? (collectionView.frame.size.width - 4) / 3 : collectionView.frame.size.width
        let height = (viewType == 2) ? width : collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
}
