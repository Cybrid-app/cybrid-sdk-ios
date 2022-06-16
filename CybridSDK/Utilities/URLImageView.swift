//
//  URLImageView.swift
//  CybridSDK
//
//  Created by Cybrid on 15/06/22.
//

import Foundation
import UIKit

// MARK: - URLImageView

final class URLImageView: UIImageView {

  let placeholder: UIImage?

  private let operationQueue = OperationQueue()
  private let url: URL
  private let dataProvider: DataProvider

  init(url: URL, placeholder: UIImage? = nil, dataProvider: DataProvider) {
    self.url = url
    self.placeholder = placeholder
    self.dataProvider = dataProvider
    super.init(image: placeholder)
    fetchImage()
  }

  convenience init?(urlString: String, placeholder: UIImage? = nil, dataProvider: DataProvider) {
    guard let url = URL(string: urlString) else { return nil }
    self.init(url: url, placeholder: placeholder, dataProvider: dataProvider)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func fetchImage() {
    let operation = ImageDownloadOperation(url: url, dataProvider: dataProvider)
    operation.completionBlock = {
      DispatchQueue.main.async { [weak self] in
        guard let self = self, let loadedImage = operation.image else { return }
        self.image = loadedImage
      }
    }

    operationQueue.addOperation(operation)
  }
}

// MARK: - ImageDownloadOperation

fileprivate final class ImageDownloadOperation: AsyncOperation {

  var image: UIImage?

  private let url: URL
  private let dataProvider: DataProvider

  init(url: URL, dataProvider: DataProvider) {
    self.url = url
    self.dataProvider = dataProvider
  }

  convenience init?(urlString: String, dataProvider: DataProvider) {
    guard let url = URL(string: urlString) else { return nil }
    self.init(url: url, dataProvider: dataProvider)
  }

  override func main() {
    dataProvider.dataTaskWithURL(url) { [weak self] data, _, error in
      guard let self = self else { return }
      defer { self.state = .finished }
      guard error == nil, let data = data else { return }

      self.image = UIImage(data: data)
    }
    .resume()
  }
}
