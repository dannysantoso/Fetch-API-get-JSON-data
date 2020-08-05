//
//  ProfileViewController.swift
//  dicodingSubmission
//
//  Created by danny santoso on 28/07/20.
//  Copyright © 2020 danny santoso. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var job: UILabel!
    @IBOutlet weak var nameProfile: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageProfile.layer.cornerRadius = 100
    }

    @IBAction func editBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Edit Profile", message: "Masukan nama dan job dibawah ini", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type your name Here"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Type your job Here"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let name = alert.textFields?[0].text else { return }
            guard let job = alert.textFields?[1].text else { return }
            self.nameProfile.text = name
            self.job.text = job
        }
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
    }
    
}
