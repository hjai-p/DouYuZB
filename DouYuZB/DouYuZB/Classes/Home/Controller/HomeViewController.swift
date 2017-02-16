//
//  HomeViewController.swift
//  DouYuZB
//
//  Created by PH on 17/2/16.
//  Copyright © 2017年 HJ. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置UI界面
        setupUI()
    }
}



// MARK: -设置UI界面
extension HomeViewController {
    private func setupUI() {
        // 设置导航栏
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        
        // 设置左侧item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo", HighImageName: "", size: CGSizeZero)
        
        // 设置右侧item
        let size = CGSize(width: 40, height: 40)
        
        let historyItem = UIBarButtonItem(imageName: "image_my_history", HighImageName: "Image_my_history_click", size: size)
        
        let searchItem = UIBarButtonItem(imageName: "btn_search", HighImageName: "btn_search_clicked", size: size)
        
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", HighImageName: "Image_scan_click", size: size)


        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
}
