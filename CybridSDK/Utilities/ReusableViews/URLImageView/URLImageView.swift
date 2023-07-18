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

    typealias ImageOperationProvider = (_ url: URL, _ dataProvider: DataProvider) -> URLImageOperation

    // MARK: Internal properties
    let placeholder: UIImage?

    // MARK: Private propertie
    private var url: URL?
    private var imageOperation: URLImageOperation?

    // MARK: Injectable Dependencies
    private var operationQueue: OperationQueueType = OperationQueue()
    private var dataProvider: DataProvider = URLSession.shared
    private var completionDispatchQueue: DispatchQueueType = DispatchQueue.main
    private var imageOperationProvider: ImageOperationProvider = { url, dataProvider in
        ImageDownloadOperation(url: url, dataProvider: dataProvider)
    }

    // MARK: Initializers
    init(url: URL?, placeholder: UIImage? = nil) {

        self.url = url
        self.placeholder = placeholder
        super.init(image: placeholder)
        loadImage()
    }

    convenience init?(urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else { return nil }
        self.init(url: url, placeholder: placeholder)
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) should never be used")
        return nil
    }

    internal func loadImage() {

        contentMode = .scaleAspectFit
        guard let url = url else {
            self.image = placeholder
            return
        }
        if let imageOp = imageOperation, imageOp.isExecuting {
            imageOperation?.cancel()
        }
        imageOperation = imageOperationProvider(url, dataProvider)
        imageOperation?.completionBlock = { [weak self] in
            self?.completionDispatchQueue.async {
                self?.image = self?.imageOperation?.image
            }
        }
        operationQueue.addOperation(imageOperation!)
    }

    func inject(operationQueue: OperationQueueType? = nil,
                dataProvider: DataProvider? = nil,
                completionDispatchQueue: DispatchQueueType? = nil,
                imageOperationProvider: ImageOperationProvider? = nil) {

        if let operationQueue = operationQueue {
            self.operationQueue = operationQueue
        }
        if let dataProvider = dataProvider {
            self.dataProvider = dataProvider
        }
        if let completionDispatchQueue = completionDispatchQueue {
            self.completionDispatchQueue = completionDispatchQueue
        }
        if let imageOperationProvider = imageOperationProvider {
            self.imageOperationProvider = imageOperationProvider
        }
    }

    func setURL(_ url: URL) {
        self.url = url
        loadImage()
    }

    func setURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        setURL(url)
    }

    deinit {
        imageOperation?.cancel()
    }
}
