//
//  LoginInspector.swift
//  FileManager
//
//  Created by Dmitrii Lobanov on 27.02.2022.
//

import Foundation
import UIKit
import Locksmith

class LoginInspector: LoginProtocol {
    
    static let shared = LoginInspector()
    
    let userAccount = "FileManager"
    
    // метод проверки пароля на количество символов
    func checkLenghtPassword(password: String) -> Bool {
        if password.count < 4 {
            NotificationCenter.default.post(name: Notification.Name("errorCountPassword"), object: nil)
            return false
        } else {
            return true
        }
    }
    
    // метод после ввода первого пароля
    func setFirstPassword() {
        NotificationCenter.default.post(name: Notification.Name("clearUIForSecondPassword"), object: nil)
    }
    
    // метод, сверяющий введенные пароли
    func comparePasswords(firstPassword: String, secondPassword: String) {
        if firstPassword == secondPassword {
            
            do {
                try Locksmith.saveData(data: ["password" : secondPassword], forUserAccount: userAccount)
                UserDefaults.standard.set(true, forKey: "password")
                NotificationCenter.default.post(name: Notification.Name("presentFileManager"), object: nil)
            } catch {
                print(error)
            }
            
        } else {
            NotificationCenter.default.post(name: Notification.Name("clearAllData"), object: nil)
        }
    }
    
    func checkKeychain() {
        let result = Locksmith.loadDataForUserAccount(userAccount: userAccount)
        guard let result = result else { return }
        print("Состояние KeyChain: \(result)")
    }
    
    // метод проверки существующего пароля
    func checkPassword(password: String) {
        let result = Locksmith.loadDataForUserAccount(userAccount: userAccount)
        guard let result = result else { return }
        if result["password"] as! String == password {
            NotificationCenter.default.post(name: Notification.Name("presentFileManager"), object: nil)
        } else {
            NotificationCenter.default.post(name: Notification.Name("wrongPassword"), object: nil)
        }
    }
}
