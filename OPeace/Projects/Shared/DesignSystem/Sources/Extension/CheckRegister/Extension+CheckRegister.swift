//
//  Extension+CheckRegister.swift
//  DesignSystem
//
//  Created by 서원지 on 7/26/24.
//

import Utill
import SwiftUI

extension CheckRegister {
    
    @discardableResult
    public static func getGeneration(
        year: Int,
        color: Color,
        textColor: Color
    ) -> (String, Color, Color) {
        if (1995...2022).contains(year) {
            return ("BB세대", .basicPurple, .basicWhite)
        } else if (1981...1996).contains(year) {
            return ("M세대", .basicYellow, .basicWhite)
        } else if (1965...1980).contains(year) {
            return ("X세대", .basicLightBlue, .basicWhite)
        } else if (1941...1964).contains(year) {
            return ("Z세대", .basicGreen, .basicWhite)
        } else {
            return ("기타세대", .gray500, .gray200)
        }
    }
}
