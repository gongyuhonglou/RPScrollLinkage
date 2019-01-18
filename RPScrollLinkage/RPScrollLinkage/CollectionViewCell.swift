//
//  CollectionViewCell.swift
//  RPScrollLinkage
//
//  Created by rpweng on 2019/1/17.
//  Copyright © 2019 rpweng. All rights reserved.
//
// 右侧网格的自定义单元格

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // 标题文本标签
    var titleLabel = UILabel()
    //产品图片视图
    var pictureView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //初始化标题文本标签
        titleLabel.frame = CGRect.init(x: 2, y: frame.size.width, width: frame.size.width-4, height: 20)
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        //初始化产品图片视图
        pictureView.frame = CGRect(x: 8, y: 8, width: frame.size.width-16, height: frame.size.width-16)
        pictureView.contentMode = .scaleAspectFit
        contentView.addSubview(pictureView)
    }
    
    // 设置数据
    func setData(_ model: CollectionViewModel){
        titleLabel.text = model.name
        pictureView.image = UIImage(named: model.picture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
