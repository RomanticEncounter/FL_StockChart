//
//  FLStockModel.h
//  FL_StockChart
//
//  Created by mac on 2018/2/6.
//  Copyright © 2018年 LZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLStockModel : NSObject

/**
 *  日期
 */
@property (nonatomic, copy) NSDate *date;

/**
 *  开盘价
 */
@property (nonatomic, copy) NSNumber *open;


/**
 *  收盘价
 */
@property (nonatomic, copy) NSNumber *close;

/**
 *  最高价
 */
@property (nonatomic, copy) NSNumber *high;

/**
 *  最低价
 */
@property (nonatomic, copy) NSNumber *low;

/**
 均价
 */
@property (nonatomic, copy) NSNumber *avg;

//移动平均数分为MA（简单移动平均数）和EMA（指数移动平均数），其计算公式如下：［C为收盘价，N为周期数］：
//MA（N）=（C1+C2+……CN）/N

//MA（5）=（C1+C2+……CN）/5
@property (nonatomic, copy) NSNumber *MA5;
//MA（7）=（C1+C2+……CN）/7
@property (nonatomic, copy) NSNumber *MA7;
//MA（10）=（C1+C2+……CN）/10
@property (nonatomic, copy) NSNumber *MA10;
//MA（20）=（C1+C2+……CN）/20
@property (nonatomic, copy) NSNumber *MA20;
//MA（30）=（C1+C2+……CN）/30
@property (nonatomic, copy) NSNumber *MA30;

@property (nonatomic, copy) NSNumber *Volume_MA7;

@property (nonatomic, copy) NSNumber *Volume_MA30;

//KDJ(9,3.3),下面以该参数为例说明计算方法。
//9，3，3代表指标分析周期为9天，K值D值为3天
//RSV(9)=（今日收盘价－9日内最低价）÷（9日内最高价－9日内最低价）×100
//K(3日)=（当日RSV值+2*前一日K值）÷3
//D(3日)=（当日K值+2*前一日D值）÷3
//J=3K－2D

/**
 *  9Clock内最低价
 */
@property (nonatomic, copy) NSNumber *NineClocksMinPrice;

/**
 *  9Clock内最高价
 */
@property (nonatomic, copy) NSNumber *NineClocksMaxPrice;

@property (nonatomic, copy) NSNumber *RSV_9;

@property (nonatomic, copy) NSNumber *KDJ_K;

@property (nonatomic, copy) NSNumber *KDJ_D;

@property (nonatomic, copy) NSNumber *KDJ_J;


//MACD主要是利用长短期的二条平滑平均线，计算两者之间的差离值，作为研判行情买卖之依据。MACD指标是基于均线的构造原理，对价格收盘价进行平滑处 理(求出算术平均值)后的一种趋向类指标。它主要由两部分组成，即正负差(DIF)、异同平均数(DEA)，其中，正负差是核心，DEA是辅助。DIF是 快速平滑移动平均线(EMA1)和慢速平滑移动平均线(EMA2)的差。

//在现有的技术分析软件中，MACD常用参数是快速平滑移动平均线为12，慢速平滑移动平均线参数为26。此外，MACD还有一个辅助指标——柱状线 (BAR)。在大多数技术分析软件中，柱状线是有颜色的，在低于0轴以下是绿色，高于0轴以上是红色，前者代表趋势较弱，后者代表趋势较强。

//MACD(12,26.9),下面以该参数为例说明计算方法。

//12日EMA的算式为
//EMA（12）=昨日EMA（12）*11/13+C*2/13＝(C－昨日的EMA)×0.1538＋昨日的EMA；
//EMA（12）=前一日EMA（12）×11/13+今日收盘价×2/13
//即为MACD指标中的快线-快速平滑移动平均线；
// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
@property (nonatomic, copy) NSNumber *EMA12;

//26日EMA的算式为
//EMA（26）=昨日EMA（26）*25/27+C*2/27；
//EMA（26）=前一日EMA（26）×25/27+今日收盘价×2/27
//即为MACD指标中的慢线-慢速平滑移动平均线；

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
@property (nonatomic, copy) NSNumber *EMA26;

//DIF=EMA（12）-EMA（26）         DIF的值即为红绿柱；
//DIF=今日EMA（12）－今日EMA（26）
@property (nonatomic, copy) NSNumber *DIF;

//今日的DEA值（即MACD值）=前一日DEA*8/10+今日DIF*2/10.
//今日DEA（MACD）=前一日DEA×8/10+今日DIF×2/10计算出的DIF和DEA的数值均为正值或负值。
@property (nonatomic, copy) NSNumber *DEA;

//EMA（12）=昨日EMA（12）*11/13+C*2/13；   即为MACD指标中的快线；
//EMA（26）=昨日EMA（26）*25/27+C*2/27；   即为MACD指标中的慢线；
@property (nonatomic, copy) NSNumber *MACD;

@end
