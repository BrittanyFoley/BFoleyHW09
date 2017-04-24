//
//  PageVC.swift
//  Weather Gift
//
//  Created by Brittany Foley on 3/16/17.
//  Copyright © 2017 Brittany Foley. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
    
    var currentPage = 0
    var locationsArray = [weatherLocation]()
    var pageControl: UIPageControl!
    var listButton: UIButton!
    let barButtonWidth: CGFloat = 44
    var aboutButton: UIButton!
    var aboutButtonSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        // load any saved location data from user defaults
        if let locationsDefaultsData = UserDefaults.standard.object(forKey: "locationsData") as? Data {
            if let locationsDefaultsArray = NSKeyedUnarchiver.unarchiveObject(with: locationsDefaultsData) as? [weatherUserDefault] {
            locationsArray = locationsDefaultsArray as! [weatherLocation]
            } else {
                print("error creating array")
            }
            } else {
                print("error loading data")
            }
        
        let newLocation = weatherLocation()
        newLocation.name = "Unknown Weather Location"
        if locationsArray.count == 0 {
        locationsArray.append(newLocation)
        } else {
            locationsArray[0] = newLocation
        }
        
        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
        
        configurePageControl()
        configureButtons()

    }
    
//MARK: - UI Configuration methods
    
    func configurePageControl() {
        let pageControlHeight: CGFloat = barButtonWidth
        let pageControlWidth: CGFloat = view.frame.width - (16 * 2)
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth) / 2, y: view.frame.height - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        
        view.addSubview(pageControl)
        
    }
    
    
    func configureButtons() {
        let barButtonHeight = barButtonWidth
        listButton = UIButton(frame: CGRect(x: view.frame.width - barButtonWidth, y: view.frame.height - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        
        listButton.setBackgroundImage(UIImage(named: "listButton"), for: .normal)
        listButton.setBackgroundImage(UIImage(named:"listButtonHighlighted"), for: .highlighted)
        
        listButton.addTarget(self, action: #selector(segueToListVC), for: .touchUpInside)
        
        view.addSubview(listButton)
        
        let aboutButtonText = "About..."
        let aboutButtonFont = UIFont.systemFont(ofSize: 15)
        let fontAttributes = [NSFontAttributeName: aboutButtonFont]
        aboutButtonSize = aboutButtonText.size(attributes: fontAttributes)
        aboutButtonSize.height += 16
        aboutButtonSize.width += 16
        aboutButton = UIButton(frame: CGRect(x: 8, y: (view.frame.height - 5) - aboutButtonSize.height, width: aboutButtonSize.width, height: aboutButtonSize.height))
        aboutButton.setTitle(aboutButtonText, for: .normal)
        aboutButton.setTitleColor(UIColor.darkText, for: .normal)
        aboutButton.titleLabel?.font = aboutButtonFont
        aboutButton.addTarget(self, action: #selector(segueToAboutVC), for: .touchUpInside)
        view.addSubview(aboutButton)
    }
    
    //MARK: - Segues
    
    func segueToListVC(sender: UIButton!) {
        performSegue(withIdentifier: "ToListVC", sender: sender)
    }
    
    func segueToAboutVC(sender: UIButton) {
        performSegue(withIdentifier: "ToAboutVC", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToListVC" {
            let controller = segue.destination as! ListVC
            controller.locationsArray = locationsArray
            controller.currentPage = currentPage
        }
    }
    
    @IBAction func unwindFromListVC(sender: UIStoryboardSegue) {
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        setViewControllers([createDetailVC(forPage: currentPage)], direction: .forward, animated: false, completion: nil)
        
    }
    
    //MARK: - Create View Controller for UI PageVC
    func createDetailVC(forPage page: Int) -> DetailVC {
        
        currentPage = min(max(0, page), locationsArray.count - 1)
        
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC")
        as! DetailVC
        
        detailVC.locationsArray = locationsArray
        detailVC.currentPage = currentPage
        
        
        return detailVC
        
        
    }



}

extension PageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage < locationsArray.count - 1 {
                return createDetailVC(forPage: currentViewController.currentPage + 1)
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage > 0 {
          return createDetailVC(forPage: currentViewController.currentPage - 1)
            }
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?[0] as? DetailVC
        {
        pageControl.currentPage = currentViewController.currentPage
    }
}
}
