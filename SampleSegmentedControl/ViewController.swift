//
//  ViewController.swift
//  SampleSegmentedControl
//
//  Created by 岩本康孝 on 2021/08/14.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    private var pageViewController: UIPageViewController? {
        didSet {
            pageViewController?.dataSource = self
            pageViewController?.delegate = self
        }
    }
    
    private var viewControllers = [UIViewController]()
    
    private var currentPageIndex = 0 {
        didSet {
            segmentedControl.selectedSegmentIndex = currentPageIndex
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UIPageViewController {
            pageViewController = vc
        }
    }
    
    private func setupPageViews() {
        (0...2).forEach { index in
            let vc = UIViewController()
            switch index % 3 {
            case 0:
                vc.view.backgroundColor = .red
            case 1:
                vc.view.backgroundColor = .yellow
            case 2:
                vc.view.backgroundColor = .green
            default: break
            }
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 60)
            label.text = "\(index + 1)"
            label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            label.textAlignment = .center
            label.center = self.view.center
            vc.view.addSubview(label)
            viewControllers.append(vc)
        }
        pageViewController?.setViewControllers([viewControllers[0]], direction: .forward, animated: true)
    }
    
    private func transitionPage(index: Int) {
        pageViewController?.setViewControllers(
            [viewControllers[index]],
            direction: currentPageIndex < index ? .forward : .reverse,
            animated: true
        )
        currentPageIndex = index
    }
    
    @IBAction func tappedSegmentedControl(_ sender: UISegmentedControl) {
        guard sender.selectedSegmentIndex < viewControllers.count else { return }
        transitionPage(index: sender.selectedSegmentIndex)
    }
}

extension ViewController: UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController),
              index > 0 else { return nil }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController),
              viewControllers.count - 1 > index else { return nil }
        return viewControllers[index + 1]
    }
}

extension ViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first,
              let index = viewControllers.firstIndex(of: currentVC) else { return }
        currentPageIndex = index
    }
}
