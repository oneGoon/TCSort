//
//  Radix.swift
//  TCSort
//
//  Created by WangGang on 2019/12/10.
//  Copyright © 2019 onegoon. All rights reserved.
//
//TODO:初始化指定大小指定类型的数组 数组元素是class（引用类型） 初始化数组如果不确定大小，当buffer不够时扩容二倍，这样不断扩容也是性能损耗
//后续尝试指针方式创建足够大的buffer？

import Foundation
 //MARK: - 桶排序
///
///
///
///
/*
 
 基于比较的排序 最坏时间复杂度下界n·logn
 
 n个学生， 0~100的成绩，m=101个不同成绩
 
 为每一成绩值构造一个桶，创建101个桶
 创建一个数组
 每个元素是一个指针，初始化为空链表的头指针
 ┌───┬───┬───────┬───┬───────┬───┐
 │ 0 │ 1 │ ..... │ 66│ ......│100│
 ├───┼───┼───────┼───┼───────┼───┤
 │   │   │ ..... │   │ ..... │   │
 └─┼─┴─┼─┴───────┴─┼─┴───────┴─┼─┘
   █   █           █           █
       │           │
                   █
 T(n,m) = O(m+n)
 
 
 */
//public
//indirect enum LinkedList<Element: Comparable> {
//    case empty
//    case node(Element, LinkedList<Element>)
//
//    public func remove(_ element: Element) -> LinkedList<Element> {
//        guard case let .node(value, next) = self else {
//            return .empty
//        }
//        return value == element ? next :LinkedList.node(value, next.remove(element)) /// 这样并不好，会新建链表
//    }
//
//}
 
//struct node {
//    var value: Int
//    var next: node
//}
public
struct Student {
    
    let grade: Int
    let name: String
    
    public init(grade: Int, name: String) {
        self.grade = grade
        self.name = name
    }
}

extension Student: CustomStringConvertible {
    public var description: String {
        return "<" + "name: " + name + " \t" + "grade: " + String(grade) + ">"
    }
}

public
class Node<T> {
    var value: T
    var next: Node<T>?
    
    init(_ value: T, _ next: Node<T>? = nil) {
        self.value = value
        self.next = next
    }
}
/// 头结点
public
class HeadNode<T> {
    var head: Node<T>? = nil
    weak var tail: Node<T>? = nil
}


/// 单链表
public
struct LinkedList<T> {
    private var first: Node<T>? = nil
    private weak var last: Node<T>? = nil
    
    public var isEmpty: Bool {
        return first == nil
    }
    
    public var head: Node<T>? {
        return first
    }
    
    public var tail: Node<T>? {
        return last
    }
        
    public mutating func append(_ newNode: Node<T>?) {
//        let newNode = Node(value: value)
        if let tailNode = last {
            tailNode.next = newNode
        } else {
            first = newNode
        }
        last = newNode
        /// 无法直接确定是单一节点还是链表。 链表去掉封装方法 ？
        while last?.next != nil {
            last = last?.next
        }
        
    }
   
    public mutating func reHead(_ head: Node<T>?) {
        first = head
    }
}

public
func bucketSortStudent(array: inout Array<Student>, n: Int) {
    
    let bucketsNum = 101
    var buckets = Array.init(repeating: LinkedList<Student>(), count: bucketsNum)
//    var buckets: [LinkedList<Student>] = []
//    var buckets: [LinkedList<Student>] = Array<LinkedList<Student>>.init(unsafeUninitializedCapacity: bucketsNum, initializingWith: { buffer, initializedCount in
//        initializedCount = bucketsNum
//        buffer.initialize(repeating: LinkedList<Student>())
//    })
//    for _ in 0..<bucketsNum {
//        buckets.append(LinkedList<Student>())
//    }
    /* 读入成绩，插入对应的链表 */
    for student in array { buckets[student.grade].append(Node(student)) }
    /* 输出整个数组的所有链表 */
    var eIdx = 0
    for linkedlist in buckets {
        var node = linkedlist.head
        repeat {
            guard let value = node?.value else { break }
            array[eIdx] = value
            eIdx += 1
            node = node?.next
        } while true
    }
}

 //MARK: - 基数排序

/*
  当m很大的时候，桶数过多，效率降低
 
 n=10个整数，每个整数在0~999 于是有m=1000个不同值
 
 次位优先 LSD(Least Significant Digt)
 相对的有 主位优先 MSD(Most Significant Digt)
 
 T = O(P(n+b))
 
 */

/*
 
 输入序列：64，8，216，512，27，729，0，1，343，125
 基数是10（10进制）
 用次位优先

 ┌───────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
 │ Bucket│  0  │  1  │  2  │  3  │  4  │  5  │  6  │  7  │  8  │  9  │
 ╠═══════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╬═════╣
 │ Pass1 │ '0' │ '1' │51'2'│34'3'│ 6'4'│12'5'│21'6'│ 2'7'│ '8' │72'9'│
 └───────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
 │ Pass2 │  0  │5'1'2│1'2'5│     │3'4'3│     │ '6'4│     │     │     │
 │       │  1  │2'1'6│ '2'7│     │     │     │     │     │     │     │
 │       │  8  │     │7'2'9│     │     │     │     │     │     │     │
 └───────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
 │ Pass3 │  0  │1'2'5│'2'16│'3'43│     │'5'12│     │'7'29│     │     │
 │       │  1  │     │     │     │     │     │     │     │     │     │
 │       │  8  │     │     │     │     │     │     │     │     │     │
 │       │  27 │     │     │     │     │     │     │     │     │     │
 │       │  64 │     │     │     │     │     │     │     │     │     │
 └───────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
 
 */

/*
 多关键字排序
 
 扑克牌
 花色  主关键字
 面值  次关键字
 *主位优先MSD，为花色建4个桶
 *次位优先LSD，为面值建13个桶，合并结果，再建4个桶
 
 */

let maxDigit = 4
let radix = 10

/// 获取对应位置的数值
/// - Parameters:
///   - value: 给定整数值十进制
///   - maxDigit: 对应的位置
///   例子： getDigit(365, at: 2) 得到的数值为3
func getDigit(_ value: Int, at maxDigit: TCIndex) -> Int {
    var rlt: Int = value
    for _ in 0 ..< maxDigit {
        rlt /= radix
    }
    return rlt % radix
}

/// 链表封装方法 导致复杂度增加,这里使用表头只有头尾两个属性
public
func radixSort(array: inout [Int]) {
    //TODO:优雅的方式？
    /// 初始化每个桶为空链表
    var buckets = Array.init(repeating: HeadNode<Int>(), count: radix)
    for i in 0..<buckets.count { buckets[i] = HeadNode<Int>() }
    var list: Node<Int>?
    array.forEach { value in
        // 头插法
        let node = Node(value)
        node.next = list
        list = node
    }
    
    for d in 0..<maxDigit {
        while list != nil {
            let Di = getDigit(list!.value, at: d)
            let tmp = Node(list!.value)
            list = list?.next   ///  删除当前结点
            if buckets[Di].head == nil {
                buckets[Di].head = tmp
                buckets[Di].tail = tmp
            } else {
                buckets[Di].tail?.next = tmp
                buckets[Di].tail = tmp
            }
        }
        
        list = nil
        for Di in 0..<radix {
            if  buckets[Di].head != nil {
                buckets[Di].tail?.next = list
                list = buckets[Di].head
                buckets[Di].head = nil   /// 清除 桶对结点的引用
                buckets[Di].tail = nil
            }
        }
    }

    for i in (0..<array.count).reversed() {
        array[i] = list?.value ?? 0
        list = list?.next
    }
}


 //MARK: - 头插法
/* 放弃‘///’注释写文档，会导致格式错乱不一致
  ▓- - -█  █  █  █
  │     │
  └──█──┘
     new
*/

