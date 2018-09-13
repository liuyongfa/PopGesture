# PopGesture
自定义滑动返回，Custom swipes back

页面左边缘的UIButton按下、系统自带的滑动返回，这两个冲突。button按下会没有按下效果。

两种方法：

一、取巧

建一个UIPanGestureRecognizer，把它的target设成self.navigationController?.interactivePopGestureRecognizer?.delegate，action设成系统的私有方法"handleNavigationTransition:"，同时self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false。这样该手势就会调用系统的滑动返回函数，不用自己实现。

二、可以自定义滑动返回。

1.实现UINavigationControllerDelegate的俩个协议，一个返回自定义动画NavigationAnimator，一个返回动画进度管理UIPercentDrivenInteractiveTransition

2.添加一个UIPanGestureRecognizer，触发滑动，调用1实现的协议。

3.处理一些细节：添加topViewController左边缘的阴影，判断tabbar是否隐藏并处理等

![image](https://github.com/liuyongfa/PopGesture/blob/master/Untitled.gif)
