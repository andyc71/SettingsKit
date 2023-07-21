//
//  SettingsKitLabelCell.swift
//  SettingsKit
//
//  Created by Seb Vidal on 05/09/2022.
//

import UIKit

extension UIColor {
    static var labelBackPort: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return UIColor.black
        }
    }
    
    static var secondaryLabelBackPort: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.secondaryLabel
        } else {
            return UIColor.darkGray
        }
    }

}

class SettingsKitLabelCell: UITableViewCell, SettingsKitCell {
    private var setting: SettingsKitLabel!
    
    private var titleLabel: UILabel!
    private var detailLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with setting: any SettingsKitSetting, parent: SettingsKitTableViewController) {
        self.setting = setting as? SettingsKitLabel
        
        setupCell()
        setupTitleLabel()
        setupDetailLabel()
    }
    
    private func setupCell() {
        isUserInteractionEnabled = true
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = setting.title
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    private func setupDetailLabel() {
        detailLabel = UILabel()
        detailLabel.textColor = .secondaryLabelBackPort
        detailLabel.font = .systemFont(ofSize: 17)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.text = stringValue()
        
        addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -22),
        ])
    }
    
    func stringValue() -> String? {
        if let value = setting.value {
            switch value {
            case .userDefaults(let key):
                return UserDefaults.standard.string(forKey: key)
            case .string(let string):
                return string
            }
        }
        
        return nil
    }
}
