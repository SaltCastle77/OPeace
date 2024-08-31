//
//  UnderlineView.swift
//  DesignSystem
//
//  Created by 서원지 on 8/4/24.
//

import SwiftUI

public struct UnderlineView: View {
    var text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let textWidth = calculateUnderlineWidth(text: text) 
            RoundedRectangle(cornerRadius: 1)
                .fill(Color.basicWhite)
                .frame(width: textWidth, height: 2)
                .offset(x: (geometry.size.width - textWidth) / 2)
        }
    }
    
    
    private func calculateUnderlineWidth(text: String) -> CGFloat {
        let baseWidthForThreeCharacters: CGFloat = 125
        let baseCharacterCount = 3

        let widthPerCharacter: CGFloat = baseWidthForThreeCharacters / CGFloat(baseCharacterCount)
        var totalWidth: CGFloat = 0
        
        for char in text {
            if isKoreanCharacter(char) {
                totalWidth += widthPerCharacter * 0.8
            } else {
                totalWidth += widthPerCharacter
            }
        }
        return max(totalWidth, widthPerCharacter * CGFloat(text.count))
    }
    
    private func isKoreanCharacter(_ char: Character) -> Bool {
        return ("\u{AC00}" <= char && char <= "\u{D7A3}") || ("\u{1100}" <= char && char <= "\u{11FF}")
    }
}
