//
//  URLImageView.swift
//  CybridSDK
//
//  Created by Cybrid on 15/06/22.
//

import Foundation
import UIKit

final class ImageDownloadOperation: AsyncOperation {

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
