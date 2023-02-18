//
//  miniAppVC.swift
//  Lesson 13 - UITextField - Log In smart + App
//
//  Created by Валентин Ремизов on 14.02.2023.
//

import UIKit

class MiniAppVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private let photoImageView = UIImageView(frame: CGRect(x: 150, y: 100, width: 100, height: 100))
    private let photoImage = UIImage(named: "Selfie")
    private let photoSC = UISegmentedControl(items: ["Show photo", "Hide photo"])
    private let colorBackgroundTF = UITextField(frame: CGRect(x: 50, y: 300, width: 300, height: 31))
    private let colorBackgroundPicker = UIPickerView()
    private let colorArray = ["White", "Black", "Green", "Yellow", "Blue", "Gray"]
    private let positionLabel = UILabel(frame: CGRect(x: 50, y: 350, width: 300, height: 35))
    private let positionPhotoSlider = UISlider(frame: CGRect(x: 50, y: 400, width: 300, height: 30))
    private let interectedPositionLabel = UILabel(frame: CGRect(x: 50, y: 450, width: 250, height: 35))
    private let interectedPositionSwitch = UISwitch(frame: CGRect(x: 300, y: 450, width: 10, height: 10))

    internal override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        createPhoto()
        createColorBackground()
        createPositionImage()
        createInterectedPositionSlider()

        [photoImageView, photoSC, colorBackgroundTF, positionPhotoSlider,
         positionLabel, interectedPositionLabel,
         interectedPositionSwitch].forEach { view.addSubview($0) }
    }

//MARK: - Methods
    fileprivate func createPhoto() {
        photoImageView.image = photoImage
        photoImageView.contentMode = .scaleAspectFill
        photoSC.frame = CGRect(x: 50, y: 250, width: 300, height: 35)
        photoSC.selectedSegmentIndex = 0
        photoSC.addTarget(self, action: #selector(photoSCChangeValue),
                          for: .valueChanged)
    }

    fileprivate func createColorBackground() {
        colorBackgroundTF.inputView = colorBackgroundPicker
        colorBackgroundTF.inputAccessoryView = toolBarForColorBackground()
        colorBackgroundTF.placeholder = "Choose color for background"
        colorBackgroundTF.borderStyle = .roundedRect
        colorBackgroundPicker.delegate = self
        colorBackgroundPicker.delegate = self
    }

    fileprivate func createPositionImage() {
        positionLabel.text = "You can move left or right photo from top"
        positionLabel.textAlignment = .center
        positionLabel.adjustsFontSizeToFitWidth = true
        positionPhotoSlider.minimumValue = 0
        positionPhotoSlider.maximumValue = Float(UIScreen.main.bounds.width - 100)
        positionPhotoSlider.minimumValueImage = UIImage(systemName: "minus.circle.fill")
        positionPhotoSlider.maximumValueImage = UIImage(systemName: "plus.circle.fill")
        positionPhotoSlider.addTarget(self,
                                      action: #selector(photoSliderChangeValue),
                                      for: .valueChanged)
    }

    fileprivate func createInterectedPositionSlider() {
        interectedPositionLabel.text = "Do you want block change position?"
        interectedPositionLabel.adjustsFontSizeToFitWidth = true
        interectedPositionSwitch.isOn = false
        interectedPositionSwitch.addTarget(self,
                                           action: #selector(interectedSwtichChangeValue),
                                           for: .valueChanged)
    }

    @objc private func photoSCChangeValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: photoImageView.isHidden = false
        case 1: photoImageView.isHidden = true
        default: return
        }
    }

    @objc private func photoSliderChangeValue(slider: UISlider) {
        let positionSlider = slider.value
        photoImageView.frame = CGRect(x: Int(positionSlider), y: 100, width: 100, height: 100)
    }

    @objc private func interectedSwtichChangeValue() {
        if interectedPositionSwitch.isOn {
            positionPhotoSlider.isUserInteractionEnabled = false
            positionPhotoSlider.isEnabled = false
        } else {
            positionPhotoSlider.isUserInteractionEnabled = true
            positionPhotoSlider.isEnabled = true
        }
    }

}

extension MiniAppVC {
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    internal func pickerView(_ pickerView: UIPickerView,
                             numberOfRowsInComponent component: Int) -> Int {
        return colorArray.count
    }

    internal func pickerView(_ pickerView: UIPickerView,
                             titleForRow row: Int,
                             forComponent component: Int) -> String? {
        return colorArray[row]
    }

    internal func pickerView(_ pickerView: UIPickerView,
                             didSelectRow row: Int,
                             inComponent component: Int) {
        switch row {
        case 0: view.backgroundColor = .white
        case 1: view.backgroundColor = .black
        case 2: view.backgroundColor = .green
        case 3: view.backgroundColor = .yellow
        case 4: view.backgroundColor = .blue
        case 5: view.backgroundColor = .gray
        default: view.backgroundColor = .orange
        }
        colorBackgroundTF.text = colorArray[row]
    }

    private func toolBarForColorBackground() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        let cancelButton = UIBarButtonItem(title: "Cancel",
                                           style: .plain,
                                           target: self,
                                           action: #selector(cancelTBPressed))
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(doneTBPressed))
        toolBar.setItems([cancelButton, doneButton], animated: true)
        return toolBar
    }

    @objc private func doneTBPressed() {
        colorBackgroundTF.resignFirstResponder()
    }

    @objc private func cancelTBPressed(sender: UITextField) {
        colorBackgroundTF.text = nil
        view.backgroundColor = .white
        colorBackgroundTF.resignFirstResponder()
    }
}
