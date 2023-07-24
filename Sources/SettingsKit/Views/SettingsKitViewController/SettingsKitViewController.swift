//
//  SettingsKitViewController.swift
//  SettingsKit
//
//  Created by Seb Vidal on 04/09/2022.
//

import UIKit

open class SettingsKitViewController: UISplitViewController, UISplitViewControllerDelegate, SettingsKitTableViewControllerDelegate {
    
    override public var navigationItem: UINavigationItem {
        return settingsViewController.navigationItem
    }
    
    override public var navigationController: UINavigationController? {
        return mainViewController
    }
    
    override public var title: String? {
        get {
            return settingsViewController.title
        } set {
            settingsViewController.title = newValue
        }
    }
    
    private var sections: [SettingsKitSection]
    private var settingsViewController: SettingsKitTableViewController!
    private var mainViewController: UINavigationController!
    
    public init(sections: [SettingsKitSection]) {
        self.sections = sections
        if #available(iOS 14.0, *) {
            super.init(style: .doubleColumn)
        } else {
            super.init(nibName: nil, bundle: nil)
        }
        setupSplitViewController()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSplitViewController() {
        settingsViewController = SettingsKitTableViewController(sections: sections, isRoot: true)
        settingsViewController.delegate = self
        
        mainViewController = UINavigationController(rootViewController: settingsViewController)
        
        
        let detailViewController: UIViewController
        if let setting = sections.first?.settings.first {
            detailViewController = SettingsKitTableViewController(sections: setting.children ?? [])
            detailViewController.navigationItem.title = setting.title
            //detailViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            //detailViewController.navigationItem.leftItemsSupplementBackButton = true
        }
        else {
            detailViewController = UITableViewController(style: .grouped)
        }

        if #available(iOS 14.0, *) {
            setViewController(mainViewController, for: .primary)
            setViewController(detailViewController, for: .secondary)
        } else {
            self.viewControllers = [mainViewController, UINavigationController(rootViewController: detailViewController)]
            self.preferredDisplayMode = .oneBesideSecondary
        }
        
        //presentsWithGesture = false
        delegate = self
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @available(iOS 14.0, *)
    public func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
    
    func showDetailViewController(_ viewController: UIViewController) {
        if #available(iOS 14.0, *) {
            setViewController(nil, for: .secondary)
            setViewController(viewController, for: .secondary)
        } else {
            let detailNavigationController = UINavigationController(rootViewController: viewController)
            super.showDetailViewController(detailNavigationController, sender: nil)
        }
    }
}
