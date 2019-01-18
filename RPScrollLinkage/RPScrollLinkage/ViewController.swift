//
//  ViewController.swift
//  RPScrollLinkage
//
//  Created by rpweng on 2019/1/16.
//  Copyright © 2019 rpweng. All rights reserved.
//
// tableView与collectionView联动功能的实现（左侧大分类，右侧小分类）

/*
 实现原理
 （1）左侧 tableView 联动右侧 collectionView 比较简单。只要点击时获取对应索引值，然后让右侧 collectionView 滚动到相应的分区头即可。
 （2）右侧 collectionView 联动左侧 tableView 麻烦些。我们需要在右侧 collectionView 的分区头显示或消失时，触发左侧 tableView 的选中项改变：
 当右侧 collectionView 分区头即将要显示时：如果此时是向上滚动，且是由用户滑动屏幕造成的，那么左侧 tableView 自动选中该分区对应的分类。
 当右侧 collectionView 分区头即将要消失时：如果此时是向下滚动，且是由用户滑动屏幕造成的，那么左侧 tableView 自动选中该分区对应的下一个分区的分类。
 */

import UIKit

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHieght = UIScreen.main.bounds.height

let tableViewIdentifier = "tableViewID"
let collectionViewIdentifier = "collectionViewID"
let collectionViewHeaderIdentifier = "collectionViewHeaderID"

class ViewController: UIViewController {
    
    // 左侧tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: 80, height: ScreenHieght)
        tableView.rowHeight = 55
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.register(TableViewCell.self, forCellReuseIdentifier: tableViewIdentifier)
        return tableView
    }()
    
    // 右侧collectionView的布局
    lazy var flowlayout: UICollectionViewFlowLayout = {
       let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumLineSpacing = 2
        flowlayout.minimumInteritemSpacing = 2
        // 分组悬停
        flowlayout.sectionHeadersPinToVisibleBounds = true
        let itemWidth = (ScreenWidth-80-4-4)/3
        flowlayout.itemSize = CGSize(width: itemWidth, height: itemWidth+30)
        return flowlayout
    }()
    
    // 右侧collectionView
    lazy var collectionView: UICollectionView = {
       let collectionView = UICollectionView(frame: CGRect.init(x: 2+80, y: 2+64, width: ScreenWidth-80-4, height: ScreenHieght-64-4), collectionViewLayout: self.flowlayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: collectionViewIdentifier)
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionViewHeaderIdentifier)
        return collectionView
    }()
    
    // 左侧tableView数据
    var tableViewData = [String]()
    // 右侧collectionView数据
    var collectionViewData = [[CollectionViewModel]]()
    // 右侧collectionView当前是否正在向下滚动（即true表示手指向上滑动，查看下面内容）
    var collectionViewIsScrollDown = true
    // 右侧collectionView垂直偏移量
    var collectionViewLastOffsetY: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "左右联动的效果--Swift4"
        // 初始化左侧表格数据
        for i in 1..<15 {
            self.tableViewData.append("分类\(i)")
        }
        
        // 初始化右侧表格数据
        for _ in tableViewData {
            var models = [CollectionViewModel]()
            for i in 1..<6 {
                models.append(CollectionViewModel(name: "型号\(i)", picture: "image.jpg"))
            }
            self.collectionViewData.append(models)
        }
        
        //将tableView和collectionView添加到页面上
        view.addSubview(tableView)
        view.addSubview(collectionView)
        
        //左侧表格默认选中第一项
         tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
    }

}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
//    // 设置分组尾部高度
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.01
//    }
//    // 将分组尾部设置为一个空的view
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
    
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "我是第\(section)组！"
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewIdentifier, for: indexPath) as! TableViewCell
        cell.textLabel?.text = tableViewData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //右侧collection自动滚动到对应的分区
        collectionViewScrollToTop(section: indexPath.row, animated: true)
        //左侧tableView将该单元格滚动到顶部
        tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 0), at: .top, animated: true)
    }
    
    //将右侧collectionView的制定分区自动滚动到最顶端
    func collectionViewScrollToTop(section: Int, animated: Bool) {
        let headerRect = collectionViewHeaderFrame(section: section)
        let topOfHeader = CGPoint(x: 0, y: headerRect.origin.y - collectionView.contentInset.top)
        collectionView.setContentOffset(topOfHeader, animated: animated)
    }
    
    // 后获collectionView的制定分区头的高度
    func collectionViewHeaderFrame(section: Int) -> CGRect {
        let indexPath = IndexPath(item: 0, section: section)
        let attributes = collectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        guard let frameForFirstCell = attributes?.frame else {
            return .zero
        }
        return frameForFirstCell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    //获取分区数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tableViewData.count
    }
    
    //分区下单元格数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData[section].count
    }
    
    //返回自定义单元格
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:collectionViewIdentifier , for: indexPath) as! CollectionViewCell
        let model = collectionViewData[indexPath.section][indexPath.row]
        cell.setData(model)
        return cell
    }
    
    //分区头尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: ScreenWidth, height: 30)
    }
    
    //返回自定义分区头
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionViewHeaderIdentifier, for: indexPath) as! CollectionViewHeader
        view.titleLabel.text = tableViewData[indexPath.section]
        return view
    }
    
    //分区头即将要显示时调用
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        //如果是由用户手动滑动屏幕造成的向上滚动，那么左侧表格自动选中该分区对应的分类
        if !collectionViewIsScrollDown && (collectionView.isDragging || collectionView.isDecelerating) {
            tableView.selectRow(at: IndexPath(row: indexPath.section, section: 0), animated: true, scrollPosition: .top)
        }
    }
    
    //分区头即将要消失时调用
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        //如果是由用户手动滑动屏幕造成的向下h滚动，那么左侧表格自动选中该分区对应的下一个分区的分类
        if collectionViewIsScrollDown && (collectionView.isDragging || collectionView.isDecelerating) {
            tableView.selectRow(at: IndexPath(row: indexPath.section+1, section: 0), animated: true, scrollPosition: .top)
        }
    }
    
    //视图滚动时触发（主要用于记录当前collectionView是向上还是向下滚动）
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView == scrollView {
            collectionViewIsScrollDown = collectionViewLastOffsetY < scrollView.contentOffset.y
            collectionViewLastOffsetY = scrollView.contentOffset.y
        }
    }
}
