//
//  FirstViewController.m
//  SideBarNavDemo
//
//  Created by JianYe on 12-12-11.
//  Copyright (c) 2012年 JianYe. All rights reserved.
//


#define SNOW_IMAGENAME         @"1"
#define IMAGE_X                arc4random()%(int)Main_Screen_Width
#define IMAGE_ALPHA            ((float)(arc4random()%10))/10
#define IMAGE_WIDTH            arc4random()%20 + 10
#define PLUS_HEIGHT            Main_Screen_Height/25

#import "ViewController.h"
#import "FMDB.h"
#import "AppDelegate.h"
#import "FirstViewController.h"
#import "SidebarViewController.h"
#import "SecondViewController.h"
@implementation CLLocationManager (TemporaryHack)

-(void)hackLocationFix
{
    
    //CLLocation *location = [[CLLocation alloc] initWithLatitude:42 longitude:-50];
    //AppDelegate *mydel = [[UIApplication sharedApplication]delegate];
    NSLog(@"start seach ");
    float latitude = 40.026;
    float longitude = 116.23;  //这里可以是任意的经纬度值
    
    CLLocation *location= [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [[self delegate] locationManager:self didUpdateToLocation:location fromLocation:location];
}

-(void)startUpdatingLocation
{
    
    [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.01];
    
}

@end

@interface FirstViewController ()
{
    CLLocationManager *locationManager;
    CLLocation *checkinLocation;
}

@end

@implementation FirstViewController
@synthesize titleLabel,index;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - ibaction

- (IBAction)showLeftSideBar:(id)sender
{
    if ([[SidebarViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
        [[SidebarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
    }
}

- (IBAction)showRightSideBar:(id)sender
{
    if ([[SidebarViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
        [[SidebarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionRight];
    }
}

- (IBAction)pushAction:(id)sender
{
    SecondViewController *secondCon = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    [self.navigationController  pushViewController:secondCon animated:YES];
}


-(NSDictionary *)serchWeather : (NSString *) type : (NSString *)cityid
{
    NSLog(@"refer weathering ....");
    NSError *error;
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddhhmm"];
    date = [formatter stringFromDate:[NSDate date]];
    self.data = date;
    NSString *surl1 = [NSString stringWithFormat:@"http://webapi.weather.com.cn/data/?areaid=%@&type=%@&date=%@&appid=f7e3efc31407db6d",cityid,type,self.data];
    NSString * key = [self hmacSha1:@"3edbe9_SmartWeatherAPI_4ff3e05" text:surl1];
    NSString *skey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.superkey = skey;
    
    NSString * surl = [NSString stringWithFormat:@"http://webapi.weather.com.cn/data/?areaid=%@&type=%@&date=%@&appid=%@&key=%@",cityid,type,self.data,self.appid3,self.superkey];
    NSURL * url = [NSURL URLWithString:surl];
    NSString *data = [NSString stringWithContentsOfURL:url encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8) error:&error];
    NSData *data1 =[data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *Dic1 = [NSJSONSerialization JSONObjectWithData:data1
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    
    
    return Dic1;
}
-(NSString *)serchid : (NSString *) cityname
{
    NSString *dbPath = @"/private/var/root/Desktop/smartweather.db";
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    NSLog(@"open db file ok!");
    NSLog(@"%@",cityname);
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM citys where name3 like '%%%@%%'",cityname];
    FMResultSet *result = [db executeQuery:sql];
    NSString * r;
    //self.cityid = [[NSMutableArray alloc]init];
    
    while ([result next])
    {
        NSLog(@"cityname:%@     num %@",[result stringForColumn:@"name3"],r = [result stringForColumn:@"num"]);
        self.nowcityid = r;
        //[self.cityid addObject:r];
        ;
    }
    [self addcitytodic:cityname:r];
    [self addcitytodic:@"1020":@"101210901"];
    
    [self.allcity addObject:cityname];
    self.jindu = 0;
    [db close];
    return r;
}
- (void) setupLocationManager
{
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    if ([CLLocationManager locationServicesEnabled])
    {
        NSLog( @"Starting CLLocationManager" );
        locationManager.delegate = self;
        locationManager.distanceFilter = 200;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [locationManager startUpdatingLocation];
    }
    else
    {
        NSLog( @"Cannot Starting CLLocationManager" );
        locationManager.delegate = self;
        locationManager.distanceFilter = 200;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    checkinLocation = newLocation;
    NSLog(@"dingwei ing .......");
    //定位城市通过CLGeocoder
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for (CLPlacemark * placemark in placemarks)
         {
             NSLog(@"Country = %@", placemark.country);
             NSLog(@"Postal Code = %@", placemark.postalCode);
             NSLog(@"Locality = %@", placemark.locality);
             self.nowlocation = placemark.locality;
             NSLog(@"dic Name = %@", [placemark.addressDictionary objectForKey:@"Name"]);
             self.state =[placemark.addressDictionary objectForKey:@"State"];
             
             NSLog(@"dic State = %@", [placemark.addressDictionary objectForKey:@"State"]);
             
             NSLog(@"dic Street = %@", [placemark.addressDictionary objectForKey:@"Street"]);
             self.sublocality = [placemark.addressDictionary objectForKey:@"SubLocality"];
             NSLog(@"dic SubLocality= %@", [placemark.addressDictionary objectForKey:@"SubLocality"]);
             
             NSLog(@"dic SubThoroughfare= %@", [placemark.addressDictionary objectForKey:@"SubThoroughfare"]);
             
             NSLog(@"dic Thoroughfare = %@", [placemark.addressDictionary objectForKey:@"Thoroughfare"]);
             
             if(self.sublocality != NULL)
                 self.nowcityname = self.sublocality;
             else
             {
                 if(self.nowlocation != NULL)
                     self.nowcityname = self.nowlocation;
                 else
                     self.nowcityname = self.state;
             }
             self.nowcityid = [self serchid:self.nowcityname];
             self.fwweather = [self serchWeather:@"forecast3d":self.nowcityid];
             self.rtweather = [self serchWeather:@"observe":self.nowcityid];
             self.zsweather = [self serchWeather:@"index":self.nowcityid];
             NSLog(@"%@",self.rtweather);
             NSLog(@"%@",self.fwweather);
             NSLog(@"%@",self.zsweather);
             NSLog(@"%@",[[[self.zsweather objectForKey:@"i"] objectAtIndex:0] objectForKey:@"i5"]);
             [self display];
             self.flag_dingwei = 1;
         }
     }];
    
    
}
-(void)display
{
    if([self.readwindic objectForKey:[[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:0] objectForKey:@"fa"]] == NULL)
    {
        self.labweather.text = [self.readwindic objectForKey:[[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:0] objectForKey:@"fa"]];
    }
    else
    {
        self.labweather.text = [self.readwindic objectForKey:[[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:0] objectForKey:@"fb"]];
    }
    
   
    
    self.labcityen.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c2"];
    self.labcity.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c3"];
    self.labshien.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c4"];
    self.labshi.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c5"];
    self.labshengen.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c6"];
    self.labsheng.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c7"];
    self.labguoen.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c8"];
    self.labguo.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c9"];
    self.labjb.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c10"];
    self.labqh.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c11"];
    self.labyb.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c12"];
    self.labwd.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c14"];
    self.labjw.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c13"];
    self.labld.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c16"];
    self.labhb.text = [[self.fwweather objectForKey:@"c"] objectForKey:@"c15"];
    
    
    UIImageView *imageView1;
    if([self.readwindic objectForKey:[[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:0] objectForKey:@"fa"]] == NULL)
    {
        imageView1= [[UIImageView alloc] initWithImage:IMAGENAMED([[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:0] objectForKey:@"fb"])];
    }
    else
    {
        imageView1= [[UIImageView alloc] initWithImage:IMAGENAMED([[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:0] objectForKey:@"fa"])];
    }
   
    
    imageView1.frame = CGRectMake(30,10, 100, 100);
    [self.view addSubview:imageView1];
    NSLog(@"%@",[[self.rtweather objectForKey:@"l"] objectForKey:@"l1"]);
    self.nowtemp.text = [[self.rtweather objectForKey:@"l"] objectForKey:@"l1"];
    self.labrttime.text = [[self.rtweather objectForKey:@"l"] objectForKey:@"l7"];
    self.labnowfl.text = [self.readfl objectForKey:[[self.rtweather objectForKey:@"l"] objectForKey:@"l3"] ];
    self.labnowfx.text = [self.readfx objectForKey:[[self.rtweather objectForKey:@"l"] objectForKey:@"l4"] ];
    self.labnowsd.text = [[self.rtweather objectForKey:@"l"] objectForKey:@"l2"];
    NSString* date;
    NSDate*date1 = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSString *a1 = @"周日";
    NSString *a2 = @"周一";
    NSString *a3 = @"周二";
    NSString *a4 = @"周三";
    NSString *a5 = @"周四";
    NSString *a6 = @"周五";
    NSString *a7 = @"周六";
    
    NSArray *week = [[NSArray alloc] initWithObjects:a1,a2,a3,a4,a5,a6,a7, nil];
    [formatter setDateFormat:@"YY年MM月dd日"];
    date = [formatter stringFromDate:[NSDate date]];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:(NSWeekCalendarUnit|NSWeekdayCalendarUnit|NSWeekdayOrdinalCalendarUnit)fromDate:date1];
    long int weekday = [comps weekday];
    self.labtoday.text = @"今天";
    self.labmingtian.text = [NSString stringWithString:[week objectAtIndex:(weekday)%7]];
    self.labhoutian.text = [NSString stringWithString:[week objectAtIndex:(weekday + 1)%7]];
    self.labmingtian.textColor = [UIColor darkGrayColor];
    self.labhoutian.textColor = [UIColor darkGrayColor];
    self.labdata.text = date;
    [self showfweather];
}
-(void)showfweather
{
    self.labdayweather.text = [self.readwindic objectForKey:[[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:self.flag_day - 1] objectForKey:@"fa"]];
    self.labnightweather.text = [self.readwindic objectForKey:[[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:self.flag_day - 1] objectForKey:@"fb"]];
    self.labdaytemp.text = [[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:self.flag_day - 1] objectForKey:@"fc"];
    self.labnighttemp.text = [[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:self.flag_day - 1] objectForKey:@"fd"];
    
    self.labdayfx.text = [self.readfx objectForKey:[[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:self.flag_day - 1] objectForKey:@"fe"]];
    self.labnightfx.text = [self.readfx objectForKey:[[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:self.flag_day - 1] objectForKey:@"ff"]];
    
    self.labdayfl.text = [self.readfl objectForKey:[[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:self.flag_day - 1] objectForKey:@"fg"]];
    self.labnightfl.text = [self.readfl objectForKey:[[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:self.flag_day - 1] objectForKey:@"fh"]];
    
    self.labsunout.text = [[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:self.flag_day - 1] objectForKey:@"fi"];
    self.labweathertime.text = [[self.fwweather objectForKey:@"f"] objectForKey:@"f0"];
    
}
-(NSString *) hmacSha1:(NSString*)key text:(NSString*)text
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    int i;
    for(i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    
    NSData *data1 = [NSData dataWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString * key1 = [data1 base64Encoding];
    return key1;
}
-(void)chushihua
{
    NSString *winfilename1 = @"/var/root/Desktop/1/1/win1.txt";
    NSString *winfilename2 = @"/var/root/Desktop/1/1/win2.txt";
    NSString *winfilename3 = @"/var/root/Desktop/1/1/win3.txt";
    NSString *cityfileName = @"/var/root/Desktop/1/1/citydic.txt";
    
    self.readwindic = [NSDictionary dictionaryWithContentsOfFile:
                       winfilename1];
    self.readfx = [NSDictionary dictionaryWithContentsOfFile:
                   winfilename2];
    self.readfl = [NSDictionary dictionaryWithContentsOfFile:
                   winfilename3];
    self.readallcity = [NSDictionary dictionaryWithContentsOfFile:
                        cityfileName];
    
}
-(void) handleTimer: (NSTimer *) timer
{
    NSLog(@"nstimer");
    if(self.flag_dingwei == 0)
    {
        [locationManager startUpdatingLocation];
        [self setupLocationManager];
    }
    if(self.flag_dingwei == 1)
    {
        [self weathermove:1];
        [self.timer invalidate];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self labinit];
    self.titleLabel.text = [NSString stringWithFormat:@"%d",self.index];
    NSLog(@"yy");
    [self chushihua];
    //self.view.frame = CGRectMake(0, 0, 500, 600);
    self.flag_day = 1;
    self.flag_dingwei = 0;
    self.isPress = 0;
    self.scviewrightbar.center = CGPointMake(358,284);
    self.appid3 = @"f7e3ef";
    [self rightbarinit];
    [self allcityweather];
   
    self.allcity = [[NSMutableArray alloc] init];
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 4
                                                  target: self
                                                selector: @selector(handleTimer:)
                                                userInfo: nil
                                                 repeats: YES];
    [locationManager startUpdatingLocation];
    [self setupLocationManager];
    self.scviewcity.contentSize = CGSizeMake(200,120);
    
    //[self.superview addSubview:self.view];
}
-(UIImage*)saveImage
{
    UIGraphicsBeginImageContext(CGSizeMake(self.scollweather.bounds.size.width, self.scollweather.bounds.size.height));
    [self.scollweather.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}
-(void)rightbar
{
    NSLog(@"set barr  11111");
    int  i = 0;
    for(UIButton *a in self.rightbarbutton)
    {
        NSLog(@"%d",i);
        a.frame = CGRectMake(75,15 + i * 55, 50, 50);
        a.alpha = 1 ;
        
        //[a addSubview:self.viewweather];
        [UIView beginAnimations:Nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        a.frame = CGRectMake(15, 15 + i++ * 55, 50, 50);
        [self.scviewrightbar addSubview:a];
        [UIView commitAnimations];
        [a addTarget:self action:@selector(upInside) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
-(void)addcitytodic :(NSString *)cityname : (NSString *)cityid
{
    NSString *fileName = @"/var/root/Desktop/1/1/citydic.txt";
    NSLog(@"dic ok!");
    NSMutableDictionary * readDict = [[NSMutableDictionary alloc] init];
    readDict = [NSDictionary dictionaryWithContentsOfFile:fileName];
    NSLog(@"%@",readDict);
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:cityname,cityid, nil];
    
    [readDict addEntriesFromDictionary:dict];
    
    NSLog(@"dict:%@",dict);
    NSLog(@"readdict:%@",readDict);
    if(readDict == NULL)
        [dict writeToFile:fileName atomically:YES];
    else
        [readDict writeToFile:fileName atomically:YES];
}
-(void)rightbarinit
{
    NSLog(@"set barr  hh");
    UIButton *addcity = [[UIButton alloc] init];
    [addcity addTarget:self action:@selector(addcitybutton) forControlEvents:UIControlEventTouchDragInside];
    UIImage * addcity_im = [UIImage imageNamed:@"iconpng.png"];
    [addcity setImage:addcity_im forState:UIControlStateNormal];
    addcity.frame = CGRectMake(75, 15, 50, 50);
    [self.scviewrightbar addSubview:addcity];
    self.rightbarbutton = [[NSMutableArray alloc] init];
    [self.rightbarbutton addObject:addcity];
    
}

-(void)rightbarmove : (int)flag
{
    NSLog(@"right move :%d",flag);
    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    if(self.view.center.x <= 120.00)
    {
        self.view.center = CGPointMake(87, self.view.center.y);
    }
    else
    {
        self.view.center = CGPointMake(160, self.view.center.y);
        for(UIButton *a in self.rightbarbutton)
        {
            NSLog(@"iiiii");
            a.alpha = 0;
        }
        
    }
    
    [UIView commitAnimations];
    if(self.view.center.x == 87)
        [self performSelector:@selector(rightbar) withObject:nil afterDelay:0.4f];
}
-(void)weathermove : (int)flag
{
    UIImage *weather = [self saveImage];
    UIButton * bt = [[UIButton alloc] init];
    [bt setImage:weather forState:UIControlStateNormal];
   // bt.backgroundColor = [UIColor blackColor];
    if(flag == 1)
    {
        NSLog(@"swipe left");
        self.flag_day += 1;
        if(self.flag_day >= 4)
            self.flag_day = 1;
        [self showfweather];
        self.labmingtian.textColor = [UIColor darkGrayColor];
        self.labhoutian.textColor = [UIColor darkGrayColor];
        self.labtoday.textColor = [UIColor darkGrayColor];
        switch (self.flag_day)
        {
            case 1:
                self.labtoday.textColor = [UIColor greenColor];
                break;
            case 2:
                self.labmingtian.textColor = [UIColor greenColor];
                break;
            case 3:
                self.labhoutian.textColor = [UIColor greenColor];
                break;
            default:
                break;
        }
        bt.frame = CGRectMake(self.scollweather.frame.size.height,self.scollweather.frame.size.width -10 ,weather.size.width,weather.size.height);
        [self.view addSubview:bt];
    }
    if(flag == 2)
    {
        NSLog(@"swipe right");
        self.flag_day -= 1;
        if(self.flag_day <= 0)
            self.flag_day = 3;
        
        [self showfweather];
        self.labmingtian.textColor = [UIColor darkGrayColor];
        self.labhoutian.textColor = [UIColor darkGrayColor];
        self.labtoday.textColor = [UIColor darkGrayColor];
        switch (self.flag_day)
        {
            case 1:
                self.labtoday.textColor = [UIColor greenColor];
                break;
            case 2:
                self.labmingtian.textColor = [UIColor greenColor];
                break;
            case 3:
                self.labhoutian.textColor = [UIColor greenColor];
                break;
            default:
                break;
        }
        bt.frame = CGRectMake(self.scollweather.frame.size.height - 640,self.scollweather.frame.size.width -10 ,weather.size.width,weather.size.height);
        [self.view addSubview:bt];
    }
    

    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    if(flag == 1)
        self.scollweather.center=CGPointMake(self.scollweather.center.x - 200, self.scollweather.center.y);
    if(flag == 2)
        self.scollweather.center=CGPointMake(self.scollweather.center.x + 200, self.scollweather.center.y);
    bt.center = CGPointMake(160, self.scollweather.center.y);
    //  bt.frame = CGRectMake(self.viewweather.frame.size.height  -270,self.viewweather.frame.size.width - 10 ,weather.size.width,weather.size.width);
    [UIView commitAnimations];
    self.bt = bt;
    [self performSelector:@selector(weatherredisplay) withObject:nil afterDelay:0.4f];
    // [self performSelector:@selector(weatherredisplay) withObject:bt afterDelay:0.01];
}
-(void)weatherredisplay
{
    self.bt.frame = CGRectMake(0,0,0,0);
    self.scollweather.center=CGPointMake(160, self.scollweather.center.y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)allcityweather
{
    for(NSString *cityid in [self.readallcity allKeys])
    {
        NSLog(@"city id  is: %@",cityid);
        NSDictionary *weather = [self serchWeather:@"forecast3d":cityid];
        NSDictionary *weather2 = [self serchWeather:@"observe":cityid];
        NSLog(@"weather ok!!!;%@",weather);
        UIView * litleview = [[UIView alloc] init];
        litleview.frame = CGRectMake(1000, 100, 50, 50);
        litleview.backgroundColor = [UIColor grayColor];
        [self.view addSubview:litleview];
        UILabel * cityname = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 50, 10)];
        cityname.font = [UIFont fontWithName:@"ArialMT" size:12];
        cityname.text = [[weather objectForKey:@"c"] objectForKey:@"c3"];
        [litleview addSubview:cityname];
        UILabel * labweather = [[UILabel alloc] initWithFrame:CGRectMake(2, 19, 50, 10)];
        labweather.font = [UIFont fontWithName:@"ArialMT" size:12];
        labweather.text = @"晴";
        
        NSLog(@"weather:%@",[self.readwindic objectForKey:[[[[weather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:0] objectForKey:@"fa"]]);
        if([self.readwindic objectForKey:[[[[weather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:0] objectForKey:@"fa"]] == NULL)
        {
            labweather.text = [self.readwindic objectForKey:[[[[weather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:0] objectForKey:@"fa"]];
        }
        else
        {
            labweather.text = [self.readwindic objectForKey:[[[[weather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:0] objectForKey:@"fb"]];
        }
        [litleview addSubview:labweather];
        UILabel * fx = [[UILabel alloc] initWithFrame:CGRectMake(2, 35, 50, 10)];
        fx.font = [UIFont fontWithName:@"ArialMT" size:12];
        fx.text = [self.readfx objectForKey:[[weather2 objectForKey:@"l"] objectForKey:@"l4"] ];
        [litleview addSubview:fx];
        
        UIImageView * im;
        if([self.readwindic objectForKey:[[[[weather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:0] objectForKey:@"fa"]] == NULL)
        {
            im = [[UIImageView alloc] initWithImage:IMAGENAMED([[[[self.fwweather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:0] objectForKey:@"fb"])];
        }
        else
        {
            im = [[UIImageView alloc] initWithImage:IMAGENAMED([[[[weather objectForKey:@"f"] objectForKey:@"f1"] objectAtIndex:0] objectForKey:@"fa"])];
        }
        
        
        [litleview addSubview:im];
        im.frame = CGRectMake(25, 10, 25, 25);
        [self.view addSubview:litleview];
        
        UIGraphicsBeginImageContext(CGSizeMake(litleview.bounds.size.width,litleview.bounds.size.height));
        [litleview.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(75, 15, 50, 50)];
        [bt setImage:viewImage forState:UIControlStateNormal];
        [self.scviewrightbar addSubview:bt];
        [self.rightbarbutton addObject:bt];
    }
}
-(void)addcitybutton
{
    NSLog(@"add");
}
- (void)dragInside
{
    
    NSLog(@"dragInside...");
    
}
- (void)dragOutside

{
    
    NSLog(@"dragOutside...");
    
}
- (void)upInside
{
    
    NSLog(@"upInside...");
    
}
-(void)labinit
{
    self.scviewcity = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 127, 280, 81)];
    [self.view addSubview:self.scviewcity];
    self.scollweather = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 270, 280, 288)];
    //self.scollweather.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.scollweather];
    self.labweather = [[UILabel alloc] initWithFrame:CGRectMake(154,60, 34, 21)];
    [self.view addSubview:self.labweather];
    
    self.labnowfl = [[UILabel alloc] initWithFrame:CGRectMake(170, 108, 136, 21)];
    self.labnowfl.font = [UIFont fontWithName:@"ArialMT" size:12];
    [self.view addSubview:self.labnowfl];
    self.labnowfx = [[UILabel alloc] initWithFrame:CGRectMake(125, 108,59, 21)];
    self.labnowfx.font = [UIFont fontWithName:@"ArialMT" size:12];
    [self.view addSubview:self.labnowfx];
    self.labnowsd = [[UILabel alloc] initWithFrame:CGRectMake(59, 108, 42, 21)];
    self.labnowsd.font = [UIFont fontWithName:@"ArialMT" size:12];
    [self.view addSubview:self.labnowsd];
    self.labrttime = [[UILabel alloc] initWithFrame:CGRectMake(219, 88, 55, 21)];
    self.labrttime.font = [UIFont fontWithName:@"ArialMT" size:12];
    [self.view addSubview:self.labrttime];
    
    
    UILabel * time = [[UILabel alloc] initWithFrame:CGRectMake(0, 270, 150, 21)];
    time.text = @"气象发布时间：";
    time.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:time];

    self.labweathertime = [[UILabel alloc] initWithFrame:CGRectMake(107, 270, 124, 19)];
    self.labweathertime.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:self.labweathertime];
    
    
    UILabel * sunout = [[UILabel alloc] initWithFrame:CGRectMake(0, 242, 150, 21)];
    sunout.text = @"日出日落时间：";
    sunout.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:sunout];
    self.labsunout = [[UILabel alloc] initWithFrame:CGRectMake(107, 242, 92, 21)];
    self.labsunout.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:self.labsunout];
    
    
    UILabel * nightfl = [[UILabel alloc] initWithFrame:CGRectMake(0, 212, 150, 21)];
    nightfl.text = @"晚上风力：";
    nightfl.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:nightfl];
    self.labnightfl = [[UILabel alloc] initWithFrame:CGRectMake(78, 212, 153, 21)];
    self.labnightfl.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:self.labnightfl];
    
    UILabel * dayfl = [[UILabel alloc] initWithFrame:CGRectMake(0, 184, 150, 21)];
    dayfl.text = @"白天风力：";
    dayfl.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:dayfl];

    self.labdayfl = [[UILabel alloc] initWithFrame:CGRectMake(78, 184, 153, 21)];
    self.labdayfl.font = [UIFont fontWithName:@"ArialMT" size:15];
    self.labdayfl.text = @"暂无数据";
    [self.scollweather addSubview:self.labdayfl];
    
    
    UILabel * nightfx = [[UILabel alloc] initWithFrame:CGRectMake(0, 156, 150, 21)];
    nightfx.text = @"晚上风向：";
    nightfx.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:nightfx];
    self.labnightfx = [[UILabel alloc] initWithFrame:CGRectMake(78, 156, 121, 21)];
    self.labnightfx.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:self.labnightfx];
    
    
    UILabel * dayfx = [[UILabel alloc] initWithFrame:CGRectMake(0, 126, 150, 21)];
    dayfx.text = @"白天风向：";
    dayfx.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:dayfx];
    self.labdayfx = [[UILabel alloc] initWithFrame:CGRectMake(78, 126, 121, 21)];
    self.labdayfx.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:self.labdayfx];
    
    
    UILabel * nighttemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 96, 150, 21)];
    nighttemp.text = @"晚上温度：";
    nighttemp.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:nighttemp];
    self.labnighttemp = [[UILabel alloc] initWithFrame:CGRectMake(78, 96, 121, 21)];
    self.labnighttemp.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:self.labnighttemp];
    
    UILabel * daytemp = [[UILabel alloc] initWithFrame:CGRectMake(0, 68, 150, 21)];
    daytemp.text = @"白天温度：";
    daytemp.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:daytemp];
    self.labdaytemp = [[UILabel alloc] initWithFrame:CGRectMake(78, 68, 121, 21)];
    self.labdaytemp.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:self.labdaytemp];
    
   
    UILabel * nightweather = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, 150, 21)];
    nightweather.text = @"晚上气象：";
    nightweather.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:nightweather];
    self.labnightweather = [[UILabel alloc] initWithFrame:CGRectMake(78, 38, 121, 21)];
    self.labnightweather.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:self.labnightweather];
    
    
    UILabel * dayweather = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 150, 21)];
    dayweather.text = @"白天气象：";
    dayweather.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:dayweather];
    self.labdayweather = [[UILabel alloc] initWithFrame:CGRectMake(78, 10, 121, 21)];
    self.labdayweather.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scollweather addSubview:self.labdayweather];
    
    
    self.labtoday = [[UILabel alloc] initWithFrame:CGRectMake(92, 248, 55, 21)];
    [self.view addSubview:self.labtoday];
    self.labmingtian = [[UILabel alloc] initWithFrame:CGRectMake(145, 248, 55, 21)];
     [self.view addSubview:self.labmingtian];
    self.labhoutian = [[UILabel alloc] initWithFrame:CGRectMake(200, 248, 55, 21)];
     [self.view addSubview:self.labhoutian];
  
    self.labqh = [[UILabel alloc] initWithFrame:CGRectMake(158, 230, 42, 21)];
    [self.view addSubview:self.labqh];
    self.labqh.font = [UIFont fontWithName:@"ArialMT" size:12];
    self.labyb = [[UILabel alloc] initWithFrame:CGRectMake(218, 230, 42, 21)];
    [self.view addSubview:self.labyb];
    self.labyb.font = [UIFont fontWithName:@"ArialMT" size:12];
    self.labwd = [[UILabel alloc] initWithFrame:CGRectMake(35, 230, 76, 21)];
    [self.view addSubview:self.labwd];
    self.labwd.font = [UIFont fontWithName:@"ArialMT" size:12];
    self.labjw = [[UILabel alloc] initWithFrame:CGRectMake(35, 214, 76, 21)];
    [self.view addSubview:self.labjw];
    self.labjw.font = [UIFont fontWithName:@"ArialMT" size:12];
    
    self.labhb = [[UILabel alloc] initWithFrame:CGRectMake(158, 214, 76, 21)];
    [self.view addSubview:self.labhb];
    self.labhb.font = [UIFont fontWithName:@"ArialMT" size:12];
    
    self.labld = [[UILabel alloc] initWithFrame:CGRectMake(218, 214, 76, 21)];
    [self.view addSubview:self.labld];
    self.labld.font = [UIFont fontWithName:@"ArialMT" size:12];
    
    UILabel * jb = [[UILabel alloc] initWithFrame:CGRectMake(0, 78, 150, 21)];
    jb.text = @"城市级别：";
    jb.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scviewcity addSubview:jb];
    self.labjb = [[UILabel alloc] initWithFrame:CGRectMake(78, 78, 85, 21)];
    [self.scviewcity addSubview:self.labjb];
    self.labjb.font = [UIFont fontWithName:@"ArialMT" size:15];
   // self.labjb.font = [UIFont fontWithName:@"ArialMT" size:12];

    self.nowtemp = [[UILabel alloc] initWithFrame:CGRectMake(154, 88, 81, 21)];
    [self.view addSubview:self.nowtemp];
   
    
    UILabel * city = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 21)];
    city.text = @"当前位置所在地：";
    city.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scviewcity addSubview:city];
    self.labcity = [[UILabel alloc] initWithFrame:CGRectMake(137, 0, 74, 21)];
    [self.scviewcity addSubview:self.labcity];
     self.labcity.font = [UIFont fontWithName:@"ArialMT" size:15];
    
    self.labcityen = [[UILabel alloc] initWithFrame:CGRectMake(208,0, 72, 21)];
    [self.scviewcity addSubview:self.labcityen];
    self.labcityen.font = [UIFont fontWithName:@"ArialMT" size:15];
    
    UILabel * shi = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 150, 21)];
    shi.text = @"当前城市所在市：";
    shi.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scviewcity addSubview:shi];
    self.labshi = [[UILabel alloc] initWithFrame:CGRectMake(137,20, 42, 21)];
    [self.scviewcity addSubview:self.labshi];
    self.labshi.font = [UIFont fontWithName:@"ArialMT" size:15];
    self.labshien = [[UILabel alloc] initWithFrame:CGRectMake(208,20, 72, 21)];
    [self.scviewcity addSubview:self.labshien];
    self.labshien.font = [UIFont fontWithName:@"ArialMT" size:15];

    UILabel * sheng = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 150, 21)];
    sheng.text = @"当前城市所在省：";
    sheng.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scviewcity addSubview:sheng];
    self.labsheng = [[UILabel alloc] initWithFrame:CGRectMake(137, 40, 42, 21)];
    [self.scviewcity addSubview:self.labsheng];
     self.labsheng.font = [UIFont fontWithName:@"ArialMT" size:15];
    self.labshengen = [[UILabel alloc] initWithFrame:CGRectMake(208,40, 72, 21)];
    self.labshengen.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scviewcity addSubview:self.labshengen];

    UILabel * guo = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 150, 21)];
    guo.text = @"当前城市所在国：";
    guo.font = [UIFont fontWithName:@"ArialMT" size:15];
    [self.scviewcity addSubview:guo];
    self.labguo = [[UILabel alloc] initWithFrame:CGRectMake(137, 60, 42, 21)];
    [self.scviewcity addSubview:self.labguo];
     self.labguo.font = [UIFont fontWithName:@"ArialMT" size:15];
    
    self.labguoen = [[UILabel alloc] initWithFrame:CGRectMake(208, 60, 72, 21)];
    [self.scviewcity addSubview:self.labguoen];
    self.labguoen.font = [UIFont fontWithName:@"ArialMT" size:15];

//    @property (nonatomic) NSString * sublocality,*state,*nowcityid,*nowcityname,*appid3,*superkey,*data,*nowlocation;
//    @property (nonatomic) IBOutlet UILabel *labdata;
//    @property (nonatomic) int flag_ok,jindu,flag_day,flag_dingwei;
//    @property (nonatomic)NSMutableArray * cityid,*allcity,*rightbarbutton;
//    @property (nonatomic)NSDictionary *readwindic,*rtweather,*fwweather,*zsweather,*readfx,*readfl,*readallcity;
//    @property (nonatomic) IBOutlet UIButton * bt;
//    @property NSTimer *timer;
//    @property int touch_num;
//    @property int isPress;
//    @property (strong,nonatomic)IBOutlet UILabel *titleLabel;
//    
//    @property (assign,nonatomic) int index;
}



@end
