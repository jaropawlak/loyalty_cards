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
        let alert = UIAlertController(title: "Dodaj kartę", message: "Wybierz Źródło", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Aparat", style: .default) { action in
            self.selectImageFrom(.camera)
        }
        let library = UIAlertAction(title: "Biblioteka", style: .default) { action in
            self.selectImageFrom(.photoLibrary)
        }
        let cancel = UIAlertAction(title: "Anuluj", style: .cancel, handler: nil)
        
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
    @IBAction func itemsAction(_ sender: Any) {
        let alert = UIAlertController(title: "Więcej", message: "Chcesz więcej?", preferredStyle: .actionSheet)
        let moreApps = UIAlertAction(title: "Inne apki", style: .default) { action in
            UIApplication.shared.open(URL(string: "itms-apps://apps.apple.com/developer/id597872981")!, options: [:])
        }
        let github = UIAlertAction(title: "Ten projekt na githubie", style: .default) { action in
          UIApplication.shared.open( URL(string: "https://github.com/jaropawlak/loyalty_cards")!, options: [:])
        }
        let twitter = UIAlertAction(title: "Kontakt ze mną", style: .default) { action in
           UIApplication.shared.open( URL(string: "https://twitter.com/jaroslawp")!, options: [:])
        }
        let cancel = UIAlertAction(title: "Eeeee nie chcę", style: .cancel, handler: nil)
      
        alert.addAction(moreApps)
        alert.addAction(github)
        alert.addAction(twitter)
        alert.addAction(cancel)
              
        present(alert, animated: true)
    }
}
