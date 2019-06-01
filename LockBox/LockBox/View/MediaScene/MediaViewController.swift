//
//  MediaViewController.swift
//  LockBox
//
//  Created by mac on 5/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController {

    @IBOutlet weak var mediaCollectionView: UICollectionView!
    
    let viewModel = ViewModel()
    let imageController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMedia()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getContent()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        present(imageController, animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
        //TODO: Sort Action Sheet Alert
        
    }
    
    
    func setupMedia() {
        
        imageController.sourceType = .photoLibrary
        imageController.mediaTypes = [Constants.Keys.publicImage.rawValue, Constants.Keys.publicMovie.rawValue]
        
        imageController.delegate = self
        viewModel.delegate = self
        
    }
    
}

//MARK: CollectionView

extension MediaViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionCell.identifier, for: indexPath) as! MediaCollectionCell
        
        let content = viewModel.content[indexPath.row]
        cell.configure(with: content)
        
        return cell
    }
}

extension MediaViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //TODO: Go To ContentVC
        viewModel.currentContent = viewModel.content[indexPath.row]
        let ImageVC = storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        ImageVC.viewModel = viewModel
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(ImageVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width / 3.05
        let height = self.view.frame.height / 6
        
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

//MARK: UIImagePickerController

extension MediaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {return}
        let isVideo = mediaType == Constants.Keys.publicMovie.rawValue
        
        switch isVideo {
        case true:
            guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
                let data = try? Data(contentsOf: url) else {return}
                let dateTime = Date().dateTime
            
            FileService.saveWithFM(data, isVideo: true)
            core.save(path: String(data.hashValue) + ".mov", isVideo: true, dateTime: dateTime)
            
            
        case false:
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
                let data = image.pngData() else {return}
            
            let dateTime = Date().dateTime
            
            FileService.saveWithFM(data, isVideo: false)
            core.save(path: String(data.hashValue), isVideo: false, dateTime: dateTime)
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}


//MARK: ViewModelDelegate
extension MediaViewController: ViewModelDelegate {
    
    func update() {
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
            print("Reloaded Media Collection")
        }
    }
}
