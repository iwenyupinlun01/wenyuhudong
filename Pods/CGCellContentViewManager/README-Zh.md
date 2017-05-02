# CGCellContentViewManager

## 相关博客

[链接](http://www.jianshu.com/p/053065656fd2)

---

## 效果预览

![Overview.gif](https://raw.githubusercontent.com/CoderGin/CGCellContentViewManager/master/Overview.gif)

### 简介

一种优雅的方式去解决 UITableViewCell 在选中过程中，cell 的 contentView 中的子视图背景颜色变透明的问题

**常见解决方法**

取消 cell 原生的选中样式:

```

cell.selectionStyle = UITableViewCellSelectionStyleNone;

```

然后在 cell 的 contentView 中添加一个按钮，来模仿原生的 cell 高亮效果

但这似乎有点麻烦

**试试 CGCellContentViewManager 吧！**
**它可以帮你解决掉这些不必要的麻烦**

## 用法

只需要添加 `CGCellContentViewManager` 中的所有文件到你的工程中，不需要进行任何的设置，CGCellContentViewManager 就会生效。

当 cell 被点击时，所有 cell 的 contentView 中的子视图，将不再会改变颜色。

如果你想对某个 cell 关闭 CGCellContentViewManager 对它的自动管理：

```

cell.cg_cellContentViewManagerDisabled = YES;

```

如果你想对 cell 中的某个子视图关闭 CGCellContentViewManager 对它的自动管理：

```

customSubview.cg_cellContentViewManagerDisabled = YES;

```

### 兼容性

同时支持 Objective - C 和 Swift

Swift 工程中可以不添加 Objective -C Bridging Header

### CocoaPods

使用 CocoaPods 集成

```

pod 'CGCellContentViewManager', '1.0'

```

## 许可

MIT


