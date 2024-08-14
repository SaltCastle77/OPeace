//
//  Emoji+Extension+Image.swift
//  DesignSystem
//
//  Created by 서원지 on 8/14/24.
//

import SwiftUI

public extension Image {
    static func emojiToImage(emoji: String, size: CGSize = CGSize(width: 100, height: 100)) -> Image? {
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            UIColor.clear.set()
            let rect = CGRect(origin: .zero, size: size)
            UIRectFill(rect)
            (emoji as NSString).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: size.width * 0.8)])
            let uiImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let uiImage = uiImage {
                return Image(uiImage: uiImage)
            } else {
                return nil
            }
        }
}
