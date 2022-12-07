//
//  ActivityTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/11/22.
//

import UIKit

class ActivityTVC: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var activityCollectionView: UICollectionView!
    var allActivityList = [[String:Any]]()
    var selectedActivityIndex = 0
    var selectedActivityIndexPassing : ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.activityCollectionView.delegate = self
        self.activityCollectionView.dataSource = self
        registerCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func reloadCollectionView() -> Void {
        self.activityCollectionView.reloadData()
    }
    
    func registerCell() {
        self.activityCollectionView.register(ActivityCVC.nib, forCellWithReuseIdentifier: ActivityCVC.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.allActivityList.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCVC.identifier, for: indexPath) as? ActivityCVC else { fatalError("xib doesn't exist") }
            
            if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
                cell.titleLabel.text = self.allActivityList[indexPath.row]["activity_name_ar"] as? String ?? ""
                }
                else{
                    cell.titleLabel.text = self.allActivityList[indexPath.row]["activity_name_en"] as? String ?? ""
                }
            
            if(selectedActivityIndex == indexPath.row){
                cell.titleLabel.textColor = borderColorandThemeColor
            }else{
                cell.titleLabel.textColor = .white
            }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selectedActivityIndex = indexPath.row
            self.selectedActivityIndexPassing!(indexPath.row)
            self.reloadCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
            if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
                label.text = self.allActivityList[indexPath.row]["activity_name_ar"] as? String ?? ""
            }else{
                label.text = self.allActivityList[indexPath.row]["activity_name_en"] as? String ?? ""
               
            }
                  label.sizeToFit()
                  return CGSize(width: label.frame.width + 50, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
    }
}
