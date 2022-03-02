//
//  ChangePasswordVC.swift
//  FileManager
//
//  Created by Dmitrii Lobanov on 03.03.2022.
//

import UIKit
import Locksmith

class ChangePasswordVC: UIViewController {
    
    let userAccount = "FileManager"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        view.addSubview(passwordTF)
        view.addSubview(passwordButton)
        setupConstraints()
        
    }
    
    // MARK: UI elements
    
    private lazy var passwordTF: MyTextField = {
        let passwordTF = MyTextField()
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        passwordTF.placeholder = "Введите новый пароль"
        passwordTF.backgroundColor = .systemGray6
        passwordTF.layer.cornerRadius = 10
        passwordTF.textInsets.right = 6
        passwordTF.textInsets.left = 6
        passwordTF.isSecureTextEntry = true
        return passwordTF
    }()
    
    private lazy var passwordButton: UIButton = {
        let passwordButton = UIButton()
        passwordButton.translatesAutoresizingMaskIntoConstraints = false
        passwordButton.backgroundColor = .systemBlue
        passwordButton.layer.cornerRadius = 10
        passwordButton.setTitle("Сохранить пароль", for: .normal)
        passwordButton.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        return passwordButton
    }()
    
    // MARK: Actions
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTF.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTF.widthAnchor.constraint(equalToConstant: CGFloat(view.bounds.width) / 2),
            passwordTF.heightAnchor.constraint(equalToConstant: 40),
            
            passwordButton.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 16),
            passwordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordButton.widthAnchor.constraint(equalTo: passwordTF.widthAnchor),
            passwordButton.heightAnchor.constraint(equalTo: passwordTF.heightAnchor)
        ])
    }
    
    @objc func changePassword() {
        guard let newPassword = self.passwordTF.text else { return }
        if newPassword.count < 4 {
            let alertVC = UIAlertController(title: "Ошибка", message: "Минимальная длина пароля 4 символа", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alertVC.addAction(alertAction)
            self.present(alertVC, animated: true, completion: nil)
        } else {
            do {
                try Locksmith.updateData(data: ["password" : newPassword], forUserAccount: userAccount)
              
                let alertVC = UIAlertController(title: "Успешно", message: "Пароль изменен!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertVC.addAction(alertAction)
                self.present(alertVC, animated: true, completion: nil)
                
            } catch {
                print(error)
            }
        }
    }
}
