//
//  PlanPackageTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 22/11/22.
//

import UIKit

class PlanPackageTVC: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var planPackageCollectionView: UICollectionView!
    var allPlanList = [[String:Any]]()
    var buyButtonName = ""
    var buyButtonDataPassing : ((Int) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.planPackageCollectionView.delegate = self
        self.planPackageCollectionView.dataSource = self
        registerCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadCollectionView() -> Void {
        self.planPackageCollectionView.reloadData()
    }
    
    func registerCell() {
        self.planPackageCollectionView.register(PaymentPlansCVC.nib, forCellWithReuseIdentifier: PaymentPlansCVC.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allPlanList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: PaymentPlansCVC.identifier, for: indexPath) as? PaymentPlansCVC else { fatalError("xib doesn't exist") }
        
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            cell.planTitleLabel.text = self.allPlanList[indexPath.row]["title_ar"] as? String ?? ""
            
            let durationVaLue = self.allPlanList[indexPath.row]["duration"] as? String ?? ""
            if(durationVaLue == Constants.monthly){
                cell.planAmontLabel.text = "\(Constants.startingAt.localize()) OMR \(self.allPlanList[indexPath.row]["price"] ?? "")/\(Constants.monthly.localize())"
            } else if(durationVaLue == Constants.quarterly){
                cell.planAmontLabel.text = "\(Constants.startingAt.localize()) OMR \(self.allPlanList[indexPath.row]["price"] ?? "")/\(Constants.quarterly.localize())"
            }else if(durationVaLue == Constants.yearly){
                cell.planAmontLabel.text = "\(Constants.startingAt.localize()) OMR \(self.allPlanList[indexPath.row]["price"] ?? "")/\(Constants.yearly.localize())"
            }else{
                cell.planAmontLabel.text = "\(Constants.startingAt.localize()) OMR \(self.allPlanList[indexPath.row]["price"] ?? "")/\(self.allPlanList[indexPath.row]["duration"] ?? "")"
            }
            
            let descriptionArray =  self.allPlanList[indexPath.row]["description_ar"] as! NSArray
            if (descriptionArray.count == 1){
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.isHidden = true
                cell.planDescription3Label.isHidden = true
                cell.planDescription4Label.isHidden = true
                cell.tickImageView2.isHidden = true
                cell.tickImageView3.isHidden = true
                cell.tickImageView4.isHidden = true
            } else if (descriptionArray.count == 2){
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription3Label.isHidden = true
                cell.planDescription4Label.isHidden = true
                cell.tickImageView3.isHidden = true
                cell.tickImageView4.isHidden = true
            } else if (descriptionArray.count == 3){
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription3Label.text = descriptionArray[2] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription4Label.isHidden = true
                cell.tickImageView4.isHidden = true
            }else if (descriptionArray.count == 0){
                cell.planDescription1Label.text = "There is no Description"
                cell.planDescription2Label.isHidden = true
                cell.planDescription3Label.isHidden = true
                cell.planDescription4Label.isHidden = true
                cell.tickImageView2.isHidden = true
                cell.tickImageView3.isHidden = true
                cell.tickImageView4.isHidden = true
            }else{
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription3Label.text = descriptionArray[2] as? String
                cell.planDescription4Label.text = descriptionArray[3] as? String
            }
        }else{
        cell.planTitleLabel.text = self.allPlanList[indexPath.row]["title_en"] as? String ?? ""
        cell.planAmontLabel.text = "Starting at OMR. \(self.allPlanList[indexPath.row]["price"] ?? "")/\(self.allPlanList[indexPath.row]["duration"] ?? "")"
            
            let descriptionArray =  self.allPlanList[indexPath.row]["description_en"] as! NSArray
            
            if (descriptionArray.count == 1){
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.isHidden = true
                cell.planDescription3Label.isHidden = true
                cell.planDescription4Label.isHidden = true
                cell.tickImageView2.isHidden = true
                cell.tickImageView3.isHidden = true
                cell.tickImageView4.isHidden = true
                
            } else if (descriptionArray.count == 2){
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription3Label.isHidden = true
                cell.planDescription4Label.isHidden = true
                cell.tickImageView3.isHidden = true
                cell.tickImageView4.isHidden = true
            } else if (descriptionArray.count == 3){
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription3Label.text = descriptionArray[2] as? String
                cell.planDescription4Label.isHidden = true
                cell.tickImageView4.isHidden = true
            }else if (descriptionArray.count == 0){
                cell.planDescription1Label.text = "There is no Description"
                cell.planDescription2Label.isHidden = true
                cell.planDescription3Label.isHidden = true
                cell.planDescription4Label.isHidden = true
                cell.tickImageView2.isHidden = true
                cell.tickImageView3.isHidden = true
                cell.tickImageView4.isHidden = true
            }else{
                cell.planDescription1Label.text = descriptionArray[0] as? String
                cell.planDescription2Label.text = descriptionArray[1] as? String
                cell.planDescription3Label.text = descriptionArray[2] as? String
                cell.planDescription4Label.text = descriptionArray[3] as? String
            }
        }
        cell.planButton.setTitle(buyButtonName, for: .normal)
        cell.planButtonPressed = {
           //code for buy plan
            self.buyButtonDataPassing?(indexPath.row)
        }
        cell.planView.layer.borderWidth = 8
        cell.planView.layer.borderColor = borderColorandThemeColor.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 50, height: 400)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
    }
}
