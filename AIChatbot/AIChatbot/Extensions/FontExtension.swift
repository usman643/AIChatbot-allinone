//
//  FontExtension.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 23/03/2025.
//

import SwiftUI

extension Font {
    
    static func thinFont(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Thin", size: size)
    }
    
    static func lightFont(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Light", size: size)
    }
    
    static func ExtraLightFont(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-ExtraLight", size: size)
    }
    
    static func regularFont(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Regular", size: size)
    }
    
    static func mediumFont(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Medium", size: size)
    }
    
    static func boldFont(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Bold", size: size)
    }
    
    static func semiboldFont(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-SemiBold", size: size)
    }
    
    static func ExtraBoldFont(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-ExtraBold", size: size)
    }
    
    static func heavyFont(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Heavy", size: size)
    }
    
}
