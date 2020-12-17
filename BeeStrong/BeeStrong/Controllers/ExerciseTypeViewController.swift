//
//  ExerciseTypeViewController.swift
//  BeeStrong
//
//  Created by Benjamin Staugaard on 16/12/2020.
//

import UIKit

class ExerciseTypeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    private let model = ["A", "D", "C", "B"]
    var exerciseTypeManager = ExerciseTypeManager()
    var exerciseTypes = [Character: [ExerciseType]]()
    
    @IBOutlet weak var exerciseTypeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseTypeCollectionView.delegate = self
        exerciseTypeCollectionView.dataSource = self
        exerciseTypeCollectionView.allowsMultipleSelection = true
        reloadData()
    }
    
    func reloadData() {
        exerciseTypes.removeAll()
        for et in exerciseTypeManager.getAllExerciseTypes()! {
            if let first = et.title?.uppercased().first {
                if exerciseTypes[first] != nil {
                    exerciseTypes[first]?.append(et)
                } else {
                    exerciseTypes[first] = [et]
                }
            }
        }
        exerciseTypeCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return alphabet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exerciseTypes[alphabet[section].uppercased().first!]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseTypeCell", for: indexPath) as! ExerciseTypeCollectionViewCell
        cell.layer.borderColor = UIColor.systemGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        let et = indexPathToExerciseType(indexPath: indexPath)
        cell.title.text = et?.title
        cell.bodyPart.text = et?.bodyPart
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? ExerciesTypeSectionHeader {
            sectionHeader.sectionHeaderlabel.text = alphabet[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let et = indexPathToExerciseType(indexPath: indexPath)
        let titleSize = et?.title?.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 19)])
        let bodyPartSize = et?.bodyPart?.size(withAttributes: [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 15)])
        return CGSize(width: 40 + max(titleSize!.width, bodyPartSize!.width), height: 70)
    }
    
    func indexPathToExerciseType(indexPath: IndexPath) -> ExerciseType? {
        return exerciseTypes[alphabet[indexPath.section].uppercased().first!]?[indexPath.row]
    }
    
    @IBAction func onAddExerciseType(_ sender: UIButton) {
        let inputAlert = UIAlertController(title: "Add ExerciseType", message: nil, preferredStyle: .alert)
        inputAlert.addTextField { textfield in
            textfield.placeholder = "Title"
        }
        inputAlert.addTextField { textfield in
            textfield.placeholder = "BodyPart"
        }
        inputAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak inputAlert, weak self] (action: UIAlertAction) in
            let title = inputAlert?.textFields![0].text
            let bodyPart = inputAlert?.textFields![1].text
            if !title!.isEmpty && !bodyPart!.isEmpty {
                self?.exerciseTypeManager.add(title: title!, bodyPart: bodyPart!)
                self!.reloadData()
            } else {
                // Do something else if the input is invalid.
            }
        }))
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(inputAlert, animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: UIBarButtonItem) {
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
