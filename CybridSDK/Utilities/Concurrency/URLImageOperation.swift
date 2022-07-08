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
      guard
        let cgDataProvider = CGDataProvider(data: data as CFData),
        let document = CGPDFDocument(cgDataProvider),
        let page = document.page(at: 1)
      else { return }
      let pageRect = page.getBoxRect(.mediaBox)
      let renderer = UIGraphicsImageRenderer(size: pageRect.size)
      let img = renderer.image { context in
        UIColor.clear.set()
        context.fill(pageRect)
        context.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
        context.cgContext.scaleBy(x: 1.0, y: -1.0)
        context.cgContext.drawPDFPage(page)
      }
      self?.image = img
    }
    .resume()
  }
}
