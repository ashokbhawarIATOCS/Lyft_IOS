//
//  SideMenuViewController.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/7/21.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuViewController: UIViewController {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var sideMenuTableView: UITableView!
    @IBOutlet weak var lblUserFullName: UILabel!
    @IBOutlet weak var profileDetailContainerView: UIView!
    
    @IBOutlet weak var lblUserMailID: UILabel!
    var delegate: SideMenuViewControllerDelegate?

    var defaultHighlightedCell: Int = 0

    var skipMenuList: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: Constants.home.localize()),
        SideMenuModel(icon: UIImage(systemName: "bolt.fill")!, title: Constants.allTrainers.localize()),
        SideMenuModel(icon: UIImage(systemName: "snowflake")!, title: Constants.planPackage.localize()),
        SideMenuModel(icon: UIImage(systemName: "network")!, title: Constants.changeLanguage.localize()),
        SideMenuModel(icon: UIImage(systemName: "snowflake")!, title: Constants.setting.localize()),
        SideMenuModel(icon: UIImage(systemName: "person")!, title: Constants.signIn.localize()),
    ]
    
    var loginMenuList: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: Constants.home.localize()),
        SideMenuModel(icon: UIImage(systemName: "person")!, title: Constants.myProfile.localize()),
        SideMenuModel(icon: UIImage(systemName: "bolt.fill")!, title: Constants.allTrainers.localize()),
        SideMenuModel(icon: UIImage(systemName: "bell.badge")!, title: Constants.mySchedule.localize()),
        SideMenuModel(icon: UIImage(systemName: "snowflake")!, title: Constants.planPackage.localize()),
        SideMenuModel(icon: UIImage(systemName: "network")!, title: Constants.changeLanguage.localize()),
        SideMenuModel(icon: UIImage(systemName: "snowflake")!, title: Constants.setting.localize()),
        SideMenuModel(icon: UIImage(systemName: "person.fill")!, title: Constants.logout.localize()),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadProfilePicture), name: Notification.Name("loadProfileImageOnUpdate"), object: nil)
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
       
        if (UserDefaults.standard.bool(forKey: skipUserLogin) == true) {
            lblUserFullName.text = Constants.guest.localize()
            lblUserMailID.text = "guest@guest.com"
        }else{
            lblUserFullName.text = UserDefaults.standard.string(forKey: kLoginUserName)
            lblUserMailID.text = UserDefaults.standard.string(forKey: kEmailLogin)
        }
      
        if UserDefaults.standard.string(forKey: kUserProfilePicture)  != nil {
            self.profileImageView?.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: kUserProfilePicture)! , PlaceHolderImage: UIImage.init(named: "userPlaceholder")!)
        }
        
        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.backgroundColor = .black
        self.sideMenuTableView.separatorStyle = .none

        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
           //add tap gesture to go to edit profile page
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            self.profileDetailContainerView.addGestureRecognizer(tap)
        }

        // Register TableView Cell
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)

        // Update TableView with the data
        self.sideMenuTableView.reloadData()
    }

    //MARK: - - - - - Method for receiving Data through Post Notificaiton - - - - -
        @objc func loadProfilePicture(notification: Notification) {
            if UserDefaults.standard.string(forKey: kUserProfilePicture)  != nil {
                self.profileImageView?.imageFromServerURL(urlString: UserDefaults.standard.string(forKey: kUserProfilePicture)! , PlaceHolderImage: UIImage.init(named: "userPlaceholder")!)
            }
        }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
    // handling navigation to edit profile screen code
   }
}
// MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

// MARK: - UITableViewDataSource

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (UserDefaults.standard.bool(forKey: skipUserLogin) == true) {
            return self.skipMenuList.count
        }else{
            return self.loginMenuList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }

        if (UserDefaults.standard.bool(forKey: skipUserLogin) == true) {
            cell.iconImageView.image = self.skipMenuList[indexPath.row].icon
            cell.titleLabel.text = self.skipMenuList[indexPath.row].title
        }else{
            cell.iconImageView.image = self.loginMenuList[indexPath.row].icon
            cell.titleLabel.text = self.loginMenuList[indexPath.row].title
        }
        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = borderColorandThemeColor
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedCell(indexPath.row)
//        if indexPath.row == 4 || indexPath.row == 6 {
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
    }
}
