//
//  KeyViewController.swift
//  LockBox
//
//  Created by mac on 5/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import LocalAuthentication

class KeyViewController: UIViewController {
    
    
    @IBOutlet weak var keyCollectionView: UICollectionView!
    
    
    let keyNumbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9","*", "0", "#"]
    let keyImages = ["fid", "done", "backspace"]
    
    fileprivate var asteriks = "" {
        didSet {
            self.keyCollectionView.reloadData()
        }
    }
    
    fileprivate var selectedNumbers = String()
    
    var isUser: Bool {
        return UserDefaults.standard.value(forKey: Constants.Keys.isUser.rawValue) != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKey()

    }
    
    //MARK: Biometrics
    
    func authenticateUser(completion: @escaping (String?) -> Void) {
        
        //context = manages the user's credentials
        let context = LAContext()
        
        //check if biometrics are enabled
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            completion("Biometrics not available")
            return
        }
        //reason for requesting biometrics
        let reason = "Use Biometrics for Authentication"
        //proceed with auth
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] (success, err) in
            
            
            if success {
                self.goToMedia()
                print("Authenticated User")
                completion(nil)
                
            } else {
                
                completion("Could Not Authenticate")
                return
            }
        }
    }
    

    //MARK: Setup
    
    func setupKey() {
        
        keyCollectionView.register(UINib(nibName: KeyHeaderCell.identifier, bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: KeyHeaderCell.identifier)
    }

}

//MARK: CollectionView

extension KeyViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? keyNumbers.count : keyImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCellOne.identifier, for: indexPath) as! KeyCellOne
            
            let number = keyNumbers[indexPath.row]
            cell.configure(with: number)
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCellTwo.identifier, for: indexPath) as! KeyCellTwo
            
            let image = keyImages[indexPath.row]
            cell.tag = indexPath.row
            cell.configure(with: image)
            
            return cell
        }
    }
    
    
    //MARK: SupplementaryView
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: KeyHeaderCell.identifier, for: indexPath) as! KeyHeaderCell
        
        cell.configureAsteriks(asteriks)
        
        return cell
    }
    
}

extension KeyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            //MARK: KeyNumbers
            guard selectedNumbers.count < 4 else {
                return
            }
            
            selectedNumbers += keyNumbers[indexPath.item]
            asteriks += "*"
            
        default:
            //MARK: KeyImages
            let cell = collectionView.cellForItem(at: indexPath) as! KeyCellTwo
            switch cell.tag {
            case 0:
                //MARK: Biometrics
                authenticateUser { [unowned self] err in
                    if let error = err {
                        self.showAlert(title: "Error", message: error)
                    }
                }
                
            case 1:
                //MARK: Keychain Authentication
                let item = KeyChainItem(account: selectedNumbers)
                switch isUser {
                case false:
                    guard selectedNumbers.count == 4 else {
                        showAlert(title: "Invalid Code", message: "Not enough digits")
                        return
                    }
    
                    item.saveKeychain(with: selectedNumbers)
                    UserDefaults.standard.setValue(true, forKey: Constants.Keys.isUser.rawValue)
                    goToMedia()
                    
                case true:
                    
                    if item.isValid {
                        goToMedia()
                    } else {
                        showAlert(title: "Wrong Code", message: "You have entered the incorrect code")
                        selectedNumbers = ""
                        asteriks = ""
                    }
                    
                }
            default:
                //MARK: Backspace
                guard !selectedNumbers.isEmpty else {
                    return
                }
                
                selectedNumbers.removeLast()
                asteriks.removeLast()
            }
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGFloat()
        
        switch Constants.isIpad {
            
        case true:
            size = view.frame.size.width / 4.6
        case false:
            size = view.frame.size.width / 4.3
        }
        
        return .init(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var cellOneInsets = UIEdgeInsets()
        var cellTwoInsets = UIEdgeInsets()

        switch Constants.isIpad {
        case true:
            cellOneInsets = UIEdgeInsets(top: 0, left: 70, bottom: 15, right: 70)
            cellTwoInsets = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 70)
        case false:
            cellOneInsets = UIEdgeInsets(top: 0, left: 35, bottom: 15, right: 35)
            cellTwoInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 35)
        }
        
        return section == 0 ? cellOneInsets : cellTwoInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    //MARK: SupplementaryView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = view.frame.height * 0.20
        return section == 0 ? CGSize(width: view.frame.width, height: height) : .zero
    }
    
    
}
