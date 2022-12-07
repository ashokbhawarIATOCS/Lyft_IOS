//
//  ImageTVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 19/11/22.
//

import UIKit

class ImageTVC: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    var sliderDictonaryObject = [[String:Any]]()
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    
    var buyButtonDataHandlingOnPress : ((String, String) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        imagePageControl.hidesForSinglePage = true
        registerCell()
    }
    
    @IBAction func pageControlAction(_ sender: UIPageControl) {
        
        let page: Int? = sender.currentPage
            var frame: CGRect = self.imageCollectionView.frame
            frame.origin.x = frame.size.width * CGFloat(page ?? 0)
            frame.origin.y = 0
            self.imageCollectionView.scrollRectToVisible(frame, animated: true)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadCollectionView() -> Void {
        imagePageControl.numberOfPages = sliderDictonaryObject.count
        self.imageCollectionView.reloadData()
    }
    
    func registerCell() {
        self.imageCollectionView.register(ImagePageViewCVC.nib, forCellWithReuseIdentifier: ImagePageViewCVC.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderDictonaryObject.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: ImagePageViewCVC.identifier, for: indexPath) as? ImagePageViewCVC else { fatalError("xib doesn't exist") }
        cell.scrollListImageView?.imageFromServerURL(urlString: self.sliderDictonaryObject[indexPath.row]["slider_image"] as! String , PlaceHolderImage: UIImage.init(named: "AppLogoIcon")!)
        
        if UserDefaults.standard.value(forKey: klanguage) as? String == "ar"{
            cell.titleLabel.text = self.sliderDictonaryObject[indexPath.row]["title_ar"] as? String
            cell.boldTitleLabel.text = self.sliderDictonaryObject[indexPath.row]["bold_text_ar"] as? String
            cell.bottomTextLabel.text = self.sliderDictonaryObject[indexPath.row]["text_ar"] as? String
            if((self.sliderDictonaryObject[indexPath.row]["button_text_ar"] as? String ) != nil){
                if((self.sliderDictonaryObject[indexPath.row]["button_text_ar"] as? String ) == ""){
                    cell.buyNowButton.isHidden = true
                }else{
                    cell.buyNowButton.setTitle(self.sliderDictonaryObject[indexPath.row]["button_text_ar"] as? String, for: .normal)
                }
//                cell.buyNowButton.setTitle(self.sliderDictonaryObject[indexPath.row]["button_text_ar"] as? String, for: .normal)
            }else{
                cell.buyNowButton.isHidden = true
            }
        }else{
            cell.titleLabel.text =  self.sliderDictonaryObject[indexPath.row]["title_en"] as? String ?? ""

            cell.boldTitleLabel.text = self.sliderDictonaryObject[indexPath.row]["bold_text_en"] as? String
            cell.bottomTextLabel.text = self.sliderDictonaryObject[indexPath.row]["text_en"] as? String
            if((self.sliderDictonaryObject[indexPath.row]["button_text_en"] as? String ) != nil){
                if((self.sliderDictonaryObject[indexPath.row]["button_text_en"] as? String ) == ""){
                    cell.buyNowButton.isHidden = true
                }else{
                    cell.buyNowButton.setTitle(self.sliderDictonaryObject[indexPath.row]["button_text_en"] as? String, for: .normal)
                }
            }else{
                cell.buyNowButton.isHidden = true
            }
            
        }
        cell.planButtonPressed = {
           //code for buy plan
            self.buyButtonDataHandlingOnPress?(self.sliderDictonaryObject[indexPath.row]["button_type"] as? String ?? "", self.sliderDictonaryObject[indexPath.row]["button_url"] as? String ?? "")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.imagePageControl.currentPage = indexPath.section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 440)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2

        imagePageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    
    
}
