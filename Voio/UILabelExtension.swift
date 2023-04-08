//
//  UILabelExtension.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 08.04.2023.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont?, alignment: NSTextAlignment) {
        self.init()
        self.text = text
        self.font = font
        self.textAlignment = alignment
        self.textColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
