//
//  CustomButtonConfig.swift
//  DesignSystem
//
//  Created by 서원지 on 7/22/24.
//

import Foundation
import SwiftUI

public class CustomButtonConfig: OPeaceCustomButtonConfig {
    static public func create() -> OPeaceCustomButtonConfig {
        let config = OPeaceCustomButtonConfig(
            cornerRadius: 30,
            enableFontColor: Color.gray600,
            enableBackgroundColor: Color.basicPrimary,
            frameHeight: 56,
            disableFontColor: Color.gray200,
            disableBackgroundColor: Color.gray400
        )
        
        return config
    }
}
