//
//  extension.swift
//  Happid
//
//  Created by mac on 22/05/24.
//

import Foundation
import UIKit


extension UIView {
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIColor {
    
    static let themeColor = UIColor(red: 210.0/255.0, green: 105.0/255.0, blue: 130.0/255.0, alpha: 1.0)
    static let gradientOne = UIColor(hex: "#FFFBF3")
    static let gradientTwo = UIColor(hex: "#FFFFFF")
    static let orangeThemeColor = UIColor(hex: "#FF7F5D")
    
    
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
            var hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

            if hexValue.hasPrefix("#") {
                hexValue.remove(at: hexValue.startIndex)
            }

            var rgbValue: UInt64 = 0
            Scanner(string: hexValue).scanHexInt64(&rgbValue)

            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
}
