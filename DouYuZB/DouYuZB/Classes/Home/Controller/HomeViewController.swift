//
//  HomeViewController.swift
//  DouYuZB
//
//  Created by PH on 17/2/16.
//  Copyright © 2017年 HJ. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

    // MARK: -懒加载属性(不能使用private？)
    fileprivate lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    fileprivate lazy var pageContentView: PageContentView = { [weak self] in
        
        let contentViewH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH - kTabBarH
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentViewH)
        
        var childVCs = [UIViewController]()
        childVCs.append(ReCommendViewController())
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVCs.append(vc)
        }
        
        let contentView = PageContentView(frame: contentFrame, childVCs: childVCs, parentVC: self)
        contentView.delegate = self
        return contentView
    }()
    
    // MARK: -系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置UI界面
        setupUI()
    }
}



// MARK: -设置UI界面
extension HomeViewController {
    func setupUI() {
        
        // 0 不需要调整scrollView的内边距（scrollView的一个特性： 当上面有导航栏存在的时候会自动添加 64 的内边距）
        automaticallyAdjustsScrollViewInsets = false
        
        // 1 设置导航栏
        setupNavigationBar()
        
        // 2 添加titleView
        view.addSubview(pageTitleView)
        
        // 3 添加contentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.orange
    }

    fileprivate func setupNavigationBar() {
        // 设置左侧item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo", HighImageName: "", size: CGSize.zero)
        
        // 设置右侧item
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", HighImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", HighImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", HighImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
}



// MARK: -遵守PageTitleViewDelegate
extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}



// MARK: -遵守PageContentViewDelegate
extension HomeViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleViewWith(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
