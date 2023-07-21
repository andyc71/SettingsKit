//
//  SettingsKitToggleCell.swift
//  SettingsKit
//
//  Created by Seb Vidal on 29/08/2022.
//

import UIKit

class SettingsKitToggleCell: UITableViewCell, SettingsKitCell {
    private var setting: SettingsKitToggle!

    private var titleLabel: UILabel!
    private var switchView: UISwitch!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with setting: any SettingsKitSetting, parent: SettingsKitTableViewController) {
        self.setting = setting as? SettingsKitToggle
        
        setupCell()
        setupTitleLabel()
        setupSwitchView()
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
    
    private func setupSwitchView() {
        switchView = UISwitch()
        switchView.isOn = boolValue()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        contentView.addSubview(switchView)
        
        NSLayoutConstraint.activate([
            switchView.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -22)
        ])
    }
    
    private func boolValue() -> Bool {
        if let value = setting.value {
            switch value {
            case .bool(let bool):
                return bool
            case .userDefaults(let key, let defaultValue):
                guard let value = UserDefaults.standard.object(forKey: key) as? Bool else {
                    return defaultValue
                }
                return value
            case .callback(let getter, _):
                return getter()
            }
        }
        
        return false
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        if let value = setting.value {
            switch value {
            case .bool(_):
                break
            case .userDefaults(let key, _):
                UserDefaults.standard.set(sender.isOn, forKey: key)
            case .callback(_, let setter):
                setter(sender.isOn)
            }
        }
    }
}
