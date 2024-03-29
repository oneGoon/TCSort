//
//  Insertion.swift
//  TCSort
//
//  Created by WangGang on 2019/12/2.
//  Copyright © 2019 onegoon. All rights reserved.
//

import Foundation

// n是正整数
// 小->大
// 内部排序
// 任意两个相等的数据排序前后的相对位置不发生改变
// 每种算法都有其存在的理由，没有一种排序是在任何情况都是表现最好的
// 数据具有某种特征的时候有其合适的算法，这也是我们要了解每种算法的理由


/**
 * 稳定排序
 * 移位 相比交换要好，交换要三步
 */
public
func insertSort<Element: Comparable>(array: inout Array<Element>, n: Int) {
    var tmp: Element /* 手中拿着的牌 */
    for var p in 1...n-1 { /* 此时已经有一张牌在手，抽牌 */
        tmp = array[p]
        while p > 0 && array[p-1] > tmp { /// 抓的牌较小，手中牌后移
            array[p] = array[p-1]
            p -= 1
        }
        array[p] = tmp  /// p指向的是落牌点
    }
}

/*
 * 逆序对 对于下标i<j 如果A[i]>A[j],则称（i，j）是一对逆序对。 {34,64,61,32,21}九个
 * 逆序对 平均 N(N-1)/4
 * 相邻交换Ω(N^2)
 * Ω下限
 */

/**
 * 希尔排序
 *
 * 举个例子
 * __________________________________________________________________
 * | 81 | 94 | 11 | 96 | 12 | 35 | 17 | 95 | 28 | 58 | 41 | 75 | 15 |
 * ------------------------------------------------------------------
 * ↓
 * 5间隔排序
 * __________________________________________________________________
 * | 35 | 17 | 11 | 28 | 12 | 41 | 75 | 15 | 96 | 58 | 81 | 94 | 95 |
 * ------------------------------------------------------------------
 * ↓
 * 3间隔排序
 * __________________________________________________________________
 * | 28 | 12 | 11 | 35 | 15 | 41 | 58 | 17 | 94 | 75 | 81 | 96 | 95 |
 * ------------------------------------------------------------------
 * ↓
 * 1间隔排序
 * __________________________________________________________________
 * | 11 | 12 | 15 | 17 | 28 | 35 | 41 | 58 | 75 | 81 | 94 | 95 | 96 |
 * ------------------------------------------------------------------
 *
 * 定义增量序列 Dm > Dm-1 > ... > D1 = 1
 * 3间隔有序序列保持5间隔排序的性质
 * Dk间隔有序序列进行Dk-1间隔排序后仍然是Dk间隔有序的
 *
 * 最坏情况: T = θ( N2 )
 *
 * ________________________________________________________________________
 * | 1 | 9 | 2 | 10 | 3 | 11 | 4 | 12 | 5 | 13 | 6 | 14 | 7 | 15 | 8 | 16 |
 * ------------------------------------------------------------------------
 * 尝试 8 4 2 1增量序列
 * 会发现8，4，2增量排序不起作用
 * 增量元素不互质
 *
 *
 * Hibbard 增量序列
 *  Dk =2^k –1    相邻元素互质
 *  最坏情况: T = θ(N^3/2 )
 *  猜想: Tavg =O(N5/4 )
 *
 * Sedgewick增量序列
 *  {1, 5, 19, 41, 109, ... }
 *  获取序列的算法：9x4^i –9x2^i +1或4^i –3x2^i +1
 *  猜想:Tavg =O(N^7/6 )，Tworst =O(N^4/3 )
 *
 * 上万数量级的Sedgewick表现较好
 *
 */


/*简单选择排序▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒

 
 *方框绘制字符
 ┌─┬─┐
 │a│b│
 ├─┼─┤
 │ │ │
 └─┴─┘
 
 ╔═╦═╗
 ║ ║ ║
 ╠═╬═╣
 ║ ║ ║
 ╚═╩═╝
 
 */

// https://courses.cs.washington.edu/courses/cse373/02sp/lectures/cse373-14-ShellSort.pdf
 /* 希尔排序 - 用Sedgewick增量序列 */
public
func shellSort<Element: Comparable>(array: inout Array<Element>, n: Int) {
    //适用于万级别的 我的思考 插入排序小规模 ~20 ， ~20 * 1000 ≈ 10000
    let Sedgewick: [Int] = [929, 505, 209, 109 ,41, 19, 5, 1, 0]
    var Si, D, p, i : TCIndex
    var tmp: Element
    Si = 0
    while Sedgewick[Si] >= n { Si += 1 }
    for Si in (Si..<Sedgewick.count) {
        D = Sedgewick[Si]  /* 获取到增量序列的元素也就是间隔大小 */
        for p in D..<n { /* 插入排序 */
            tmp = array[p]
            i = p
            while i >= D, array[i-D] > tmp {
                array[i] = array[i-D]
                i -= D
            }
            array[i] = tmp
        }
    }
}






