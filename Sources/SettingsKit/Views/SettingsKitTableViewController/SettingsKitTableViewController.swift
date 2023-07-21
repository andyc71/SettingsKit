//
//  SettingsKitTableViewController.swift
//  SettingsKit
//
//  Created by Seb Vidal on 03/09/2022.
//

import UIKit

public class SettingsKitTableViewController: UITableViewController {
    var sections: [SettingsKitSection] = []
    var delegate: SettingsKitTableViewControllerDelegate?
    
    let isRoot: Bool
    
    //AC: Changed .insetGrouped to .grouped for IOS12 compatibility
    public init(sections: [SettingsKitSection], style: UITableView.Style = .grouped, isRoot: Bool = false) {
        self.isRoot = isRoot
        super.init(style: style)
        registerTableViewCellsForReuse()
        setupTableViewController()
        self.sections = sections
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerTableViewCellsForReuse() {
        tableView.register(SettingsKitGroupCell.self, forCellReuseIdentifier: "SettingsKitGroupCell")
        tableView.register(SettingsKitLabelCell.self, forCellReuseIdentifier: "SettingsKitLabelCell")
        tableView.register(SettingsKitToggleCell.self, forCellReuseIdentifier: "SettingsKitToggleCell")
        tableView.register(SettingsKitStepperCell.self, forCellReuseIdentifier: "SettingsKitStepperCell")
        tableView.register(SettingsKitTextFieldCell.self, forCellReuseIdentifier: "SettingsKitTextFieldCell")
        tableView.register(SettingsKitButtonCell.self, forCellReuseIdentifier: "SettingsKitButtonCell")
    }
    
    private func setupTableViewController() {
        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationItem.largeTitleDisplayMode = .never
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].settings.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = sections[indexPath.section].settings[indexPath.row]
        let reuseIdentifier = setting.cellReuseIdentifier()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! SettingsKitCell
        cell.setupCell(with: setting, parent: self)
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].settings[indexPath.row].cellHeight()
    }
    
    public override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let children = sections[indexPath.section].settings[indexPath.row].children else { return false }
        
        return !children.isEmpty
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = sections[indexPath.section].settings[indexPath.row]
        let viewController = SettingsKitTableViewController(sections: setting.children ?? [])
        viewController.navigationItem.title = setting.title
        
        if UIDevice.current.userInterfaceIdiom == .pad && isRoot {
            delegate?.showDetailViewController(viewController)
        } else {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
