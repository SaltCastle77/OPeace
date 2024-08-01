//
//  Extension+String.swift
//  Utill
//
//  Created by 서원지 on 8/1/24.
//

import Foundation

public extension String {
    func calculateWidth(for title: String) -> CGFloat {
      let baseWidth: CGFloat = 50
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
        return baseWidth + 40
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
}
