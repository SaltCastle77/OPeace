//
//  Extension+String.swift
//  Utill
//
//  Created by 서원지 on 8/1/24.
//

import Foundation

public extension String {
    func calculateWidth(for title: String) -> CGFloat {
      let baseWidth: CGFloat = 64
      let extraWidthPerCharacter: CGFloat = 10
      
      if title.count <= 2 {
        return baseWidth
      } else if title.count == 4 {
        return baseWidth + 30
      } else if title.count == 5 {
        return baseWidth + 40
      }
      else {
        return baseWidth + extraWidthPerCharacter * CGFloat(title.count - 2)
      }
    }
    
    func calculateWidthProfile(for title: String) -> CGFloat {
      let baseWidth: CGFloat = 45
      let extraWidthPerCharacter: CGFloat = 10
      
      if title.count <= 2 {
        return baseWidth
      } else if title.count == 4 {
        return baseWidth + 30
      } else if title.count == 5 {
        return baseWidth + 30
      }
      else {
        return baseWidth + extraWidthPerCharacter * CGFloat(title.count - 2)
      }
    }
    
    func calculateWidthProfileGeneration(for title: String) -> CGFloat {
      let baseWidth: CGFloat = 40
      let extraWidthPerCharacter: CGFloat = 5
      
      if title.count <= 2 {
        return baseWidth
      } else if title.count == 4 {
        return baseWidth + 10
      } else if title.count == 5 {
        return baseWidth + 30
      }
      else {
        return baseWidth + extraWidthPerCharacter * CGFloat(title.count - 2)
      }
    }
    
    func calculateWidthAge(for title: String) -> CGFloat {
      let baseWidth: CGFloat = 70
      let extraWidthPerCharacter: CGFloat = 10
      
      if title.count <= 2 {
        return baseWidth
      } else if title.count == 4 {
        return baseWidth + 30
      } else if title.count == 5 {
        return baseWidth + 40
      }
      else {
        return baseWidth + extraWidthPerCharacter * CGFloat(title.count - 2)
      }
    }
    
    func size(withAttributes attrs: [NSAttributedString.Key: Any]) -> CGSize {
        return (self as NSString).size(withAttributes: attrs)
    }
    
    func convertEmojiToUnicode(_ emoji: String) -> String {
        return emoji.unicodeScalars.map { "\\u\(String($0.value, radix: 16, uppercase: true))" }.joined()
    }
    
    func convertUnicodeToEmoji(_ unicode: String) -> String? {
        let cleanedUnicode = unicode.replacingOccurrences(of: "\\u", with: "")
        if let scalarValue = UInt32(cleanedUnicode, radix: 16),
           let scalar = UnicodeScalar(scalarValue) {
            return String(scalar)
        }
        
        return nil
    }

}
