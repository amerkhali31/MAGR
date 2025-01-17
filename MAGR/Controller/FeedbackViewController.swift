import UIKit
import Firebase

class FeedbackViewController: BaseBackgroundViewController, UITextViewDelegate {
    
    private var lastSubmissionTime: Date?
    private let submissionCooldown: TimeInterval = 10 // 10 seconds cooldown

    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Feedback"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let feedbackTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocorrectionType = .no // Disable spell check
        textView.spellCheckingType = .no // Disable spell checking
        textView.smartQuotesType = .no // Optional: Disable smart quotes
        textView.backgroundColor = .white
        textView.textColor = .black
        return textView
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitFeedback), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        feedbackTextView.delegate = self
        setupUI()
        setupGestureToDismissKeyboard()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(feedbackTextView)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: bottomOfImage + 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            feedbackTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            feedbackTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            feedbackTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            feedbackTextView.heightAnchor.constraint(equalToConstant: 200),
            
            submitButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true) // Dismiss the keyboard
    }
    
    @objc private func submitFeedback() {
        
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.isUserInteractionEnabled = true
        view.addSubview(overlayView)

        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        loadingIndicator.color = .white
        loadingIndicator.alpha = 1.0
        loadingIndicator.startAnimating()
        
        // Add the loading indicator to the view
        DispatchQueue.main.async { [weak self] in
            
            self?.view.addSubview(loadingIndicator)
        }
        
        guard let feedback = feedbackTextView.text, !feedback.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Feedback cannot be empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        Task {
                do {
                    try await FirebaseManager.submitFeedback(submit: feedback)
                    loadingIndicator.removeFromSuperview()
                    overlayView.removeFromSuperview()
                    dismiss(animated: true)
                } catch {
                    loadingIndicator.removeFromSuperview()
                    overlayView.removeFromSuperview()
                    let alert = UIAlertController(title: "Error", message: "Failed to submit feedback: \(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alert, animated: true)
                }
            }
        
        
    }
    
    // UITextViewDelegate: Dismiss keyboard when Return is pressed
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" { // Check for the return key
            dismissKeyboard()
            return false // Prevent the newline character from being added
        }
        return true
    }
}

