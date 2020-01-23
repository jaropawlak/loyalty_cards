//
//  MainCollectionViewController.swift
//  loyaltycards
//
//  Created by Jarosław Pawlak on 18/01/2020.
//  Copyright © 2020 MAJATECH Jarosław Pawlak. All rights reserved.
//

import Foundation
import UIKit

class MainCollectionViewController : UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    var data: DataManager!
    var items: [URL]?
    override func viewDidLoad() {
        super.viewDidLoad()
        data = DataManager()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items = data.getFileNames()
        collectionView.reloadData()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnail", for: indexPath) as! ThumbnailCell
        item.thumbnailView.image = data.getThumbnail(for: items![indexPath.row])
        return item
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? DetailViewController {
            target.setup(dataManager: data, imageUrl: items![ collectionView.indexPathsForSelectedItems![0].row])
        }
    }
    @IBAction func addItem(_ sender: Any) {
        let alert = UIAlertController(title: "Add item", message: "Select source", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { action in
            self.selectImageFrom(.camera)
        }
        let library = UIAlertAction(title: "Library", style: .default) { action in
            self.selectImageFrom(.photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    func selectImageFrom(_ source: UIImagePickerController.SourceType){
        var source = source
        
        if  !UIImagePickerController.isSourceTypeAvailable(.camera) {
            source = .photoLibrary
        }
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        data.addNewImage(selectedImage)
        items = data.getFileNames()
        self.collectionView.reloadData()
    }
}
