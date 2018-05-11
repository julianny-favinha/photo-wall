//
//  ThemeReference.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 11/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import Foundation

enum Theme: String {
    case defaultTheme = "Regular theme"
    case pinTheme = "Photo pin theme"
}

class ThemeReference {
    static let themes: [Theme] = [.defaultTheme, .pinTheme]
    static let themeDict: [Theme: PhotoWallTheme] =
        [.defaultTheme: DefaultTheme(),
         .pinTheme: PhotoPinTheme()]
}
