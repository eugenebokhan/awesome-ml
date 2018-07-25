//
//  DetailViewController.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//


import UIKit
import CoreML

protocol DetailsViewControllerDelegate: class {
    func detailsViewControllerDismiss(cell: CoreMLModelCollectionViewCell)
}

class DetailsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: DesignableLabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeVisualEffectView: DesignableVisualEffectView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var closeButtonContainerView: UIView!
    @IBOutlet weak var getModelBackgroundVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var getModelButton: UIButton!
    @IBOutlet weak var getModelButtonBackgroundView: UIVisualEffectView!
    @IBOutlet weak var getModelButtonBackgroundTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var getModelButtonBackgroundLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var getModelButtonBackgroundViewWidthConstraint: NSLayoutConstraint!
    
    // MARK: - UI Actions
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        isPresenting = false
        if let cell = cell {
            delegate?.detailsViewControllerDismiss(cell: cell)
        }
        
        onPadDismiss?()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func getModelAction(_ sender: Any) {
        
        if isModelDownloaded {
            animteButtonToProgress()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                self.runModel(completion: {
                    self.animateProgressToButton()
                })
            })
        } else {
            animteButtonToProgress()
            downloadModel()
        }
    }
    
    
    // MARK: - UI Properties
    
    let visualEffectView = UIVisualEffectView()
    var tableViewHeight: CGFloat = 0
    
    var shouldScrollToRow = false
    var hasTableViewReloaded = false
    var scrollContentIndexPath: IndexPath!
    
    private var bodyAttributedString: NSAttributedString?
    private var attributedStrings = [Int: NSAttributedString]()
    private var isPresenting = true
    
    private var hideStatusBar: Bool = false
    var onPadDismiss: (() -> Void)?
    
    private var bodyCachedHeight: CGFloat?
    private var cachedCellHeights = [Int: CGFloat]()
    
    weak var delegate: DetailsViewControllerDelegate?
    weak var cell: CoreMLModelCollectionViewCell? {
        didSet {
            coreMLModel = cell?.coreMLModel
        }
    }
    
    private var didCalculateRowHeight = false
    
    // MARK: - CoreML Property
    
    var coreMLModel: CoreMLModel!
    
    // MARK: - Download Properties
    
    let progressButton = DownloadButton()
    let downloadManager = DownloadManager()
    
    var isModelDownloaded: Bool {
        return CoreMLStore.isModelDownloaded(coreMLModel: coreMLModel)
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(tableView: detailsTableView)
        configure(scrollView: scrollView)
        
        if appHasWideScreenForView(view) {
            view.backgroundColor = UIColor(hex: "F5F5F5")
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(closeButtonTapped(_:)))
        closeButtonContainerView.addGestureRecognizer(tapRecognizer)
        
        configure(downloadManager)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBackgroundImage()
        hideStatusBarAnimated()
        setupLabels()
        setupNotifications()
        
        configure(progressButton)
        configureGetModelButtonAppearance()
        hideGetModelBackgroundView(animated: false)
        showGetModelBackgroundView(animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if appHasWideScreenForView(view) {
            delay(delay: 1, closure: {
                self.visualEffectView.frame = self.view.frame
            })
        }
        cachedCellHeights.removeAll()
        bodyCachedHeight = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        downloadManager.cancelDownload()
        hideGetModelBackgroundView(animated: true)
    }
    
    deinit {
        print("DetailViewController deinit")
    }
    
    // MARK: - Setups
    
    func setupLabels() {
        if let titleText = cell?.title.text, let subtitleText = cell?.subtitle.text {
            titleLabel.text = titleText
            captionLabel.text = subtitleText
        }
        titleLabel.createShadow()
        captionLabel.createShadow()
    }
    
    func setupBackgroundImage() {
        if let image = cell?.backgroundImageView.image {
            backgroundImageView.image = image
        }
    }
    
    // MARK: - Notifications
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name(rawValue: "Location Collection View Cell Crame Update"), object: nil)
    }
    
    @objc func handleNotification(_ notification: NSNotification) {
        if notification.name.rawValue == "Location Collection View Cell Crame Update" {
            if let cell = notification.userInfo?["selectedCell"] as? CoreMLModelCollectionViewCell {
                self.cell = cell
            }
        }
    }
    
    // MARK: - Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }
    
    func hideStatusBarAnimated() {
        hideStatusBar = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: - UI Methods
    
    func hideGetModelBackgroundView(animated: Bool) {
        
        if animated {
            let animator = UIViewPropertyAnimator(duration: 1.6, dampingRatio: 0.8, animations: {
                self.getModelBackgroundVisualEffectView.transform = CGAffineTransform(translationX: 0, y: 200)
            })
            animator.startAnimation()
        } else {
            self.getModelBackgroundVisualEffectView.transform = CGAffineTransform(translationX: 0, y: 200)
        }
    }
    
    func showGetModelBackgroundView(animated: Bool) {
        
        if animated {
            let animator = UIViewPropertyAnimator(duration: 0.8, dampingRatio: 0.8, animations: {
                self.getModelBackgroundVisualEffectView.transform = .identity
            })
            animator.startAnimation()
        } else {
            self.getModelBackgroundVisualEffectView.transform = .identity
        }
    }
    
    func hideCloseVisualEffectView(animated: Bool) {
        
        if animated {
            let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.7, animations: {
                self.closeVisualEffectView.alpha = 0
                self.closeVisualEffectView.transform = CGAffineTransform(translationX: 0, y: -50).concatenating(CGAffineTransform(scaleX: 2, y: 2))
            })
            animator.startAnimation()
        } else {
            self.closeVisualEffectView.alpha = 0
            self.closeVisualEffectView.transform = CGAffineTransform(translationX: 0, y: -50).concatenating(CGAffineTransform(scaleX: 2, y: 2))
        }
    }
    
    func showCloseVisualEffectView(animated: Bool) {
        
        if animated {
            let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.7, animations: {
                self.closeVisualEffectView.alpha = 1
                self.closeVisualEffectView.transform = .identity
            })
            animator.startAnimation()
        } else {
            self.closeVisualEffectView.alpha = 1
            self.closeVisualEffectView.transform = .identity
        }
    }
    
}

// MARK: Table View

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func configure(tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = 500
    }
    
    func reloadDetailsTableView() {
        detailsTableView.performBatchUpdates({
            self.detailsTableView.reloadData()
        }, completion: nil)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let descriptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailDescriptionTableViewCell") as! DetailDescriptionTableViewCell
        let md = SwiftyMarkdown(url: coreMLModel.detailedDescriptionURL)!
        
        /// Font
        md.h1.fontName = "BlinkMacSystemFont"
        md.h2.fontName = "BlinkMacSystemFont"
        md.body.fontName = "BlinkMacSystemFont"
        md.h1.fontSize = 16
        
        descriptionTableViewCell.descriptionTextView.attributedText = md.attributedString()
        /// Adjust textView height
        let width = descriptionTableViewCell.descriptionTextView.frame.width
        let height = descriptionTableViewCell.descriptionTextView.attributedText.heightWithWidth(width: width)
        tableView.rowHeight = height + 60
        
        return descriptionTableViewCell
        
    }
    
    func reloadIfNecessary(row: Int) {
        
        let indexPath = IndexPath(row: row, section: 1)
        DispatchQueue.main.async { [weak self] in
            if self?.detailsTableView.indexPathsForVisibleRows?.contains(indexPath) == true {
                self?.detailsTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

// MARK: ScrollView Progress

extension DetailsViewController: UIScrollViewDelegate {
    
    internal func configure(scrollView: UIScrollView) {
        scrollView.delegate = self
        scrollView.contentSize = CGSize.zero
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !isPresenting { return }
        
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            viewTopConstraint.constant = 0
        } else {
            viewTopConstraint.constant = max(-offsetY, -420.0)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.y > 0 {
            
            hideGetModelBackgroundView(animated: true)
            hideCloseVisualEffectView(animated: true)
            
        } else {
            
            showGetModelBackgroundView(animated: true)
            showCloseVisualEffectView(animated: true)
        }
    }
    
}

// MARK: - DownloadManager Delegate

extension DetailsViewController: DownloadManagerDelegate {
    
    func configure(_ downloadManager: DownloadManager) {
        downloadManager.delegate = self
    }
    
    func downloadModel() {
        if let remoteUrl = coreMLModel.remoteURL {
            downloadManager.downloadFile(fromURL: remoteUrl, toDirectory: .documentDirectory, domainMask: .userDomainMask)
        }
    }
    
    func didLoadData(bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if progressButton.state == .pending {
            progressButton.state = .downloading
        }
        
        // Update the progress asyncroniusly.
        DispatchQueue.main.async {
            let progress: CGFloat = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
            self.progressButton.stopDownloadButton.progress = progress
        }
    }
    
    func didFinishDownloadingFile(destinationURL: URL) {
        
        progressButton.state = .pending
        
        compileModel(modelURL: destinationURL, completion: {
            self.animateProgressToButton()
            self.configureGetModelButtonAppearance()
        })
        
//        unarchiveModel(modelURL: destinationURL, completion: {
//            self.animateProgressToButton()
//            self.configureGetModelButtonAppearance()
//        })
    }
    
    func didCompleteWithError(error: Error?) {
        
        animateProgressToButton()
        print("Model download did fail")
        
    }
    
}

// MARK: - CoreML Stuff

extension DetailsViewController {
    
    func compileModel(modelURL: URL, completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            
            // Compile model
            guard let compiledAddress = try? MLModel.compileModel(at: modelURL) else { return }
            
            // Move compiled files to documents folder
            do {
                try FileManager.default.moveItem(at: compiledAddress, to: self.coreMLModel.localCompiledURL)
            } catch {
                print("An error occurred while moving file to localCompiledURL url")
            }
            
            // Delete temporary files files
            do {
                try FileManager.default.removeItem(at: modelURL)
            } catch {
                print("An error occurred while removing file to destinationURL url")
            }
            
            completion()
            
            print("Did Finish Download")
        }
        
    }
    
    func unarchiveModel(modelURL: URL, completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
         
            // Unarchive zip
            do {
                let _ = try Zip.quickUnzipFile(modelURL)
            }
            catch {
                print("Something went wrong")
            }
            
            // Delete temporary files files
            do {
                try FileManager.default.removeItem(at: modelURL)
            } catch {
                print("An error occurred while removing file to destinationURL url")
            }
            
            completion()
            
            print("Did Finish Download")
            
        }
        
    }
    
    func runModel(completion: @escaping () -> Void) {
        
        switch coreMLModel.machineLearningModelType {
        case .mobileOpenPose?:
            
            let openPoseViewController = OpenPoseViewController(nibName: "RunCoreMLViewController", bundle: nil) as OpenPoseViewController
            openPoseViewController.coreMLModel = coreMLModel
            
            present(openPoseViewController, animated: true) {
                completion()
            }
            
        case .tinyYOLO?:
            
            let tinyYOLOViewController = TinyYOLOViewController(nibName: "RunCoreMLViewController", bundle: nil) as TinyYOLOViewController
            tinyYOLOViewController.coreMLModel = coreMLModel
            
            present(tinyYOLOViewController, animated: true) {
                completion()
            }
            
        default:
            
            let runCoreMLviewController = RunCoreMLViewController(nibName: "RunCoreMLViewController", bundle: nil) as RunCoreMLViewController
            runCoreMLviewController.coreMLModel = coreMLModel
            
            present(runCoreMLviewController, animated: true) {
                completion()
            }
            
        }
    }
    
}

// MARK: - Download Button & Download Background View Stuff

extension DetailsViewController: DownloadButtonDelegate {
    
    func configure(_ downloadButton: DownloadButton) {
        downloadButton.delegate = self
        downloadButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        downloadButton.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    func downloadButtonTapped(_ downloadButton: DownloadButton!, currentState state: DownloadButtonState) {
        
        switch state {
        case .startDownload:
            break
        case .pending:
            break
        case .downloading:
            downloadManager.cancelDownload()
        case .downloaded:
            break
        }
    }
    
    func configureGetModelButtonAppearance() {
        
        if isModelDownloaded {
            getModelButton.setTitle("Open", for: .normal)
        } else {
            getModelButton.setTitle("Get", for: .normal)
        }
    }
    
    func animteButtonToProgress() {
        
        DispatchQueue.main.async {
            
            self.progressButton.alpha = 0
            self.progressButton.state = .pending
            self.getModelButtonBackgroundView.contentView.addSubview(self.progressButton)
            
            let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1, animations: {
                self.getModelButtonBackgroundView.frame.origin.x += 25
                self.getModelButtonBackgroundView.frame.size.width -= 50
                self.getModelButtonBackgroundView.effect = nil
                self.getModelButton.alpha = 0
                self.progressButton.alpha = 1
            })
            animator.startAnimation()
        }
    }
    
    func animateProgressToButton() {
        
        DispatchQueue.main.async {
            
            let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1, animations: {
                self.getModelButtonBackgroundView.frame.origin.x -= 25
                self.getModelButtonBackgroundView.frame.size.width += 50
                self.getModelButtonBackgroundView.effect = UIBlurEffect(style: .dark)
                self.getModelButton.alpha = 1
                self.progressButton.alpha = 0
            })
            animator.startAnimation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.progressButton.removeFromSuperview()
            }
        }
    }
    
}
