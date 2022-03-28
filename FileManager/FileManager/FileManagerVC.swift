//
//  FileManagerVC.swift
//  FileManager
//
//  Created by Dmitrii Lobanov on 16.02.2022.
//

import UIKit
import PhotosUI

class FileManagerVC: UIViewController {
    
    @IBAction func addFileButton(_ sender: Any) {
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images
        
        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "File Manager"
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("someEvent"), object: nil)
        
        filesListTableView.dataSource = self
        filesListTableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        navigationItem.title = "File Manager"
        navigationItem.hidesBackButton = true
        
        view.addSubview(filesListTableView)
        setupContstraint()
        
        MyFileManager.shared.getListFiles()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.filesListTableView.reloadData()
    }
    
    @objc func reload() {
        self.filesListTableView.reloadData()
    }
    
    // UI elements
    lazy var filesListTableView: UITableView = {
        let filesListTableView = UITableView()
        filesListTableView.translatesAutoresizingMaskIntoConstraints = false
        filesListTableView.backgroundColor = .systemGray6
        return filesListTableView
    }()
    
    // Constraint
    func setupContstraint() {
        NSLayoutConstraint.activate([
            filesListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filesListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            filesListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            filesListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FileManagerVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MyFileManager.filesListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = filesListTableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        if UserDefaults.standard.bool(forKey: "sort") {
            cell.textLabel?.text = MyFileManager.filesListArray.sorted(by: < )[indexPath.row]
        } else {
            cell.textLabel?.text = MyFileManager.filesListArray.sorted(by: > )[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        MyFileManager.shared.removeFile(name: MyFileManager.filesListArray.sorted()[indexPath.row])
        
        MyFileManager.shared.getListFiles()
        
        NotificationCenter.default.post(name: Notification.Name("someEvent"), object: nil)
        
    }
}


extension FileManagerVC: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        // добавляем выбранное фото в документы и закрываем контроллер
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        
                        guard let imageData = image.jpegData(compressionQuality: 0) else { return }
                        
                        MyFileManager.shared.createFile(data: imageData)
                        
                        picker.dismiss(animated: true, completion: nil)
                        
                        MyFileManager.shared.getListFiles()
                        
                        NotificationCenter.default.post(name: Notification.Name("someEvent"), object: nil)
                    }
                }
            })
        }
    }
}
