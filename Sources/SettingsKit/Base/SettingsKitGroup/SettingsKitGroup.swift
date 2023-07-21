//
//  SettingsKitGroup.swift
//  SettingsKit
//
//  Created by Seb Vidal on 02/09/2022.
//

import UIKit

public struct SettingsKitGroup: SettingsKitSetting {
    public let icon: Icon?
    public let title: String
    public let children: [SettingsKitSection]?
    public let value: Value?
    
    public enum Value {}
    
    public init(icon: Icon? = nil, title: String, children: [SettingsKitSection]? = nil) {
        self.icon = icon
        self.title = title
        self.children = children
        self.value = nil
    }
    
    public func cellReuseIdentifier() -> String {
        return "SettingsKitGroupCell"
    }
}

extension UIImage {
    open class SymbolConfigurationBackport {
        var pointSize: CGFloat
        public init(pointSize: CGFloat) {
            self.pointSize = pointSize
        }
        
        @available(iOS 13.0, *)
        var symbolConfiguration: UIImage.SymbolConfiguration {
            return UIImage.SymbolConfiguration(pointSize: pointSize)
        }
        
    }
}

public extension SettingsKitGroup {
    struct Icon {
        var symbol: UIImage?
        var config: UIImage.SymbolConfigurationBackport
        var colour: UIColor
        
        public init(symbol: UIImage? = nil, config: UIImage.SymbolConfigurationBackport = .init(pointSize: 21), colour: UIColor) {
            self.symbol = symbol
            self.config = config
            self.colour = colour
        }
        
        func view() -> UIView {
            let iconView = UIView()
            iconView.clipsToBounds = true
            iconView.layer.cornerRadius = 6.5
            iconView.backgroundColor = colour
//            if #available(iOS 13.0, *) {
//                iconView.layer.cornerCurve = .continuous
//            }
            iconView.translatesAutoresizingMaskIntoConstraints = false
            
            let iconImageView = UIImageView()
            iconImageView.tintColor = .white
            if #available(iOS 13.0, *) {
                iconImageView.image = symbol?.withConfiguration(config.symbolConfiguration)
            }
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            
            iconView.addSubview(iconImageView)
            
            NSLayoutConstraint.activate([
                iconView.widthAnchor.constraint(equalToConstant: 29),
                iconView.heightAnchor.constraint(equalToConstant: 29),
                
                iconImageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
            ])
            
            return iconView
        }
    }
}
