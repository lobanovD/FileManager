//
//  LoginViewController.swift
//  FileManager
//
//  Created by Dmitrii Lobanov on 27.02.2022.
//

import UIKit
import Locksmith

class LoginViewController: UIViewController {
    
    var firstPassword: String?
    var secondPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        временно удаление ключа (для удаления ключа, раскомментировать, запустить приложение, закомментировать, удалить приложение с устройства и установить заново
//
//                        do {
//                            try Locksmith.deleteDataForUserAccount(userAccount: "FileManager")
//                        } catch {
//                           print(error)
//                        }
        
        view.addSubview(passwordTF)
        view.addSubview(passwordButton)
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.errorCountPassword), name: NSNotification.Name("errorCountPassword"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearUIForSecondPassword), name: NSNotification.Name("clearUIForSecondPassword"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearAllData), name: NSNotification.Name("clearAllData"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentFileManager), name: NSNotification.Name("presentFileManager"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.wrongPassword), name: NSNotification.Name("wrongPassword"), object: nil)
        
        // создание параметров настроек в UserDefaults при первом запуске приложения
        if UserDefaults.standard.value(forKey: "FirstRun") == nil {
            UserDefaults.standard.set(true, forKey: "sort")
            UserDefaults.standard.set("not", forKey: "FirstRun")
        }
        

       
    }
    
    // MARK: UI elements
    
    private lazy var passwordTF: MyTextField = {
        let passwordTF = MyTextField()
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        passwordTF.placeholder = "Введите пароль"
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
        
        
        let passwordIsSet = UserDefaults.standard.bool(forKey: "password")
        if passwordIsSet == true {
            passwordButton.setTitle("Введите пароль", for: .normal)
            passwordButton.addTarget(self, action: #selector(insertPasswordButtonAction), for: .touchUpInside)
        } else {
            passwordButton.setTitle("Создать пароль", for: .normal)
            passwordButton.addTarget(self, action: #selector(firstPasswordButtonAction), for: .touchUpInside)
        }
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
    
    // первичный метод кнопки
    @objc func firstPasswordButtonAction() {
        
        print("1. \(firstPassword), \(secondPassword)")
        LoginInspector.shared.checkKeychain()
        
        guard let passwordText = self.passwordTF.text else { return }
        let checkLenghtPassword = LoginInspector.shared.checkLenghtPassword(password: passwordText)
        if checkLenghtPassword {
            LoginInspector.shared.setFirstPassword()
        }
        
        print("2. \(firstPassword), \(secondPassword)")
        LoginInspector.shared.checkKeychain()
        
    }
    
    // Алерт при ошибке в количестве символов
    @objc func errorCountPassword() {
        let alertVC = UIAlertController(title: "Ошибка", message: "Минимальная длина пароля 4 символа", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
        
        print("3. \(firstPassword), \(secondPassword)")
        LoginInspector.shared.checkKeychain()
        
    }
    
    // метод сброса интерфейса для ввода пароля повторно
    @objc func clearUIForSecondPassword() {
        firstPassword = passwordTF.text
        passwordTF.text?.removeAll()
        passwordButton.setTitle("Повторите пароль", for: .normal)
        passwordButton.removeTarget(self, action: #selector(firstPasswordButtonAction), for: .touchUpInside)
        passwordButton.addTarget(self, action: #selector(comparePasswords), for: .touchUpInside)
        print("4. \(firstPassword), \(secondPassword)")
        LoginInspector.shared.checkKeychain()
    }
    
    // сверка паролей
    @objc func comparePasswords() {
        secondPassword = passwordTF.text
        guard let firstPassword = firstPassword, let secondPassword = secondPassword else { return }
        let checkLenghtPassword = LoginInspector.shared.checkLenghtPassword(password: secondPassword)
        if checkLenghtPassword {
            LoginInspector.shared.comparePasswords(firstPassword: firstPassword, secondPassword: secondPassword)
        }
        print("5. \(firstPassword), \(secondPassword)")
        LoginInspector.shared.checkKeychain()
    }
    
    // сброс при вводе неверного повторного пароля
    @objc func clearAllData() {
        let alertVC = UIAlertController(title: "Ошибка", message: "Пароли не совпадают!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
        firstPassword = nil
        secondPassword = nil
        passwordButton.removeTarget(self, action: #selector(comparePasswords), for: .touchUpInside)
        passwordButton.addTarget(self, action: #selector(firstPasswordButtonAction), for: .touchUpInside)
        passwordButton.setTitle("Создать пароль", for: .normal)
        passwordTF.text?.removeAll()
        print("6. \(firstPassword), \(secondPassword)")
        LoginInspector.shared.checkKeychain()
    }
    
    //  метод перехода на экран FileManager
    @objc func presentFileManager() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbar = storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        tabbar.modalPresentationStyle = .fullScreen
        self.present(tabbar, animated: false, completion: nil)
        print("7. \(firstPassword), \(secondPassword)")
        LoginInspector.shared.checkKeychain()
    }
    
    //  метод проверки существующего пароля
    @objc func insertPasswordButtonAction() {
        guard let password = passwordTF.text else { return }
        LoginInspector.shared.checkPassword(password: password)
        print("8. \(firstPassword), \(secondPassword)")
        LoginInspector.shared.checkKeychain()
    }
    
    // Алерт при ошибке в пароле
    @objc func wrongPassword() {
        let alertVC = UIAlertController(title: "Ошибка", message: "Пароль неверный", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
        passwordTF.text?.removeAll()
        print("9. \(firstPassword), \(secondPassword)")
        LoginInspector.shared.checkKeychain()
    }
}
