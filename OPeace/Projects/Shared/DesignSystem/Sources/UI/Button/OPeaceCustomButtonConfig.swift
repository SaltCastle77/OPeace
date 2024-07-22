//
//  OPeaceCustomButtonConfig.swift
//  DesignSystem
//
//  Created by 서원지 on 7/22/24.
//

import Foundation
import SwiftUI

public class OPeaceCustomButtonConfig {
    var cornerRadius: CGFloat
    var enableFontColor: Color
    var enableBackgroundColor:Color
    var frameHeight: CGFloat
    var disableFontColor: Color
    var disableBackgroundColor:Color
    
    public init(
        cornerRadius: CGFloat,
        enableFontColor: Color,
        enableBackgroundColor: Color,
        frameHeight: CGFloat,
        disableFontColor: Color,
        disableBackgroundColor: Color
    ) {
        self.cornerRadius = cornerRadius
        self.enableFontColor = enableFontColor
        self.enableBackgroundColor = enableBackgroundColor
        self.frameHeight = frameHeight
        self.disableFontColor = disableFontColor
        self.disableBackgroundColor = disableBackgroundColor
    }
}
