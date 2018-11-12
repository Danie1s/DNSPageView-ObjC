# DNSPageView-ObjC

[![Version](https://img.shields.io/cocoapods/v/DNSPageView-ObjC.svg?style=flat)](http://cocoapods.org/pods/DNSPageView-ObjC)
[![License](https://img.shields.io/cocoapods/l/DNSPageView-ObjC.svg?style=flat)](http://cocoapods.org/pods/DNSPageView-ObjC)
[![Platform](https://img.shields.io/cocoapods/p/DNSPageView-ObjC.svg?style=flat)](http://cocoapods.org/pods/DNSPageView-ObjC)

DNSPageView的Objective-C版本，是一个灵活且易于使用的pageView框架，titleView和contentView可以布局在任意地方，可以纯代码初始化，也可以使用xib或者storyboard初始化，并且提供了常见样式属性进行设置。

如果你使用的开发语言是Swift，请使用[DNSPageView](https://github.com/Danie1s/DNSPageView)

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Example](#example)
- [Usage](#usage)
  - [直接使用DNSPageView初始化](#直接使用dnspageview初始化)
  - [使用xib或者storyboard初始化](#使用xib或者storyboard初始化)
  - [使用DNSPageViewManager初始化，再分别对titleView和contentView进行布局](#使用dnspageviewmanager初始化，再分别对titleview和contentview进行布局)
  - [样式](#样式)
  - [事件监听](#事件监听)
  - [常见问题](#常见问题)
- [License](#license)

## Features:

- [x] 使用简单
- [x] 多种初始化方式
- [x] 灵活布局
- [x] 常见的样式
- [x] 双击titleView的回调
- [x] contentView滑动监听

## Requirements

- iOS 8.0+

- Xcode 9.0+



## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build DNSPageView.

To integrate DNSPageView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target '<Your Target Name>' do
    pod 'DNSPageView-ObjC'
end
```

Then, run the following command:

```bash
$ pod install
```


### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate DNSPageView-ObjC into your project manually.



## Example

To run the example project, clone the repo, and run `DNSPageView.xcodeproj` .

<img src="https://github.com/Danie1s/DNSPageView-ObjC/blob/master/Images/1.gif" width="30%" height="30%">

<img src="https://github.com/Danie1s/DNSPageView-ObjC/blob/master/Images/2.gif" width="30%" height="30%">

<img src="https://github.com/Danie1s/DNSPageView-ObjC/blob/master/Images/3.gif" width="30%" height="30%">

<img src="https://github.com/Danie1s/DNSPageView-ObjC/blob/master/Images/4.gif" width="30%" height="30%">





## Usage

### 直接使用DNSPageView初始化

```objective-c
// 创建DNSPageStyle，设置样式
DNSPageStyle *style = [[DNSPageStyle alloc] init];
style.titleViewScrollEnabled = YES;
style.titleScaleEnabled = YES;

// 设置标题内容
NSArray <NSString *>*titles = @[@"头条", @"视频", @"娱乐", @"要问", @"体育" , @"科技" , @"汽车" , @"时尚" , @"图片" , @"游戏" , @"房产"];

// 创建每一页对应的controller
NSMutableArray *childViewControllers = [NSMutableArray array];
for (NSString *title in titles) {
    ContentViewController *controller = [[ContentViewController alloc] initWithNibName: nil bundle:nil];
    controller.view.backgroundColor = [UIColor randomColor];
    [childViewControllers addObject:controller];
}

CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
CGSize size = [UIScreen mainScreen].bounds.size;

// 创建对应的DNSPageView，并设置它的frame
DNSPageView *pageView = [[DNSPageView alloc] initWithFrame:CGRectMake(0, y, size.width, size.height) style:style titles:titles childViewControllers:childViewControllers startIndex:0];
[self.view addSubview:pageView];
```



### 使用xib或者storyboard初始化

 在xib或者storyboard中拖出2个UIView，让它们分别继承DNSPageTitleView和DNSPageContentView，拖线到代码中

```objective-c
@property (weak, nonatomic) IBOutlet DNSPageTitleView *titleView;

@property (weak, nonatomic) IBOutlet DNSPageContentView *contentView;
```

对DNSPageTitleView和DNSPageContentView进行设置

```objective-c
// 创建DNSPageStyle，设置样式
DNSPageStyle *style = [[DNSPageStyle alloc] init];
style.titleViewBackgroundColor = [UIColor redColor];
style.showCoverView = YES;

// 设置标题内容
NSArray <NSString *>*titles = @[@"头条", @"视频", @"娱乐", @"要问", @"体育"];

// 设置默认的起始位置
NSInteger startIndex = 2;

// 对titleView进行设置
self.titleView.titles = titles;
self.titleView.style = style;
self.titleView.currentIndex = startIndex;

// 最后要调用setupUI方法
[self.titleView setupUI];

// 创建每一页对应的controller
NSMutableArray *childViewControllers = [NSMutableArray array];
for (NSString *title in titles) {
    ContentViewController *controller = [[ContentViewController alloc] init];
    controller.view.backgroundColor = [UIColor randomColor];
    [childViewControllers addObject:controller];
}

// 对contentView进行设置
self.contentView.childViewControllers = childViewControllers;
self.contentView.startIndex = startIndex;
self.contentView.style = style;

// 最后要调用setupUI方法
[self.contentView setupUI];

// 让titleView和contentView进行联系起来
self.titleView.delegate = self.contentView;
self.contentView.delegate = self.titleView;

```



### 使用DNSPageViewManager初始化，再分别对titleView和contentView进行布局

创建DNSPageViewManager

```objective-c
- (DNSPageViewManager *)pageViewManager {
    if (!_pageViewManager) {
        // 创建DNSPageStyle，设置样式
        DNSPageStyle *style = [[DNSPageStyle alloc] init];
        style.showBottomLine = YES;
        style.titleViewScrollEnabled = YES;
        style.titleViewBackgroundColor = [UIColor clearColor];
        
        // 设置标题内容
        NSArray <NSString *>*titles = @[@"头条", @"视频", @"娱乐", @"要问", @"体育"];
        
        // 创建每一页对应的controller
        NSMutableArray *childViewControllers = [NSMutableArray array];
        for (NSString *title in titles) {
            ContentViewController *controller = [[ContentViewController alloc] init];
            controller.view.backgroundColor = [UIColor randomColor];
            [childViewControllers addObject:controller];
        }
        _pageViewManager = [[DNSPageViewManager alloc] initWithStyle:style titles:titles childViewControllers:childViewControllers startIndex:0];
    }
    return _pageViewManager;
}
```

布局titleView和contentView

```objective-c
// 单独设置titleView的frame
self.navigationItem.titleView = self.pageViewManager.titleView;
self.pageViewManager.titleView.frame = CGRectMake(0, 0, 180, 44);

// 单独设置contentView的大小和位置，可以使用autolayout或者frame
DNSPageContentView *contentView = self.pageViewManager.contentView;
[self.view addSubview:contentView];
[contentView makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
}];

```



### 样式

DNSPageStyle中提供了常见样式的属性，可以按照不同的需求进行设置，包括可以设置初始显示的页面



### 事件监听

DNSPageView提供了常见事件监听的代理

```objective-c
/**
 如果contentView中的view需要实现某些刷新的方法，请让对应的childViewController遵守这个协议
 */
@protocol DNSPageReloaderDelegate <NSObject>
@optional


/**
 如果需要双击标题刷新或者作其他处理，请实现这个方法
 */
- (void)titleViewDidSelectedSameTitle;


/**
 如果pageContentView滚动到下一页停下来需要刷新或者作其他处理，请实现这个方法
 */
- (void)contentViewDidEndScroll;

@end
```



### 常见问题

- 标签比较少时，`titleView`不固定、会滑动

  当`style.isTitleViewScrollEnabled = YES`时，代表标签会比较多，所以默认会滑动。如果标签比较少，建议设置`style.isTitleViewScrollEnabled = NO`。

- 标签下划线的宽度跟随文字的宽度

  当`style.isTitleViewScrollEnabled = NO`时，表示标签比较少，默认每个标签平分整个`titleView`的宽度，而下划线的宽度等于标签的宽度，这种样式的需求也很常见。

  要想实现标签下划线的宽度跟随文字的宽度，需要设置`style.isTitleViewScrollEnabled = YES`，结合第一个问题，如果标签比较少，则需要手动计算标签的宽度，设置对应的`titleView`宽度，详细的代码可以参考demo中的第四种样式。


## License

DNSPageView-ObjC is available under the MIT license. See the LICENSE file for more info.


