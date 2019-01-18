//
//  CollectionViewModel.swift
//  RPScrollLinkage
//
//  Created by rpweng on 2019/1/17.
//  Copyright © 2019 rpweng. All rights reserved.
//
// 右侧网格的数据模型

import UIKit

// 右侧collectionView的数据模型（大分类下的小分类）
class CollectionViewModel: NSObject {
    
    // 小分类名称
    var name: String
    // 小分类图片
    var picture: String

    init(name: String, picture: String) {
        self.name = name
        self.picture = picture
    }
}
