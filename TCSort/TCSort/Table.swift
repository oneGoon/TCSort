//
//  Table.swift
//  TCSort
//
//  Created by WangGang on 2019/12/10.
//  Copyright © 2019 onegoon. All rights reserved.
//

import Foundation
 
//MARK: - 表排序
/// 排序的元素内存较大，移动非常耗时
///
///  间接排序
///   定义一个指针数组作为“表”（table）
///

/*
 
 * 数组的下标
 * 关键字
 * “指针”表 即数组A的下标 初始与下标相同 可见 table[0] = 0 , A[table[0]] = f
 
 ┌───────┬───┬───┬───┬───┬───┬───┬───┬───┐
 │   A   │ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │  key  │ f │ d │ c │ a │ g │ b │ h │ e │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │ table │ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │
 └───────┴───┴───┴───┴───┴───┴───┴───┴───┘
 
 *开始排序 使用简单插入排序 对关键字key进行比较，对table的值进行交换
 比较A[0]与A[1] 即f与d，
 f > d ,交换table中的0与1 ，得到下表↓
               ↓
 ┌───────┬───┬───┬───┬───┬───┬───┬───┬───┐
 │   A   │ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │  key  │ f │ d │ c │ a │ g │ b │ h │ e │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │ table │ 1 │ 0 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │
 └───────┴───┴───┴───┴───┴───┴───┴───┴───┘
 
 继续排序，
 A[2] = c, c<d, 交换 2 0，c<f, 交换 2 1
 即 c<d<f, 0,1后移，2跑到原先0的位置
                   ↓
 ┌───────┬───┬───┬───┬───┬───┬───┬───┬───┐
 │   A   │ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │  key  │ f │ d │ c │ a │ g │ b │ h │ e │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │ table │ 2 │ 1 │ 0 │ 3 │ 4 │ 5 │ 6 │ 7 │
 └───────┴───┴───┴───┴───┴───┴───┴───┴───┘
 
 ......
 
 ┌───────┬───┬───┬───┬───┬───┬───┬───┬───┐
 │   A   │ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │  key  │ f │ d │ c │ a │ g │ b │ h │ e │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │ table │ 3 │ 5 │ 2 │ 1 │ 7 │ 0 │ 4 │ 6 │
 └───────┴───┴───┴───┴───┴───┴───┴───┴───┘
 
 如果只是要按顺序输出，不需要移动位置
 A[table[0]],A[table[1]],...,A[table[n]]
 
 物理排序
 *n个数字的排列由若干个独立的环组成
 
 ┌───────┬───┬───┬───┬───┬───┬───┬───┬───┐
 │   A   │ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │  key  │ f │ d │ c │ a │ g │ b │ h │ e │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │ table │ 3 │ 5 │ 2 │ 1 │ 7 │ 0 │ 4 │ 6 │
 └───────┴───┴───┴───┴───┴───┴───┴───┴───┘
 
 3->1->5->0->┐  2->┐  4->7->6->┐
 └───────────┘  └──┘  └────────┘
 
 *按照环来调整位置
 3->1->5->0->┐
 └───────────┘
 
 f->a->d->b->┐
 └───────────┘
 
/////环的反向调整位置/////
 f<-a<-d<-b-<┐
 └───────────┘
///////////////////////
 
 调整后的位置
 a->d->b->f->┐
 └───────────┘

 对应表的变换
 tmp = f   ↓
 ┌───────┬───┬───┬───┬───┬───┬───┬───┬───┐
 │   A   │ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │  key  │ a │ d │ c │ a │ g │ b │ h │ e │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │ table │ 3 │ 5 │ 2 │ 1 │ 7 │ 0 │ 4 │ 6 │
 └───────┴───┴───┴───┴───┴───┴───┴───┴───┘
                       ↓
 ┌───────┬───┬───┬───┬───┬───┬───┬───┬───┐
 │   A   │ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │  key  │ a │ d │ c │ d │ g │ b │ h │ e │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │ table │ 3 │ 5 │ 2 │ 1 │ 7 │ 0 │ 4 │ 6 │
 └───────┴───┴───┴───┴───┴───┴───┴───┴───┘
               ↓
 ┌───────┬───┬───┬───┬───┬───┬───┬───┬───┐
 │   A   │ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │  key  │ a │ b │ c │ d │ g │ b │ h │ e │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │ table │ 3 │ 5 │ 2 │ 1 │ 7 │ 0 │ 4 │ 6 │
 └───────┴───┴───┴───┴───┴───┴───┴───┴───┘
                               ↓ = tmp
 ┌───────┬───┬───┬───┬───┬───┬───┬───┬───┐
 │   A   │ 0 │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │  key  │ a │ b │ c │ d │ g │ f │ h │ e │
 ├───────┼───┼───┼───┼───┼───┼───┼───┼───┤
 │ table │ 3 │ 5 │ 2 │ 1 │ 7 │ 0 │ 4 │ 6 │
 └───────┴───┴───┴───┴───┴───┴───┴───┴───┘
 
 Q: 如何知道应该是把tmp赋回呢，换言之，如何知道环结束了？
 A: 每访问一个空位i后，就令table[i]=i。当发现table[i]==i时，环就结束了。
 
 
 *最好情况：初始有序
 *最坏情况：
    ·有n/2个环，每个环包含两个元素
    ·需要3*(n/2)次移动
    ·T = O(m·n), m是每个元素的复制时间
 
 */
