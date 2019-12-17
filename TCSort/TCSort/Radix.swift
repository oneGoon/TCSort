//
//  Radix.swift
//  TCSort
//
//  Created by WangGang on 2019/12/10.
//  Copyright © 2019 onegoon. All rights reserved.
//

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
   ▓   ▓           ▓           ▓
       │           │
                   ▓
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

extension Student: Comparable {
    public static func < (lhs: Student, rhs: Student) -> Bool {
        return lhs.grade < rhs.grade
    }
}
extension Student: CustomStringConvertible {
    public var description: String {
        return "<" + "name: " + name + " \t" + "grade: " + String(grade) + ">"
    }
}

public
class Node<T:Comparable> {
    var value: T
    var next: Node?
    
    init(value: T) {
        self.value = value
    }
}

public
struct LinkedList<T:Comparable> {
    fileprivate var head: Node<T>? = nil
    private var tail: Node<T>? = nil
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var first: Node<T>? {
        return head
    }
    
    public var last: Node<T>? {
        return tail
    }
    
    public mutating func append(value: T) {
        let newNode = Node(value: value)
        if let tailNode = tail {
            tailNode.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
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
    for student in array { buckets[student.grade].append(value: student) }
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
