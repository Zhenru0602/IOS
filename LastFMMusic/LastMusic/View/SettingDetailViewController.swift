//
//  SettingDetailViewController.swift
//  LastMusic
//
//  Created by Zhenru on 5/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class SettingDetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var limitSlider: UISlider!
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let newLimit = Int(sender.value)
        limitLabel.text = "Limit: \(newLimit)"
    }
    
    @IBAction func changeClicked(_ sender: UIButton) {
        saveContent()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // Init the View
    func setUpView(){
        let curName = UserSetting.getName()
        let curLimit = UserSetting.getLimit()
        nameTextField.placeholder = curName
        limitLabel.text = "Limit: \(curLimit)"
    }
    
    //Save Content to User Default
    func saveContent(){
        guard let newName =  nameTextField.text else {
            return
        }
        
        let filterText = String(newName.filter { !" \n\t\r".contains($0) })
        if !filterText.isEmpty{
            UserSetting.saveName(name: newName)
        }
        
        let newLimit = Int(limitSlider.value)
        if newLimit > 0{
            UserSetting.saveLimit(limit: newLimit)
        }
    }
    
    

}
