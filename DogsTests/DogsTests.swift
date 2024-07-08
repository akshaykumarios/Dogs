//
//  DogsTests.swift
//  DogsTests
//
//  Created by Akshay Kumar on 07/07/24.
//

import XCTest
import DogImages
@testable import Dogs

class MockDogImageView: DogImageView {
    var displayedImage: URL?
    var displayedImages: [URL] = []
    var error: String?
    
    func displayImage(_ image: URL) {
        displayedImage = image
    }
    
    func displayImages(_ images: [URL]) {
        displayedImages = images
    }
    
    func showError(_ error: String) {
        self.error = error
    }
}

final class DogsTests: XCTestCase {
    
    var presenter: DogImagePresenter!
    var mockView: MockDogImageView!
    var model: DogImageModel!
    
    override func setUp() {
        super.setUp()
        model = DogImageModel()
        presenter = DogImagePresenter(model: model)
        mockView = MockDogImageView()
        presenter.attachView(mockView)
    }
    
    func testGetImage() {
        presenter.getImage()
        XCTAssertNotNil(mockView.displayedImage)
        XCTAssertNil(mockView.error)
    }
    
    func testGetImages() {
        presenter.getImages(2)
        XCTAssertEqual(mockView.displayedImages.count, 2)
        XCTAssertNil(mockView.error)
    }
    
    func testGetNextImage() {
        presenter.getNextImage()
        XCTAssertNotNil(mockView.displayedImage)
        XCTAssertNil(mockView.error)
    }
    
    func testGetPreviousImage() {
        presenter.getPreviousImage()
        XCTAssertNotNil(mockView.displayedImage)
        XCTAssertNil(mockView.error)
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        model = nil
        super.tearDown()
    }
}
