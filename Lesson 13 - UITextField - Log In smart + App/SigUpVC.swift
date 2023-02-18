//
//  ViewController.swift
//  Lesson 13 - UITextField - Log In smart + App
//
//  Created by Валентин Ремизов on 14.02.2023.
//

import UIKit

class SigUpVC: UIViewController, UITextFieldDelegate {

    private let signUpLabel = UILabel(frame: CGRect(x: 50, y: 200, width: 300, height: 50))
    private let loginTextField = UITextField(frame: CGRect(x: 50, y: 300, width: 300, height: 31))
    private let mailTextField = UITextField(frame: CGRect(x: 50, y: 350, width: 300, height: 31))
    private let phoneTextField = UITextField(frame: CGRect(x: 50, y: 400, width: 300, height: 31))
    private let enterButton = UIButton(type: .roundedRect)
    private let haveAccountButton = UIButton(frame: CGRect(x: 100, y: 550, width: 200, height: 30))

    internal override func viewDidLoad() {
        super.viewDidLoad()
//MARK: - Скрытие клавиатуры при нажатии в пустое место. Основной код прописан в extension SceneDelegate, а это мы его вызываем просто, чтоб в этом контроллере тоже работал.
        self.hideKeyboardWhenTappedAround()
        title = "Sign up"
        createSignUpLabel()
        createLoginTF()
        createMailTF()
        createPhoneTF()
        createEnterButton()
        createHaveAccountAlert()
        [loginTextField, mailTextField, phoneTextField, enterButton, haveAccountButton, signUpLabel].forEach{ view.addSubview($0) }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { nc in
            self.view.frame.origin.y = -100
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { nc in
            self.view.frame.origin.y = 0
        }
    }

//MARK: - Methods

    fileprivate func createSignUpLabel() {
        signUpLabel.text = "Sign up"
        signUpLabel.textAlignment = .center
        signUpLabel.font = signUpLabel.font.withSize(40)
    }

    fileprivate func createLoginTF() {
        loginTextField.placeholder = "Write your login"
        loginTextField.borderStyle = .roundedRect
        loginTextField.delegate = self
        //Крестик появляется чтоб очистить поле
        loginTextField.clearButtonMode = .whileEditing
        loginTextField.tag = 0
    }

    fileprivate func createMailTF() {
        mailTextField.placeholder = "Write your E-Mail"
        mailTextField.borderStyle = .roundedRect
        mailTextField.keyboardType = .emailAddress
        mailTextField.delegate = self
        mailTextField.clearButtonMode = .whileEditing
        mailTextField.tag = 1
    }

    fileprivate func createPhoneTF() {
        phoneTextField.placeholder = "Write your number phone"
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.keyboardType = .numberPad
        phoneTextField.delegate = self
        phoneTextField.clearButtonMode = .whileEditing
        phoneTextField.tag = 2
    }

    fileprivate func createEnterButton() {
        enterButton.frame = CGRect(x: 100, y: 500, width: 200, height: 40)
        enterButton.setTitle("Enter", for: .normal)
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        enterButton.backgroundColor = .systemBlue
        enterButton.layer.cornerRadius = enterButton.frame.size.height / 2.75
        enterButton.addTarget(self, action: #selector(enterButtonPressed), for: .touchUpInside)
    }

    fileprivate func createHaveAccountAlert() {
        haveAccountButton.setTitle("I have account", for: .normal)
        haveAccountButton.setTitleColor(.darkGray, for: .normal)
        haveAccountButton.addTarget(self, action: #selector(haveAccountButtonPressed), for: .touchUpInside)
    }

    @objc private func enterButtonPressed(sender: UIButton) {
        guard let nextMiniAppVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "miniAppVCID") as? MiniAppVC else { return }
        guard sender == enterButton else { return }
            navigationController?.pushViewController(nextMiniAppVC, animated: true)
    }

    @objc private func haveAccountButtonPressed(sender: UIButton) {
        guard sender == haveAccountButton else { return }
        let alertController = UIAlertController(title: "Enter in your account", message: "If you have already account, write please login and password", preferredStyle: .alert)

//MARK: - Check login and password
        let okAlertAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let textFieldOne = alertController.textFields?[0].text else { return }
            guard let textFieldTwo = alertController.textFields?[1].text else { return }
            guard let nextMiniAppVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "miniAppVCID") as? MiniAppVC else { return }
            if textFieldOne == "test" && textFieldTwo == "test" {
                self.navigationController?.pushViewController(nextMiniAppVC, animated: true)
            } else {
                let alertControllerError = UIAlertController(title: "Wrong enter log in", message: "Please write correction login and password", preferredStyle: .alert)
                let okAlertActionError = UIAlertAction(title: "OK", style: .cancel) { _ in
                    self.present(alertController, animated: true)
                }
                alertControllerError.addAction(okAlertActionError)
                self.present(alertControllerError, animated: true)
            }
        }

        let cancelAlertAction = UIAlertAction(title: "CANCEL", style: .cancel)
        alertController.addTextField { (textField) in
            textField.placeholder = "Write login"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Write password"
            textField.isSecureTextEntry = true
        }
        alertController.addAction(okAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true)
    }

//MARK: - Delegate
    //Открывает клавиатуру при нажатии на textField
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

//Этим методом мы скрываем клавиатуру при нажатии на "Ввод/Enter"
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            mailTextField.becomeFirstResponder()
        } else if textField == mailTextField {
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            phoneTextField.resignFirstResponder()
        }
        return true
    }
}

