//
//  Colors.swift
//  MineSweeper
//
//  Created by yy on 2024/12/22.
//

import UIKit

extension UIColor {
    
    /// 4B3B1A
    static let title = UIColor(hex: "4B3B1A")
    
    /// de3b40
    static let mine = UIColor(hex: "de3b40")
    
    /// 379ae6 - 0.5
    static let covered = UIColor(hex: "379ae6", alpha: 0.5)
    
    /// ebe9ec
    static let revealed = UIColor(hex: "ebe9ec", alpha: 1)
    
    
    /// ef6984
    static let hint = UIColor(hex: "ef6984", alpha: 1)
    
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        let scanner = Scanner(string: hexSanitized)
        scanner.scanHexInt64(&rgb)

        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // Method to get color based on the number of adjacent mines
    static func colorForMineCount(_ count: Int) -> UIColor {
        switch count {
        case 1:
            return UIColor(hex: "93dd62")
        case 2:
            return UIColor(hex: "fec753")
        case 3:
            return UIColor(hex: "ef6984")
        case 4:
            return UIColor(hex: "48bee2")
        case 5:
            return UIColor(hex: "7d8ed4")
        case 6:
            return UIColor(hex: "44cb89")
        case 7:
            return UIColor(hex: "a12f96")
        case 8:
            return UIColor(hex: "ec7735")
        default:
            return UIColor.clear // For 0 or invalid counts
        }
    }
}

