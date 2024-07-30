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
        if (1955...1964).contains(year) {
            return ("베이비붐 세대", .basicPurple, .gray600)
        } else if (1965...1980).contains(year) {
            return ("X 세대", .basicLightBlue, .gray600)
        } else if (1981...1996).contains(year) {
            return ("M 세대", .basicYellow, .gray600)
        } else if (1997...2010).contains(year) {
            return ("Z 세대", .basicGreen, .gray600)
        } else if (2010...).contains(year) {
            return ("알파 세대", .basicGreen, .gray600)
        } else {
            return ("? 세대", .gray500, .gray200)
        }
    }
}
