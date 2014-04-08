//
//  FirstViewController.h
//  SideBarNavDemo
//
//  Created by JianYe on 12-12-11.
//  Copyright (c) 2012年 JianYe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>

@interface FirstViewController : UIViewController<CLLocationManagerDelegate>
{
    NSMutableArray *_imagesArray;
    NSArray *image;
    //NSDictionary *readwindic;
    
}
@property (nonatomic) IBOutlet UIView *scviewrightbar;
@property (nonatomic) IBOutlet UILabel *labnowfl;
@property (nonatomic) IBOutlet UILabel *labnowfx;
@property (nonatomic) IBOutlet UILabel *labnowsd;
@property (nonatomic) IBOutlet UILabel *labrttime;
@property (nonatomic) IBOutlet UILabel *labweathertime;
@property (nonatomic) IBOutlet UILabel *labsunout;
@property (nonatomic) IBOutlet UILabel *labnightfl;
@property (nonatomic) IBOutlet UILabel *labdayfl;
@property (nonatomic) IBOutlet UILabel *labnightfx;
@property (nonatomic) IBOutlet UILabel *labdayfx;
@property (nonatomic) IBOutlet UILabel *labnighttemp;
@property (nonatomic) IBOutlet UILabel *labdaytemp;
@property (nonatomic) IBOutlet UILabel *labnightweather;
@property (nonatomic) IBOutlet UILabel *labdayweather;
@property (nonatomic) IBOutlet UILabel *labtoday;
@property (nonatomic) IBOutlet UILabel *labmingtian;
@property (nonatomic) IBOutlet UILabel *labhoutian;
@property (nonatomic) IBOutlet UIView *scollweather;
@property (nonatomic) IBOutlet UILabel *labqh;
@property (nonatomic) IBOutlet UILabel *labyb;
@property (nonatomic) IBOutlet UILabel *labwd;
@property (nonatomic) IBOutlet UILabel *labjb;
@property (nonatomic) IBOutlet UILabel *labld;
@property (nonatomic) IBOutlet UILabel *labhb;
@property (nonatomic) IBOutlet UILabel *labjw;
@property (nonatomic) IBOutlet UILabel *labguoen;
@property (nonatomic) IBOutlet UILabel *nowtemp;
@property (nonatomic) IBOutlet UILabel *labcity;
@property (nonatomic) IBOutlet UILabel *labweather;
@property (nonatomic) IBOutlet UILabel *labsheng;
@property (nonatomic) IBOutlet UILabel *labguo;
@property (nonatomic) IBOutlet UILabel *labcityen;
@property (nonatomic) IBOutlet UILabel *labshien;
@property (nonatomic) IBOutlet UILabel *labshengen;
@property (nonatomic) IBOutlet UILabel *labshi;
@property (nonatomic) NSString * sublocality,*state,*nowcityid,*nowcityname,*appid3,*superkey,*data,*nowlocation;
@property (nonatomic) IBOutlet UIScrollView *scviewcity;
@property (nonatomic) IBOutlet UILabel *labdata;
@property (nonatomic) int flag_ok,jindu,flag_day,flag_dingwei;
@property (nonatomic)NSMutableArray * cityid,*allcity,*rightbarbutton;
@property (nonatomic)NSDictionary *readwindic,*rtweather,*fwweather,*zsweather,*readfx,*readfl,*readallcity;
@property (nonatomic) IBOutlet UIButton * bt;
@property NSTimer *timer;
@property int touch_num;
@property int isPress;
@property (strong,nonatomic)IBOutlet UILabel *titleLabel;

@property (assign,nonatomic) int index;
@property UILabel *ss;
@end
