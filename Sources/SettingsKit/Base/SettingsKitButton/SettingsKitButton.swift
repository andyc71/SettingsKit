//
//  SettingsKitButton.swift
//  SettingsKit
//
//  Created by Andy Clynes on 21/07/2023.
//

import UIKit

public struct SettingsKitButton: SettingsKitSetting {
    public let title: String
    public let children: [SettingsKitSection]?
    public let value: Value?
    
    public enum Value {
        case action( ()->() )
    }
    
    public init(title: String, value: Value) {
        self.title = title
        self.children = []
        self.value = value
    }
    
    public func cellReuseIdentifier() -> String {
        return "SettingsKitButtonCell"
    }
}
