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
    let leftChevron = UIImageView(image: UIImage(systemName: "chevron.left"))
    let rightChevron = UIImageView(image: UIImage(systemName: "chevron.right"))
    let sideInset: CGFloat = 35  // Horizontal inset for the scroll view
    let verticalInset: CGFloat = 50  // Vertical inset for the scroll view
    let imageSideInset: CGFloat = 10 // Horizontal inset for images inside each page

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupPageControl()
        setupChevrons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Add images to the scroll view (layout-dependent)
        setupScrollViewContent()
        updateChevronVisibility() // Update chevron visibility initially
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.delegate = self
        
        // Constraints for the scroll view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalInset),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalInset),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInset),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInset)
        ])
    }

    func setupScrollViewContent() {
        // Clear any previous subviews (if layoutSubviews is called again)
        scrollView.subviews.forEach { $0.removeFromSuperview() }

        // Load images (replace with your data source)
        let images = DataManager.getUrlImages()
        let pageWidth = scrollView.bounds.width
        let pageHeight = scrollView.bounds.height
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(images.count), height: pageHeight)

        for (index, image) in images.enumerated() {
            // Create a container scroll view for each image (to enable zooming)
            let zoomScrollView = UIScrollView(frame: CGRect(
                x: CGFloat(index) * pageWidth,
                y: 0,
                width: pageWidth,
                height: pageHeight
            ))
            zoomScrollView.delegate = self
            zoomScrollView.minimumZoomScale = 1.0
            zoomScrollView.maximumZoomScale = 3.0
            zoomScrollView.showsHorizontalScrollIndicator = false
            zoomScrollView.showsVerticalScrollIndicator = false
            zoomScrollView.bounces = true
            zoomScrollView.contentSize = CGSize(width: pageWidth, height: pageHeight)

            // Add the image view inside the zoom scroll view
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            zoomScrollView.addSubview(imageView)

            // Constraints for the image view (inset by 10 points on each side)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: zoomScrollView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: zoomScrollView.centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: zoomScrollView.widthAnchor, constant: -2 * imageSideInset),
                imageView.heightAnchor.constraint(equalTo: zoomScrollView.heightAnchor)
            ])

            scrollView.addSubview(zoomScrollView)
        }
    }

    func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = DataManager.getUrlImages().count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func setupChevrons() {
        // Left Chevron
        leftChevron.translatesAutoresizingMaskIntoConstraints = false
        leftChevron.tintColor = .white
        leftChevron.alpha = 0 // Initially hidden
        view.addSubview(leftChevron)
        
        NSLayoutConstraint.activate([
            leftChevron.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            leftChevron.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: -30),
            leftChevron.widthAnchor.constraint(equalToConstant: 30),
            leftChevron.heightAnchor.constraint(equalToConstant: 30)
        ])

        let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollLeft))
        leftChevron.isUserInteractionEnabled = true
        leftChevron.addGestureRecognizer(leftTapGesture)

        // Right Chevron
        rightChevron.translatesAutoresizingMaskIntoConstraints = false
        rightChevron.tintColor = .white
        view.addSubview(rightChevron)
        
        NSLayoutConstraint.activate([
            rightChevron.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            rightChevron.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 30),
            rightChevron.widthAnchor.constraint(equalToConstant: 30),
            rightChevron.heightAnchor.constraint(equalToConstant: 30)
        ])

        let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollRight))
        rightChevron.isUserInteractionEnabled = true
        rightChevron.addGestureRecognizer(rightTapGesture)
    }

    func updateChevronVisibility() {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let totalPages = DataManager.getUrlImages().count

        leftChevron.alpha = currentPage > 0 ? 1 : 0
        rightChevron.alpha = currentPage < totalPages - 1 ? 1 : 0
    }

    @objc func scrollLeft() {
        let currentPage = pageControl.currentPage
        guard currentPage > 0 else { return }

        let newOffset = CGPoint(x: scrollView.bounds.width * CGFloat(currentPage - 1), y: 0)
        scrollView.setContentOffset(newOffset, animated: true)
    }

    @objc func scrollRight() {
        let currentPage = pageControl.currentPage
        guard currentPage < pageControl.numberOfPages - 1 else { return }

        let newOffset = CGPoint(x: scrollView.bounds.width * CGFloat(currentPage + 1), y: 0)
        scrollView.setContentOffset(newOffset, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let pageWidth = scrollView.bounds.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            pageControl.currentPage = currentPage
            updateChevronVisibility()
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // Return the image view for zooming (only for zoomable scroll views)
        if scrollView != self.scrollView {
            return scrollView.subviews.first
        }
        return nil
    }
}


/*
Everything BUT zooming works
class AnnouncementVC: BaseBackgroundViewController, UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    let leftChevron = UIImageView(image: UIImage(systemName: "chevron.left"))
    let rightChevron = UIImageView(image: UIImage(systemName: "chevron.right"))
    let sideInset: CGFloat = 35  // Horizontal inset for the scroll view
    let verticalInset: CGFloat = 50  // Vertical inset for the scroll view
    let imageSideInset: CGFloat = 10 // Horizontal inset for images inside each page

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupPageControl()
        setupChevrons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Add images to the scroll view (layout-dependent)
        setupScrollViewContent()
        updateChevronVisibility() // Update chevron visibility initially
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.delegate = self
        
        // Constraints for the scroll view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalInset),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalInset),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInset),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInset)
        ])
    }

    func setupScrollViewContent() {
        // Clear any previous subviews (if layoutSubviews is called again)
        scrollView.subviews.forEach { $0.removeFromSuperview() }

        // Load images (replace with your data source)
        let images = DataManager.getUrlImages()
        let pageWidth = scrollView.bounds.width
        let pageHeight = scrollView.bounds.height
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(images.count), height: pageHeight)

        for (index, image) in images.enumerated() {
            let containerView = UIView(frame: CGRect(
                x: CGFloat(index) * pageWidth,
                y: 0,
                width: pageWidth,
                height: pageHeight
            ))

            // Image View inside each page
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(imageView)

            // Image view constraints (inset by 10 points on each side)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: imageSideInset),
                imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -imageSideInset)
            ])

            scrollView.addSubview(containerView)
        }
    }

    func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = DataManager.getUrlImages().count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func setupChevrons() {
        // Left Chevron
        leftChevron.translatesAutoresizingMaskIntoConstraints = false
        leftChevron.tintColor = .white
        leftChevron.alpha = 0 // Initially hidden
        view.addSubview(leftChevron)
        
        NSLayoutConstraint.activate([
            leftChevron.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            leftChevron.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: -30),
            leftChevron.widthAnchor.constraint(equalToConstant: 30),
            leftChevron.heightAnchor.constraint(equalToConstant: 30)
        ])

        let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollLeft))
        leftChevron.isUserInteractionEnabled = true
        leftChevron.addGestureRecognizer(leftTapGesture)

        // Right Chevron
        rightChevron.translatesAutoresizingMaskIntoConstraints = false
        rightChevron.tintColor = .white
        view.addSubview(rightChevron)
        
        NSLayoutConstraint.activate([
            rightChevron.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            rightChevron.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 30),
            rightChevron.widthAnchor.constraint(equalToConstant: 30),
            rightChevron.heightAnchor.constraint(equalToConstant: 30)
        ])

        let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollRight))
        rightChevron.isUserInteractionEnabled = true
        rightChevron.addGestureRecognizer(rightTapGesture)
    }

    func updateChevronVisibility() {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let totalPages = DataManager.getUrlImages().count

        leftChevron.alpha = currentPage > 0 ? 1 : 0
        rightChevron.alpha = currentPage < totalPages - 1 ? 1 : 0
    }

    @objc func scrollLeft() {
        let currentPage = pageControl.currentPage
        guard currentPage > 0 else { return }

        let newOffset = CGPoint(x: scrollView.bounds.width * CGFloat(currentPage - 1), y: 0)
        scrollView.setContentOffset(newOffset, animated: true)
    }

    @objc func scrollRight() {
        let currentPage = pageControl.currentPage
        guard currentPage < pageControl.numberOfPages - 1 else { return }

        let newOffset = CGPoint(x: scrollView.bounds.width * CGFloat(currentPage + 1), y: 0)
        scrollView.setContentOffset(newOffset, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        pageControl.currentPage = currentPage
        updateChevronVisibility()
    }
}
*/

/*
 Zooming Works but images are back to back and no page indicator
 */
