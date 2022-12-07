//
//  CountryCodeListVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.
import UIKit

@objc public protocol CountryPickerTableViewDelegate: AnyObject {
    func didSelectRowSelectedValue(didSelectCountryWithName name: String,
                                   code: String,
                                   dialCode: String)
}

class CountryCodeListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var countryCodeTableView: UITableView!
    var selectedCountry : String!
    var selectedCountryDialCode : String!
    
    weak var myDelegate: CountryPickerTableViewDelegate?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
        // Code you want to be delayed
        self.customViewStyleMethod()
        //        }
    }
    
    //function for setup the design of the view.
    func customViewStyleMethod()
    {
        //register cell nib
        self.countryCodeTableView.register(UINib(nibName: "CountryListTableViewCell", bundle: nil), forCellReuseIdentifier: countryCell)
        
        debugPrint("CountryCode", countryCode.count)
        debugPrint("CountrydialCode", counrtyDialCode.count)
        debugPrint("Countryname", countryName.count)
        debugPrint("selectedCountry", selectedCountry!)
        
        if let index = countryCode.firstIndex(where: {$0 == selectedCountry!})
        {
            self.countryCodeTableView.selectRow(at: IndexPath(item: index, section: 0), animated: true, scrollPosition:.middle)
            _ = self.countryCodeTableView.cellForRow(at: IndexPath(item: index, section: 0))
            
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //Table view delegate method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: countryCell, for: indexPath) as! CountryListTableViewCell
        cell.selectionStyle = .none
        cell.countryCodeLabel.text = countryCode[indexPath.row]
        cell.countryDialCodeLabel.text = counrtyDialCode[indexPath.row]
        cell.countryNameLabel.text = countryName[indexPath.row]
        
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 61.0
    }
    //Add header of Table view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame: CGRect = tableView.frame
        let customHeader = UIView()
        customHeader.backgroundColor = UIColor.white
        //        customHeader.backgroundColor = UIColor.red
        let headertext: UILabel = UILabel(frame: CGRect(x:15, y:0, width:frame.width - 55, height:40))
        headertext.textColor = headerTextColorCode
        
        headertext.text = "Select Country Code"
        //        headertext.font = headertext.font.withSize(20)
        headertext.font = globalBtnFont
        
        
        var headerCloseButton: UIButton = UIButton()
        
        
//        if UIDevice.isiPhoneX() {
//            headerCloseButton = UIButton(frame: CGRect(x:headertext.frame.width - 35, y:0, width:40, height:40))
//        }
//        else
//        {
//            if UIScreen.main.screenType == .iPhone5 {
//                headerCloseButton = UIButton(frame: CGRect(x:self.view.frame.size.width - 45, y:0, width:40, height:40))
//            }else
//            {
//                headerCloseButton = UIButton(frame: CGRect(x:self.view.frame.size.width - 45, y:0, width:40, height:40))
//            }
//        }
//
         headerCloseButton = UIButton(frame: CGRect(x:self.view.frame.size.width - 50, y:0, width:40, height:40))
        headerCloseButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 0)
        
        let img = UIImage(named: "Close")
        headerCloseButton.setImage(img, for: .normal)
        headerCloseButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        
        customHeader.addSubview(headertext)
        customHeader.addSubview(headerCloseButton)
        
        return customHeader
    }
    
    @objc func closeButtonAction(sender : UIButton){
        //set the back navigation
        debugPrint("Close Clicked")
        myDelegate?.didSelectRowSelectedValue(didSelectCountryWithName:"" , code: "", dialCode: "")
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        myDelegate?.didSelectRowSelectedValue(didSelectCountryWithName:countryName[indexPath.row] , code: countryCode[indexPath.row], dialCode: counrtyDialCode[indexPath.row])
        debugPrint("All details which is selected",countryName[indexPath.row],countryCode[indexPath.row],counrtyDialCode[indexPath.row])
        self.dismiss(animated: true, completion: nil)
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

