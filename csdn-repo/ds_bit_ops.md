@[toc]
# 前置知识
+ C++中，所有数都用二进制来存储，一般使用十进制来表示。
+ **可以将十进制数看作二进制数，直接运用二进制相关操作(取反，xor，左右移等)。**

# 技巧总结
+ ## 掩码：掩码获得特定0或者特定为1的位。
+ ## 二进制的相关操作(取负，取反，xor，左右移等)
# 获得第k位的值
> 使用 右移动 + 掩码操作
+ 对于$(1111)_2$，从右往左数是第0到3位。
```cpp
int getbit(int x,int k) {// return given bit value
	return x >> k & 1;
}
```
---
# `lowbit`函数：获得第k位以下的部分
```cpp
int lowbit(int x) {// return lowbit part 
	return x & -x;
}
```



# 例题
[P5657 [CSP-S 2019] 格雷码](https://www.luogu.com.cn/problem/P5657)：找规律
[P5514 [MtOI2019] 永夜的报应](https://www.luogu.com.cn/problem/P5514)：证明不等式，与贪心中的一种套路类似。$x XOR y<=x+y$
