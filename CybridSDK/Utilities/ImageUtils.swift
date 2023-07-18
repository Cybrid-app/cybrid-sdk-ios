//
//  ImageUtils.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 17/07/23.
//

import UIKit
import CoreImage

func generateQRCode(from string: String) -> UIImage? {
    
    let data = string.data(using: String.Encoding.ascii)
    guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
    filter.setValue(data, forKey: "inputMessage")
    filter.setValue("H", forKey: "inputCorrectionLevel")

    guard let outputImage = filter.outputImage else { return nil }
    
    let context = CIContext()
    let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
    let size = CGSize(width: 200, height: 200)
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    if let context = UIGraphicsGetCurrentContext() {
        context.interpolationQuality = .none
        context.draw(cgImage!, in: context.boundingBoxOfClipPath)
        let codeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return codeImage
    }
    return nil
}
