//
//  CheckClassesTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 24/11/22.
//

import UIKit

class CheckClassesTVC: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var classesCollectionView: UICollectionView!
    var allClassList = [[String:Any]]()
    var selectedClassIndexPassing : ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.classesCollectionView.delegate = self
        self.classesCollectionView.dataSource = self
        registerCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func reloadCollectionView() -> Void {
        self.classesCollectionView.reloadData()
    }
    
    func registerCell() {
        self.classesCollectionView.register(ClassesCVC.nib, forCellWithReuseIdentifier: ClassesCVC.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.allClassList.count == 0 {
            self.classesCollectionView.setEmptyMessage(Constants.noClassesMessage.localize())
            } else {
                self.classesCollectionView.restore()
            }
        return self.allClassList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: ClassesCVC.identifier, for: indexPath) as? ClassesCVC else { fatalError("xib doesn't exist") }
        cell.classesImageView?.imageFromServerURL(urlString: self.allClassList[indexPath.row]["class_image"] as! String, PlaceHolderImage: UIImage.init(named: "AppLogoIcon")!)
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            cell.classNameLabel.text = self.allClassList[indexPath.row]["title_ar"] as? String ?? ""
            }
            else{
                cell.classNameLabel.text = self.allClassList[indexPath.row]["title_en"] as? String ?? ""
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let classID :String = self.allClassList[indexPath.row]["id"] as! String
        let classID :String = String(self.allClassList[indexPath.row]["id"] as? Int ?? 0)
            self.selectedClassIndexPassing!(classID)
            self.reloadCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: UIScreen.main.bounds.width - 80, height: 310)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
    }
    
}
