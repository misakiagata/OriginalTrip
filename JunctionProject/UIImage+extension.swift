//
//  UIImage+extension.swift
//  JunctionProject
//
//  Created by 塗木冴 on 2019/02/17.
//  Copyright © 2019 GeekSalon. All rights reserved.
//

import UIKit

extension UIImage {
    func croppingToCenterSquare() -> UIImage {
        let cgImage = self.cgImage!
        var newWidth = CGFloat(cgImage.width)
        var newHeight = CGFloat(cgImage.height)
        if newWidth > newHeight {
            newWidth = newHeight
        } else {
            newHeight = newWidth
        }
        let x = (CGFloat(cgImage.width) - newWidth)/2
        let y = (CGFloat(cgImage.height) - newHeight)/2
        let rect = CGRect(x: x, y: y, width: newWidth, height: newHeight)
        let croppedCGImage = cgImage.cropping(to: rect)!
        return UIImage(cgImage: croppedCGImage, scale: self.scale, orientation: self.imageOrientation)
    }

    func configureUpload() -> Data? {
        let image = self.resize(size: CGSize(width: 224, height: 224))
        guard let resizedImageData = image.jpegData(compressionQuality: 0.75) else { return nil }
        return resizedImageData
    }

    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        let resizeSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(resizeSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizeSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
