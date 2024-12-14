//
//  AnnouncementVC.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//
import UIKit

class AnnouncementVC: BaseBackgroundViewController, UIScrollViewDelegate {
        
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    let openView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure openView is transparent
        openView.backgroundColor = .clear
        
        // Set up the scroll view
        setUpScrollView()
        
        // Set up the page control
        setUpPageControl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Adjust scroll view bounds
        scrollView.frame = openView.bounds
        
        // Adjust page control frame
        let pageControlHeight: CGFloat = 30
        pageControl.frame = CGRect(
            x: 0,
            y: openView.frame.height - pageControlHeight - 10, // 10 points above the bottom
            width: openView.frame.width,
            height: pageControlHeight
        )
        
        // Add images to the scroll view
        addImagesToView()
    }
    
    func setUpScrollView() {
        
        view.addSubview(openView)
        openView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            openView.topAnchor.constraint(equalTo: view.topAnchor),
            openView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            openView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            openView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ])
        
        scrollView.frame = openView.bounds // Full screen
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self // Set delegate to detect page changes
        scrollView.backgroundColor = .clear
        openView.addSubview(scrollView)
    }
    
    func setUpPageControl() {
        pageControl.numberOfPages = DataManager.getUrlList().count
        pageControl.currentPage = 0
        pageControl.tintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        openView.addSubview(pageControl)
    }
    
    func addImagesToView() {
        let imageWidth = scrollView.frame.width
        let imageHeight = scrollView.frame.height

        for (i, image) in DataManager.getUrlImages().enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(
                x: CGFloat(i) * imageWidth,
                y: 0,
                width: imageWidth,
                height: imageHeight
            )
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(
            width: scrollView.frame.width * CGFloat(DataManager.getUrlImages().count),
            height: scrollView.frame.height
        )
    }
    
    // ScrollView Delegate Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate the current page
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
    }
}
