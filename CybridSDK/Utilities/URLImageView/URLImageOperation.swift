//
//  URLImageOperation.swift
//  CybridSDK
//
//  Created by Cybrid on 16/06/22.
//

import Foundation
import UIKit

// MARK: - ImageDownloadOperation

protocol URLImageOperation: AsyncOperation {
  var image: UIImage? { get set }
  var isExecuting: Bool { get }
  var completionBlock: (() -> Void)? { get set }

  func cancel()
}

final class ImageDownloadOperation: AsyncOperation, URLImageOperation {

  var image: UIImage?

  private let url: URL
  private let dataProvider: DataProvider

  init(url: URL, dataProvider: DataProvider) {
    self.url = url
    self.dataProvider = dataProvider
  }

  override func main() {
    dataProvider.dataTaskWithURL(url) { [weak self] data, _, error in
      defer { self?.state = .finished }
      guard error == nil, let data = data else { return }
      self?.image = UIImage(data: data)
    }
    .resume()
  }
}
