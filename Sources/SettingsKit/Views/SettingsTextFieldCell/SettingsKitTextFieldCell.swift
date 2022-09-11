//
//  SettingsKitTextFieldCell.swift
//  SettingsKit
//
//  Created by Seb Vidal on 29/08/2022.
//

import UIKit

class SettingsKitTextFieldCell: UITableViewCell, UITextFieldDelegate, SettingsKitCell {
    private var setting: SettingsKitTextField!
    
    private var titleLabel: UILabel!
    private var textView: UITextField!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with setting: any SettingsKitSetting, parent: SettingsKitTableViewController) {
        self.setting = setting as? SettingsKitTextField
        
        setupCell()
        setupTitleLabel()
        setupTextField()
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
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    private func setupTextField() {
        textView = UITextField()
        textView.delegate = self
        textView.text = stringValue()
        textView.returnKeyType = .done
        textView.textAlignment = .right
        textView.textColor = .secondaryLabel
        textView.keyboardType = setting.type
        textView.font = .systemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.centerYAnchor.constraint(equalTo: centerYAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            textView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16)
        ])
    }
    
    private func stringValue() -> String? {
        if let value = setting.value {
            switch value {
            case .string(let string):
                return string
            case .userDefaults(let key):
                return UserDefaults.standard.string(forKey: key)
            }
        }
        
        return nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if case let .userDefaults(key) = setting.value {
            UserDefaults.standard.set(textField.text, forKey: key)
        }
    }
}
