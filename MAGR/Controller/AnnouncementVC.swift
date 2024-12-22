//
//  AnnouncementVC.swift
//  MAGR
//
//  Created by Amer Khalil on 12/12/24.
//
import UIKit

class AnnouncementVC: BaseBackgroundViewController, UIScrollViewDelegate {

    // Main horizontal scroll view for paging
    let scrollView = UIScrollView()

    // Page control for displaying the current page
    let pageControl = UIPageControl()

    // Chevron icons for navigating between pages
    let leftChevron = UIImageView(image: UIImage(systemName: "chevron.left"))
    let rightChevron = UIImageView(image: UIImage(systemName: "chevron.right"))

    // Insets for layout and spacing
    let sideInset: CGFloat = 35  // Horizontal inset for the scroll view
    let verticalInset: CGFloat = 50  // Vertical inset for the scroll view
    let imageSideInset: CGFloat = 10 // Horizontal inset for images inside each page

    // Array to store references to zoomable UIScrollViews
    var zoomableScrollViews: [UIScrollView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial setup of the scroll view, page control, and chevrons
        setupScrollView()
        setupPageControl()
        setupChevrons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Add images to the scroll view (layout is dependent on the resolved size of the scroll view)
        setupScrollViewContent()

        // Update chevron visibility after layout
        updateChevronVisibility()
    }

    func setupScrollView() {
        // Adding the scroll view to the main view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        // Enable paging for discrete horizontal scrolling
        scrollView.isPagingEnabled = true

        // Hide scroll indicators
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        // Allow scrolling past boundaries with a "bounce" effect
        scrollView.bounces = true

        // Set the current class as the delegate to handle scroll events
        scrollView.delegate = self

        // **NSLayoutConstraint Explanation**
        // Constraints are used to define the size and position of the scroll view.
        // Auto Layout does not immediately resolve the frame of the view (e.g., `scrollView.bounds.width`).
        // However, using `viewDidLayoutSubviews` ensures that Auto Layout has resolved these constraints
        // before we access properties like `scrollView.bounds`.

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalInset),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalInset),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideInset),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideInset)
        ])
    }

    func setupScrollViewContent() {
        // Clear previous subviews (necessary if `viewDidLayoutSubviews` is called multiple times)
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        zoomableScrollViews.removeAll() // Reset the zoomable scroll views array

        // Load images (replace with your data source)
        let images = DataManager.getUrlImages()
        let pageWidth = scrollView.bounds.width
        let pageHeight = scrollView.bounds.height

        // Set the content size of the scroll view to fit all pages
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(images.count), height: pageHeight)

        for (index, image) in images.enumerated() {
            // Create a scroll view for zooming each image
            let zoomableScrollView = UIScrollView(frame: CGRect(
                x: CGFloat(index) * pageWidth,
                y: 0,
                width: pageWidth,
                height: pageHeight
            ))
            zoomableScrollView.minimumZoomScale = 1.0
            zoomableScrollView.maximumZoomScale = 1.0
            zoomableScrollView.delegate = self

            // Add the zoomable scroll view to the main scroll view
            scrollView.addSubview(zoomableScrollView)
            zoomableScrollViews.append(zoomableScrollView)

            // Add the image view inside the zoomable scroll view
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isUserInteractionEnabled = true
            zoomableScrollView.addSubview(imageView)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)

            // Constraints to center the image view inside the zoomable scroll view
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: zoomableScrollView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: zoomableScrollView.centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: zoomableScrollView.widthAnchor, constant: -2 * imageSideInset),
                imageView.heightAnchor.constraint(lessThanOrEqualTo: zoomableScrollView.heightAnchor)
            ])
        }
    }

    func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = DataManager.getUrlImages().count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.isUserInteractionEnabled = false
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
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView, let image = imageView.image else { return }

        let zoomableVC = ZoomableImageViewController()
        zoomableVC.image = image
        zoomableVC.modalPresentationStyle = .overFullScreen
        zoomableVC.modalTransitionStyle = .crossDissolve
        present(zoomableVC, animated: true, completion: nil)
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

    // Delegate method for zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // Return the image view inside the zoomable scroll view
        if let _ = zoomableScrollViews.firstIndex(of: scrollView) {
            return scrollView.subviews.first
        }
        return nil
    }
}
