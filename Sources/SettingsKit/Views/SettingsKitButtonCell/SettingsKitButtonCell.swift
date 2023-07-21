//
//  SettingsKitButtonCell.swift
//  SettingsKit
//
//  Created by Andy Clynes on 21/07/2023.
//

import UIKit

class SettingsKitButtonCell: UITableViewCell, SettingsKitCell {
    private var setting: SettingsKitButton!

    private var button: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with setting: any SettingsKitSetting, parent: SettingsKitTableViewController) {
        self.setting = setting as? SettingsKitButton
        
        setupCell()
        setupButton()
    }
    
    private func setupCell() {
        isUserInteractionEnabled = true
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    private func setupButton() {
        button = UIButton(type: .system)
        button.setTitle(setting.title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        if let value = setting.value {
            switch value {
            case .action(let closure):
                closure()
            }
        }
    }
}
