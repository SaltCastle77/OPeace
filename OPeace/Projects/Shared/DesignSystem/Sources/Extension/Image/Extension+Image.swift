//
//  Extension+Image.swift
//  DesignSystem
//
//  Created by 서원지 on 7/13/24.
//

import Foundation
import UIKit

public extension UIImage {
    
     func roundedImage() -> UIImage? {
           let imageSize = CGSize(width: self.size.width, height: self.size.height)
           let radius = min(self.size.width, self.size.height) / 2.0
           let roundedRect = CGRect(origin: .zero, size: imageSize).insetBy(dx: radius, dy: radius)
           
           let renderer = UIGraphicsImageRenderer(size: imageSize)
           let roundedImage = renderer.image { context in
               let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: imageSize), cornerRadius: radius)
               context.cgContext.addPath(path.cgPath)
               context.cgContext.clip()
               self.draw(in: roundedRect)
           }
           return roundedImage
       }
    
     func setRoundedCorners() -> UIImage? {
        let imageView = UIImageView(image: self)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = imageView.frame.width / 2.0
        UIGraphicsBeginImageContext(imageView.bounds.size)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
            return roundedImage
        }
        return nil
    }
    
    func emojiToImage(emoji: String, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(rect)
        (emoji as NSString).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: size.width * 0.8)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

