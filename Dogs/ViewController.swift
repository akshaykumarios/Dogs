//
//  ViewController.swift
//  Dogs
//
//  Created by Akshay Kumar on 07/07/24.
//

import UIKit
import DogImages

final class ViewController: UIViewController {
    
    @IBOutlet weak var inputBarButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    private var presenter: DogImagePresenter!
    
    private var currentIndex: Int = 0 {
        didSet {
            previousButton.isEnabled = currentIndex == 0 ? false : true
            nextButton.isEnabled = currentIndex == 9 ? false : true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonActions()
        previousButton.isEnabled = false
        
        let model = DogImageModel()
        presenter = DogImagePresenter(model: model)
        presenter.attachView(self)
        
        presenter.getImage()
    }
    
    private func addButtonActions() {
        let previousAction = UIAction { _ in
            self.previousButtonTapped()
        }
        previousButton.addAction(previousAction, for: .primaryActionTriggered)
        
        let nextAction = UIAction {_ in
            self.nextButtonTapped()
        }
        nextButton.addAction(nextAction, for: .primaryActionTriggered)
    }
    
    private func previousButtonTapped() {
        currentIndex -= 1
        presenter.getPreviousImage()
    }
    
    private func nextButtonTapped() {
        currentIndex += 1
        presenter.getNextImage()
    }
    
    private func showInputAlert() {
        let alert = UIAlertController(title: "Enter Input", message: "Enter number of images to show as collection", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .numberPad
            textField.placeholder = "Enter input"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
            guard let inputText = Int(alert.textFields?.first?.text ?? "") else { return }
            if inputText >= 1 && inputText <= 10 {
                self?.navigateToNextScreen(with: inputText)
            } else {
                return
            }
        }))
        present(alert, animated: true)
    }
    
    private func navigateToNextScreen(with input: Int) {
        guard let imagesVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageCollectionVC") as? ImageCollectionVC else { return }
        imagesVC.collectionSize = input
        self.navigationController?.pushViewController(imagesVC, animated: true)
    }
    
    @IBAction private func inputButtonTapped(_ sender: UIBarButtonItem) {
        showInputAlert()
    }
}

extension ViewController: DogImageView {
    func displayImage(_ image: URL) {
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: image) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    func displayImages(_ images: [URL]) {
        if let firstImage = images.first {
            displayImage(firstImage)
        }
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
