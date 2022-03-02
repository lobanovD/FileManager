//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Dmitrii Lobanov on 02.03.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        view.addSubview(settingsTableView)
        setupContstraint()
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsTableViewCell")
    }
    
    // UI elements
    lazy var settingsTableView: UITableView = {
        let settingsTableView = UITableView()
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.backgroundColor = .systemGray6
        return settingsTableView
    }()
    
    // Constraint
    func setupContstraint() {
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func reloadTableView() {
        self.reloadTableView()
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = settingsTableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
            if UserDefaults.standard.bool(forKey: "sort") == true {
                cell.textLabel?.text = "Сортировка: A-Z"
            } else {
                cell.textLabel?.text = "Сортировка: Z-A"
            }
            
            return cell
            
        } else {
            let cell = settingsTableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
            cell.textLabel?.text = "Смена пароля"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let sortVariable = UserDefaults.standard.bool(forKey: "sort")
            UserDefaults.standard.set(!sortVariable, forKey: "sort")
            self.settingsTableView.reloadData()
            
        } else if indexPath.section == 1 {
            self.settingsTableView.reloadData()
                        let passwordVC = ChangePasswordVC()
                        self.present(passwordVC, animated: true, completion: nil)
        }
    }
}
