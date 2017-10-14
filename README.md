# LQ4DirectionsScrollView
UITableView + UICollectionView 实现的二维滑动选择器, 可以上下左右四个方向滑动, 来选择不同的需求, 先来看一下效果:

![效果图](https://github.com/LQi2009/LQ4DirectionsScrollView/blob/master/test.gif)


# 说明
控件的上下滑动效果是使用UITableView来实现, 左右滑动是在tableViewCell中嵌套UICollectionView来实现的; 控件整体继承自UIView, 可以添加到任意的视图, 只需要设置好frame和dataSource即可, 这里主要说明其API方法和使用, 具体的实现可以阅读我[这篇文章](http://www.jianshu.com/p/9cb679ee2d56).主要是 LQ4DirectionsScrollView 文件夹下的两个文件: LQ4DirectionsScrollView.swift / LQ4DirectionTableViewCell.swift, 但这些只是实现了交互, 数据显示部分, 需要根据具体的业务场景来补偿, 但是有些需要注意的地方, 下面会讲到.

对外属性主要有这么几个:
```
var dataSource: [[T]] = []
var edgeInset: UIEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
/// 有效滑动距离, 值越小, 滑动越灵敏
var effectiveSlidingDistance: CGFloat = 30.0
var backgroundView: UIView?
```

其中必须要设置是 dataSource, 其他的都有默认值, 可以不用设置.

初始化方法, 这里提供了两个:

```
/// 初始化方法
    ///
    /// - Parameters:
    ///   - datas: 数据源, 数组内是小数组, 小数组中含有数据模型
    ///   - frame: frame
    ///   - didSelected: 选择回调
    ///   - didScrolled: 滚动回调
init(withDatas datas: [[T]], frame: CGRect, didSelected: LQ4DirectionsScrollViewHandle?, didScrolled: LQ4DirectionsScrollViewHandle?)
init(frame: CGRect)
```
可根据具体的业务设计来配置参数;

还有两个回调方法, 分别是: 滚动时的回调和选择时的回调
```
func didSelected(_ handle: @escaping LQ4DirectionsScrollViewHandle) -> LQ4DirectionsScrollView
func didScrolled(_ handle: @escaping LQ4DirectionsScrollViewHandle) -> LQ4DirectionsScrollView
```
这里的返回值, 是为了实现链式调用而设置的, 不需要的话可以不用关心.

文件主要实现了四个方向滑动的交互, 需要使用者补充主要有两个:
一个是数据源模型: 文件内部实现, 我使用了泛型来占位数据源类型, 内部不需要知道模型是何种类型, 只需要将数据源创建好后, 赋值给视图, 并指定泛型为具体的数据模型类型;
另一个是UICollectionViewCell, 用来展示数据内容的, 这个需要你们来实现

# 使用
首先, 建立一个数据模型, 这个随意, 什么样的都行, 根据自己的业务需求来设置:

```
class LQ4DirectionsModel: NSObject {

    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var name: String = ""
    
    var size: String {
        
        return "\(width)x\(height)cm"
    }
    
    var color: UIColor = UIColor.white
}
```

组织需要展示的数据:

```
func loadData() {
        
        let widths = [400, 200, 300, 400, 500, 300]
        let height = [500, 300, 300, 300, 400, 200]
        let colors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.cyan, UIColor.blue, UIColor.purple, self.radomColor()]
        let names = ["红", "橙", "黄", "绿", "青", "蓝", "紫", "随机"]
        
        for i in 0..<widths.count {
            var tmpArr: [LQ4DirectionsModel] = []
            
            for j in 0..<colors.count {
                let model = LQ4DirectionsModel()
                model.width = CGFloat(widths[i])
                model.height = CGFloat(height[i])
                model.color = colors[j]
                model.name = names[j]
                tmpArr.append(model)
            }
            
            dataSource.append(tmpArr)
        }
    }
```
  
> 这里需要注意: 数据源数组的格式, 里面含有的是小数组, 小数组内含有数据模型;

接着, 定义一个UICollectionViewCell 用来展示数据:
```
typealias LQ4CollectionCell = LQ4DirectionsCollectionViewCell
class LQ4DirectionsCollectionViewCell<T>: UICollectionViewCell {
    
    let bgview = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(bgview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configData(_ model: T) {
        let md = model as! LQ4DirectionsModel
        
//        self.backgroundColor = md.color
        bgview.backgroundColor = md.color
        var width = self.contentView.frame.width
        var height = md.height*width/md.width
        if height > self.contentView.frame.height {
            height = self.contentView.frame.height
            width = height*md.width/md.height
        }
        bgview.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        bgview.center = self.contentView.center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
```

> 这里有三点需要注意: <br>
其一是: 类名后加上泛型占位符 \<T\> <br>
其二是: 加上类型声明 typealias LQ4CollectionCell = LQ4DirectionsCollectionViewCell, = 左侧一定要是这个名称, = 右侧为你自定义的UICollectionViewCell类名, 这样做是为了减少改动源文件, 这样声明之后, 相当于把你定义的cell添加到了UICollectionView中;<br>
其三是: configData 方法, 名称一定要如此命名, 参数类型占位符要和上面类名后的占位符一致, 这里都是 T ;

```
func configData(_ model: T) {
        let md = model as! LQ4DirectionsModel
        // 下面是具体的配置数据内容
           
    }
```

然后, 创建 LQ4DirectionsScrollView 实例对象
> 这里需要注意的是, 创建 LQ4DirectionsScrollView 时一定要指明数据模型的类型, 即泛型的真正类型;

方式一:
```
let frame = CGRect(x: 40, y: 60, width: 200, height: 400)

        let scroll = LQ4DirectionsScrollView<LQ4DirectionsModel>(frame: frame)
        scroll.dataSource = dataSource
        
        scroll.backgroundColor = UIColor.brown
        //        scroll.edgeInset = UIEdgeInsets(top: 30, left: 40, bottom: 40, right: 50)
        let image = UIImage(named: "7.jpg")
        
        scroll.backgroundView = UIImageView(image: image)
        self.view.addSubview(scroll)

        scroll.didScrolled { (model) in
            print("over scrolled --\(model.name)-\(model.size)")
            
            
        }
        
        scroll.didSelected { (model) in
            print("over selected -- \(model.name)-\(model.size)")
        }
```

方式二:
```
let frame = CGRect(x: 20, y: 100, width: 200, height: 200)

        let scroll = LQ4DirectionsScrollView(withDatas: dataSource, frame: frame, didSelected: {[weak self] (model) in
            print("commit selected -- \(model.name)-\(model.size)")
            self?.alert("\(model.name) 色-大小: \(model.size)")
        }) {[weak self] (model) in
            print("backgroundView scrolled --\(model.name)-\(model.size)")
            self?.label.text = "\(model.name)\n大小: \(model.size)"
            self?.label.backgroundColor = model.color
        }
        
        scroll.backgroundColor = UIColor.brown
//        scroll.edgeInset = UIEdgeInsets(top: 30, left: 40, bottom: 40, right: 50)
        let image = UIImage(named: "7.jpg")
        
        scroll.backgroundView = UIImageView(image: image)
        self.view.addSubview(scroll)
        
```

方式三

```
let frame = CGRect(x: 40, y: 60, width: 200, height: 400)
        
        let scroll = LQ4DirectionsScrollView<LQ4DirectionsModel>(frame: frame).didScrolled { (model) in
            
            }.didSelected { (model) in
                
        }
        
        scroll.dataSource = dataSource
        
        scroll.backgroundColor = UIColor.brown
        //        scroll.edgeInset = UIEdgeInsets(top: 30, left: 40, bottom: 40, right: 50)
        let image = UIImage(named: "7.jpg")
        
        scroll.backgroundView = UIImageView(image: image)
        self.view.addSubview(scroll)
        
```
> 需要注意闭包的循环引用, 其中使用self时,要使用weak或者unowned修饰;

具体实现可以参看源文件, 代码量不是很大, 主要只有文件有三四百行代码, 或者参看博客[[Swift]使用UITableView+UICollectionView实现二维选择(四个方向滑动)](http://www.jianshu.com/p/9cb679ee2d56)

#### 如有帮助, 还请右上角 Star 或者 Fork
# (完)
