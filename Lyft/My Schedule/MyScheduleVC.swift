//
//  MyScheduleVC.swift
//  Lyft
//
//  Created by Diwakar Garg on 11/11/22.
//

import UIKit

class MyScheduleVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {

    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    var remaingSessionLeft = ""
    var pastScheduledList = [[String: Any]]()
    var upcomingScheduledList = [[String: Any]]()
    var segmentedControl: CustomSegmentedControl!
    private var pageController: UIPageViewController!
    private var arrVC:[UIViewController] = []
    private var currentPage: Int!

    // MARK: Order ViewController
    lazy var vc1: UpcomingVC = {
        var viewController = storyboard?.instantiateViewController(withIdentifier: "UpcomingVC") as! UpcomingVC
        return viewController
    }()
    
    // MARK: MARKET ViewController
    lazy var vc2: PastVC = {
        var viewController = storyboard?.instantiateViewController(withIdentifier: "PastVC") as! PastVC
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadSegmentCustomTab()
        self.navigationItem.title = Constants.mySchedule.localize()
        self.currentPage = 0
        self.arrVC.append(self.vc1)
        self.arrVC.append(self.vc2)
        // Do any additional setup after loading the view.
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        callScheduledUpcomingAndPastAPI()
    }
    //    MARK: - API calling For Training
        func callScheduledUpcomingAndPastAPI() {
            if Connectivity.isConnectedToInternet {

                let urlString =  kBaseURL + myScheduledAPI;
                self.view.activityStartAnimating()

                var param = [String: Any] ()
                param["Accept"]  = "application/json"
                self.view.isUserInteractionEnabled = false

                CustomAlmofire.dataTask_GET(Foundation.URL(string: urlString)!, method: .get, param: param) { response in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.activityStopAnimating()
                        self.view.isUserInteractionEnabled = true
                        switch response {
                        case .success(let dictionary as [String: Any]):
                            if (dictionary["status"] as? Int == 200) {
                                let jsondictionary = dictionary["results"] as! NSDictionary
                                self.remaingSessionLeft = jsondictionary["free_sessions_left"] as! String
                                let bookedSession = jsondictionary["booked_seesions"] as! NSDictionary
                                if let upcomingList = bookedSession["upcoming"] as? [[String: Any]] {
                                    self.upcomingScheduledList = upcomingList
                                }
                                if let pastList = bookedSession["past"] as? [[String: Any]] {
                                    self.pastScheduledList = pastList
                                }
                                    DispatchQueue.main.async {
                                      // handle the action
                                        self.vc1.upcomingScheduledList = self.upcomingScheduledList
                                        self.vc1.remaininglass = self.remaingSessionLeft
                                        self.vc2.pastScheduledList = self.pastScheduledList
                                        self.vc2.remaininglass = self.remaingSessionLeft
                                        self.createPageViewController()
                                    }
                            }else{
                                self.alert(message: dictionary["message"] as? String ?? "")
                            }
                            break
                        case .failure(let error):
                            if error.domain == "Timeout" {
                                self.alert(message: Constants.timeOutMessage.localize())
                            }
                            break
                        default:
                            break
                        }
                    })
                }
            }else{
                self.updateUserInterface()
            }
        }
    
    func loadSegmentCustomTab() {
        segmentedControl = CustomSegmentedControl.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 45))
        segmentedControl.backgroundColor = .black
        segmentedControl.commaSeperatedButtonTitles = "\(Constants.capUpcoming.localize()), \(Constants.capPast.localize())"
        segmentedControl.addTarget(self, action: #selector(onChangeOfSegment(_:)), for: .valueChanged)
        
        self.view.addSubview(segmentedControl)
    }
    
    @objc func onChangeOfSegment(_ sender: CustomSegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            pageController.setViewControllers([arrVC[0]], direction: UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
            currentPage = 0
            
        case 1:
            if currentPage > 1{
                pageController.setViewControllers([arrVC[1]], direction: UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
                currentPage = 1
            }else{
                pageController.setViewControllers([arrVC[1]], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
                currentPage = 1
                
            }
        default:
            break
        }
    }
    
    
    //MARK: - CreatePagination
    
    private func createPageViewController() {
        
        pageController = UIPageViewController.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self
        
        for svScroll in pageController.view.subviews as! [UIScrollView] {
            svScroll.delegate = self
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageController.view.frame = CGRect(x: 0, y: self.segmentedControl.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
        }
       // arrVC = [vc1, vc2]
        pageController.setViewControllers([vc1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        self.addChild(pageController)
        self.view.addSubview(pageController.view)
        pageController.didMove(toParent: self)
    }
    
    
    private func indexofviewController(viewCOntroller: UIViewController) -> Int {
        if(arrVC .contains(viewCOntroller)) {
            return arrVC.firstIndex(of: viewCOntroller)!
        }
        return -1
    }
    
    //MARK: - Pagination Delegate Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index - 1
        }
        
        if(index < 0) {
            return nil
        }
        else {
            return arrVC[index]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index + 1
        }
        
        if(index >= arrVC.count) {
            return nil
        }
        else {
            return arrVC[index]
        }
    }
    
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(completed) {
            currentPage = arrVC.firstIndex(of: (pageViewController1.viewControllers?.last)!)
            self.segmentedControl.updateSegmentedControlSegs(index: currentPage)
        }
    }
}

