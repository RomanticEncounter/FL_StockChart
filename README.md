# FL_StockChart


利用 CAShapeLayer + UIBezierpath 写的K线图Demo.

```objc
//分时线的创建方法
FLTimeChartView *timeChartView = [[FLTimeChartView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) * 0.75 - 20) StockGroupModel:self.stockModelArray];
[self.view addSubview:timeChartView];

 //分时线开始绘制
[self.timeChartView startDrawTimeChart];
 ```


 ```objc
 //k线的创建方法
 FLKLineChartView *kLineChartView = [[FLKLineChartView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) * 0.75 - 20)];
 self.kLineChartView.delegate = self;
 [self.view addSubview:kLineChartView];
 
 //设置数据
 [kLineChartView setKLineChartWithModel:self.stockModelArray];
 
 //k线开始绘制
 [self.kLineChartView drawKLineChart];
 ```
 
 ```objc
 //副图-指标
 FLAccessoryChartView *accessoryChartView = [[FLAccessoryChartView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame) * 0.75, CGRectGetWidth(frame), CGRectGetHeight(frame) * 0.25)];
 [self.view addSubview:accessoryChartView];
 
 //设置需要绘制的model - 直接绘制
 [accessoryChartView setAccessoryChartDataSource:needDrawModels];
 ```

#### Time-sharingplan
<img src="Screenshots/screenshots_01.png" width="50%" height="50%"/>

#### K-line
<img src="Screenshots/screenshots_02.png" width="50%" height="50%"/>

#### Indicator - Volume
<img src="Screenshots/screenshots_03.png" width="50%" height="50%"/>

#### Indicator - MACD
<img src="Screenshots/screenshots_04.png" width="50%" height="50%"/>

#### Indicator - KDJ
<img src="Screenshots/screenshots_05.png" width="50%" height="50%"/>
