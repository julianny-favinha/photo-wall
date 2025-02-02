//
//  CustomizeThemeViewController.swift
//  photo-wall
//
//  Created by Giovani Nascimento Pereira on 21/05/18.
//  Copyright © 2018 Giovani Nascimento Pereira. All rights reserved.
//

import UIKit

/* Controls 3 different collectionViews
 one for each customizable */

class CustomizeThemeViewController: UIViewController {
    @IBOutlet weak var layoutCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var backgroundCollectionView: UICollectionView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // Default values
    var selectedLayout: Layouts = .singleLine
    var selectedPhotoCell: Cells = .simple
    var selectedBackground: Backgrounds = .light
    var name: String?
    var creatingNewTheme: Bool = false
    
    override func viewDidLoad() {
        if name == nil {
            name = "Custom Theme \(UserDefaultsManager.getNumberOfThemes() + 1)"
            creatingNewTheme = true
        }
        titleLabel.text = name!
    }
    
    /// Save button pressed
    /// Save the new theme to the User Defaults
    /// Dismiss the screen
    @IBAction func saveButtonTouched(_ sender: Any) {
        // TODO: Get snapshot after creating preview
        //let image = preview.snapshot()!
        let image = #imageLiteral(resourceName: "ThemePlaceholder")
        let newTheme = UserTheme(
            name: name!,
            photo: self.selectedPhotoCell.rawValue,
            layout: self.selectedLayout.rawValue,
            background: self.selectedBackground.rawValue,
            image: image
        )
        UserDefaultsManager.addUserTheme(newTheme)
        
        let alert = UIAlertController(title:
            "\(self.name!)",
            message: creatingNewTheme == true ? "New theme created" : "Theme Updated",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
        if creatingNewTheme {
            // Update number of themes created
            UserDefaultsManager.updateNumberOfThemes()
        }
    }
    @IBAction func cancelButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CustomizeThemeViewController: UICollectionViewDataSource {
    /// Get the number of cells on each collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == backgroundCollectionView {
            return Backgrounds.all.count
        } else if collectionView == photoCollectionView {
            return Cells.all.count
        } else if collectionView == layoutCollectionView {
            return Layouts.all.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "customCell", for: indexPath) as? CustomizationCollectionViewCell else {
            return UICollectionViewCell()
        }
        let row = indexPath.row
        
        if collectionView == backgroundCollectionView {
            // Backgrounds
            let background = Backgrounds.all[row]
            cell.label.text = background.rawValue
            cell.imageView.image = Backgrounds.images[background]
            if background == selectedBackground {
                cell.checkmark.isHidden = false
            } else {
                cell.checkmark.isHidden = true
            }
        } else if collectionView == photoCollectionView {
            // Photo
            let photoCell = Cells.all[row]
            cell.label.text = photoCell.rawValue
            cell.imageView.image = Cells.images[photoCell]
            if photoCell == selectedPhotoCell {
                cell.checkmark.isHidden = false
            } else {
                cell.checkmark.isHidden = true
            }
        } else if collectionView == layoutCollectionView {
            // layout
            let layout = Layouts.all[row]
            cell.label.text = layout.rawValue
            cell.imageView.image = Layouts.images[layout]
            if layout == selectedLayout {
                cell.checkmark.isHidden = false
            } else {
                cell.checkmark.isHidden = true
            }
        }
        return cell
    }
}

extension CustomizeThemeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if collectionView == backgroundCollectionView {
            self.selectedBackground = Backgrounds.all[row]
            backgroundCollectionView.collectionViewLayout.invalidateLayout()
            backgroundCollectionView.reloadData()
        } else if collectionView == layoutCollectionView {
            self.selectedLayout = Layouts.all[row]
            layoutCollectionView.collectionViewLayout.invalidateLayout()
            layoutCollectionView.reloadData()
        } else if collectionView == photoCollectionView {
            self.selectedPhotoCell = Cells.all[row]
            photoCollectionView.collectionViewLayout.invalidateLayout()
            photoCollectionView.reloadData()
        }
    }
}
