//
//  CustomButton.swift
//  DesignSystem
//
//  Created by 서원지 on 7/22/24.
//

import SwiftUI

public struct CustomButton: View {
    let action: () -> Void
    let title: String
    let config: OPeaceCustomButtonConfig
    var isEnable: Bool = false
    
    public init(
        action: @escaping () -> Void,
        title:String,
        config:OPeaceCustomButtonConfig,
        isEnable: Bool = false
    ) {
        self.title = title
        self.config = config
        self.action = action
        self.isEnable = isEnable
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: config.cornerRadius)
            .fill(isEnable ? config.enableBackgroundColor : config.disableBackgroundColor)
            .frame(height: config.frameHeight)
            .overlay {
                Text(title)
                    .pretendardFont(family: .Regular, size: 20)
                    .foregroundColor(isEnable ? config.enableFontColor : config.disableFontColor)
            }
            .onTapGesture {
                action()
            }
            .disabled(!isEnable)
            
    }
}
