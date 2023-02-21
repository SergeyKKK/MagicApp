//
//  PageViewController.swift
//  Magic
//
//  Created by Nodir on 29/11/22.
//

import UIKit

//MARK: - UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        
        
        let pageContent: PageContentController = viewController as! PageContentController
        var index = pageContent.pageIndex
        
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index -= 1;
        return getViewControllerAtIndex(index: index)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        
        let pageContent: PageContentController = viewController as! PageContentController
        var index = pageContent.pageIndex
        
        
        if (index == NSNotFound)
        {
            return nil;
        }
        index += 1;
        if (index == arrPageTitle.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
    }
}

class PageViewController: UIPageViewController  {
    
    //MARK: - Properties
    var arrPageTitle =  ["Adjust", "Filters", "Face Retouch"]
    var arrSubTitle = [
        "This setting allows you to adjust a specific color range’s hue, saturation, and brightness",
        "Stylish filters for your photos",
        "Helps hide imperfections and enhance beauty"]
    let pageArray: [UIImage] = [UIImage(named: "Splash-1")!, UIImage(named: "Splash-2")!, UIImage(named: "Splash-3")!]
    let ondoardingImages: [UIImage] = [UIImage(named: "ouboardingImage-1")!, UIImage(named: "ouboardingImage-2")!, UIImage(named: "ouboardingImage-3")!]
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.setViewControllers([getViewControllerAtIndex(index: 0)] as [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
    }
    
    //MARK: - Custom Action
    func getViewControllerAtIndex(index: NSInteger) -> PageContentController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = PageContentController()
        
        pageContentViewController.strTitle = "\(arrPageTitle[index])"
        pageContentViewController.strDesc = "\(arrSubTitle[index])"
        
        let image:UIImage? = self.pageArray[index]
        pageContentViewController.image = image
        pageContentViewController.pageIndex = index
        
        let ondoardingImage:UIImage? = self.ondoardingImages[index]
        pageContentViewController.onboadingImage = ondoardingImage
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
    }
}
