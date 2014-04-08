//
//  ViewController.h
//  1
//
//  Created by System Administrator on 14-3-18.
//  Copyright (c) 2014年 System Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>
@interface ViewController : UIViewController<CLLocationManagerDelegate>
{
    NSMutableArray *_imagesArray;
    NSArray *image;
    //NSDictionary *readwindic;
   
}
@property (weak, nonatomic) IBOutlet UIView *scviewrightbar;
@property (weak, nonatomic) IBOutlet UIView *viewweather;
@property (weak, nonatomic) IBOutlet UILabel *labnowfl;
@property (weak, nonatomic) IBOutlet UILabel *labnowfx;
@property (weak, nonatomic) IBOutlet UILabel *labnowsd;
@property (weak, nonatomic) IBOutlet UILabel *labrttime;
@property (weak, nonatomic) IBOutlet UILabel *labweathertime;
@property (weak, nonatomic) IBOutlet UILabel *labsunout;
@property (weak, nonatomic) IBOutlet UILabel *labnightfl;
@property (weak, nonatomic) IBOutlet UILabel *labdayfl;
@property (weak, nonatomic) IBOutlet UILabel *labnightfx;
@property (weak, nonatomic) IBOutlet UILabel *labdayfx;
@property (weak, nonatomic) IBOutlet UILabel *labnighttemp;
@property (weak, nonatomic) IBOutlet UILabel *labdaytemp;
@property (weak, nonatomic) IBOutlet UILabel *labnightweather;
@property (weak, nonatomic) IBOutlet UILabel *labdayweather;
@property (weak, nonatomic) IBOutlet UILabel *labtoday;
@property (weak, nonatomic) IBOutlet UILabel *labmingtian;
@property (weak, nonatomic) IBOutlet UILabel *labhoutian;
@property (weak, nonatomic) IBOutlet UIScrollView *scollweather;
@property (weak, nonatomic) IBOutlet UILabel *labqh;
@property (weak, nonatomic) IBOutlet UILabel *labyb;
@property (weak, nonatomic) IBOutlet UILabel *labwd;
@property (weak, nonatomic) IBOutlet UILabel *labjb;
@property (weak, nonatomic) IBOutlet UILabel *labld;
@property (weak, nonatomic) IBOutlet UILabel *labhb;
@property (weak, nonatomic) IBOutlet UILabel *labjw;
@property (weak, nonatomic) IBOutlet UILabel *labguoen;
@property (weak, nonatomic) IBOutlet UILabel *nowtemp;
@property (weak, nonatomic) IBOutlet UILabel *labcity;
@property (weak, nonatomic) IBOutlet UILabel *labweather;
@property (weak, nonatomic) IBOutlet UILabel *labsheng;
@property (weak, nonatomic) IBOutlet UILabel *labguo;
@property (weak, nonatomic) IBOutlet UILabel *labcityen;
@property (weak, nonatomic) IBOutlet UILabel *labshien;
@property (weak, nonatomic) IBOutlet UILabel *labshengen;
@property (weak, nonatomic) IBOutlet UILabel *labshi;
@property (nonatomic) NSString * sublocality,*state,*nowcityid,*nowcityname,*appid3,*superkey,*data,*nowlocation;
@property (weak, nonatomic) IBOutlet UIScrollView *scviewcity;
@property (weak, nonatomic) IBOutlet UILabel *labdata;
@property (nonatomic) int flag_ok,jindu,flag_day,flag_dingwei;
@property (nonatomic)NSMutableArray * cityid,*allcity,*rightbarbutton;
@property (nonatomic)NSDictionary *readwindic,*rtweather,*fwweather,*zsweather,*readfx,*readfl,*readallcity;
@property (weak,nonatomic) IBOutlet UIButton * bt;
@property NSTimer *timer;
@property int touch_num;
@property int isPress;
@end
