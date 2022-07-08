//
//  NetworkingInterfaces.swift
//  CybridSDK
//
//  Created by Cybrid on 15/06/22.
//

import Foundation

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol DataProvider {
  func dataTaskWithURL(_ url: URL, completionHandler: @escaping DataTaskResult) -> DataTask
}

extension URLSession: DataProvider {
  func dataTaskWithURL(_ url: URL, completionHandler: @escaping DataTaskResult) -> DataTask {
    dataTask(with: url, completionHandler: completionHandler) as DataTask
  }
}

protocol DataTask {
  func resume()
}

extension URLSessionDataTask: DataTask {}
