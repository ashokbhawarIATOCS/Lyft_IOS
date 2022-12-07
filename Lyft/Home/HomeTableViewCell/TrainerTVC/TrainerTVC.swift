//
//  TrainerTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 22/11/22.
//

import UIKit

class TrainerTVC: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var trainerCollectionView: UICollectionView!
    var allTrainerList = [[String:Any]]()
    
    //create your closure here with data passing
    var shareButtonDataPassing : (([String]) -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        collectionViewHeightConstraint.constant = 440
        self.trainerCollectionView.delegate = self
        self.trainerCollectionView.dataSource = self
        registerCell()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadCollectionView() -> Void {
        self.trainerCollectionView.reloadData()
    }
    
    func registerCell() {
        self.trainerCollectionView.register(TrainerCVC.nib, forCellWithReuseIdentifier: TrainerCVC.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allTrainerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: TrainerCVC.identifier, for: indexPath) as? TrainerCVC else { fatalError("xib doesn't exist") }
        
        cell.trainerProfileImageView?.imageFromServerURL(urlString: self.allTrainerList[indexPath.row]["trainer_img"] as! String, PlaceHolderImage: UIImage.init(named: "AppLogoIcon")!)
        
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            cell.lblTrainerName.text = self.allTrainerList[indexPath.row]["name_ar"] as? String ?? ""
            cell.lblTrainerSpeciality.text = self.allTrainerList[indexPath.row]["rank_ar"] as? String ?? ""
            cell.lblTrainerQualification.text = self.allTrainerList[indexPath.row]["qualification_ar"] as? String ?? ""
            cell.lblTrainerExperienceDetails.text = self.allTrainerList[indexPath.row]["coach_word_ar"] as? String ?? ""
        }else{
        cell.lblTrainerName.text = self.allTrainerList[indexPath.row]["name_en"] as? String ?? ""
        cell.lblTrainerSpeciality.text = self.allTrainerList[indexPath.row]["rank_en"] as? String ?? ""
        cell.lblTrainerQualification.text = self.allTrainerList[indexPath.row]["qualification_en"] as? String ?? ""
        cell.lblTrainerExperienceDetails.text = self.allTrainerList[indexPath.row]["coach_word_en"] as? String ?? ""
        }
        cell.shareButtonPressed = {
                let facebookUrlString = self.allTrainerList[indexPath.row]["facebook"] as? String ?? "" + "\n"
                let twitterUrlString = self.allTrainerList[indexPath.row]["twitter"] as? String ?? "" + "\n"
                let instagramUrlString = self.allTrainerList[indexPath.row]["instagram"] as? String ?? "" + "\n"
                let linkedinUrlString = self.allTrainerList[indexPath.row]["linkedin"] as? String ?? "" + "\n"

                let linkToShare = [facebookUrlString ,twitterUrlString , instagramUrlString, linkedinUrlString]
            self.callReturnWithDataPassing(dataPass: linkToShare)
        }
        return cell
    }
    func callReturnWithDataPassing(dataPass:[String]){
        shareButtonDataPassing?(dataPass)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 500)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
    }
}
