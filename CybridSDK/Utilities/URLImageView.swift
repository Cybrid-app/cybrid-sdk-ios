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

  private let operationQueue = OperationQueue()
  let placeholder: UIImage?
  let url: URL

  init(url: URL, placeholder: UIImage? = nil) {
    self.url = url
    self.placeholder = placeholder
    super.init(image: placeholder)
    fetchImage()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func fetchImage() {
    let operation = ImageDownloadOperation(url: url)
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

  init(url: URL) {
    self.url = url
  }

  override func main() {
    URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
      guard let self = self else { return }
      defer { self.state = .finished }
      guard error == nil, let data = data else { return }

      self.image = UIImage(data: data)
    }
    .resume()
  }
}
