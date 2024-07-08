//
//  ImageCollectionVC.swift
//  Dogs
//
//  Created by Akshay Kumar on 07/07/24.
//

import UIKit
import DogImages

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

class ImageCollectionVC: UIViewController, DogImageView {
    
    @IBOutlet weak var imageCollection: UICollectionView!
    
    var collectionSize: Int = 0
    var images: [UIImage] = [] {
        didSet {
            imageCollection.reloadData()
        }
    }
    
    private var presenter: DogImagePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        let model = DogImageModel()
        presenter = DogImagePresenter(model: model)
        presenter.attachView(self)
        
        presenter.getImages(collectionSize)
    }
    
    func displayImage(_ image: URL) {
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: image) {
                DispatchQueue.main.async {
                    self.images.append(UIImage(data: data) ?? UIImage())
                }
            }
        }
    }
    
    func displayImages(_ images: [URL]) {
        images.forEach { [weak self] url in
            self?.displayImage(url)
        }
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ImageCollectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        cell.imageView.image = images[indexPath.item]
        return cell
    }
}
