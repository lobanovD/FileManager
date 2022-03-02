//
//  LoginProtocol.swift
//  FileManager
//
//  Created by Dmitrii Lobanov on 27.02.2022.
//

import Foundation

protocol LoginProtocol {
    func checkLenghtPassword(password: String) -> Bool
    func setFirstPassword()
    func comparePasswords(firstPassword: String, secondPassword: String)
    func checkPassword(password: String)
}
