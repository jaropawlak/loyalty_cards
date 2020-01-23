//
//  ViewController.swift
//  loyaltycards
//
//  Created by Jarosław Pawlak on 18/01/2020.
//  Copyright © 2020 MAJATECH Jarosław Pawlak. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var data: DataManager!
    var imgUrl: URL!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = data.getFullImage(for: imgUrl)
    }

    func setup(dataManager:DataManager, imageUrl: URL) {
        data = dataManager
        imgUrl = imageUrl
    }
    @IBAction func deleteImage(_ sender: Any) {
        data.deleteImage(at: imgUrl)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var imageView: UIImageView!
}

