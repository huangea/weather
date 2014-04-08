//
//  ViewController.m
//  SideBarNavDemo
//
//  Created by JianYe on 12-12-11.
//  Copyright (c) 2012年 JianYe. All rights reserved.
//

#import "SidebarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LeftSideBarViewController.h"
#import "RightSideBarViewController.h"

@interface SidebarViewController ()
{
    UIViewController  *_currentMainController;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureReconginzer;
    BOOL sideBarShowing;
    CGFloat currentTranslate;
}
@property (strong,nonatomic)LeftSideBarViewController *leftSideBarViewController;
@property (strong,nonatomic)RightSideBarViewController *rightSideBarViewController;
@end

@implementation SidebarViewController
@synthesize leftSideBarViewController,rightSideBarViewController,contentView,navBackView;

static SidebarViewController *rootViewCon;
const int ContentOffset=100;
const int ContentMinOffset=60;
const float MoveAnimationDuration = .3;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

+ (id)share
{
    return rootViewCon;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    
//    UIScrollView * scollweather;
//    scollweather = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 270, 280, 288)];
//    scollweather.backgroundColor = [UIColor greenColor];
//    //self.scollweather.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:scollweather];
    
    if (rootViewCon) {
        rootViewCon = nil;
    }
	rootViewCon = self;
    
    sideBarShowing = NO;
    currentTranslate = 0;
    
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOpacity = 1;
    
    LeftSideBarViewController *_leftCon = [[LeftSideBarViewController alloc] initWithNibName:@"LeftSideBarViewController" bundle:nil];
    _leftCon.delegate = self;
    self.leftSideBarViewController = _leftCon;
    
    RightSideBarViewController *_rightCon = [[RightSideBarViewController alloc] initWithNibName:@"RightSideBarViewController" bundle:nil];
    self.rightSideBarViewController = _rightCon;
    
    [self addChildViewController:self.leftSideBarViewController];
    [self addChildViewController:self.rightSideBarViewController];
    self.leftSideBarViewController.view.frame = self.navBackView.bounds;
    self.rightSideBarViewController.view.frame = self.navBackView.bounds;
    [self.navBackView addSubview:self.leftSideBarViewController.view];
    [self.navBackView addSubview:self.rightSideBarViewController.view];
    
    _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
    [self.contentView addGestureRecognizer:_panGestureReconginzer];
}

- (void)contentViewAddTapGestures
{
    if (_tapGestureRecognizer) {
        [self.contentView   removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = nil;
    }
    
    _tapGestureRecognizer = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapOnContentView:)];
    [self.contentView addGestureRecognizer:_tapGestureRecognizer];
}

- (void)tapOnContentView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
}

- (void)panInContentView:(UIPanGestureRecognizer *)panGestureReconginzer
{
	if (panGestureReconginzer.state == UIGestureRecognizerStateChanged)
    {
       NSLog(@"as");
        CGFloat translation = [panGestureReconginzer translationInView:self.contentView].x;
        self.contentView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
        UIView *view ;
        if (translation+currentTranslate>0)
        {
            view = self.leftSideBarViewController.view;
        }else
        {
            view = self.rightSideBarViewController.view;
        }
        [self.navBackView bringSubviewToFront:view];
        
	} else if (panGestureReconginzer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"bs");
		currentTranslate = self.contentView.transform.tx;
        if (!sideBarShowing) {
            if (fabs(currentTranslate)<ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            }else if(currentTranslate>ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            }else
            {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }else
        {
            if (fabs(currentTranslate)<ContentOffset-ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            
            }else if(currentTranslate>ContentOffset-ContentMinOffset)
            {
                
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
                            
            }else
            {
                [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
            }
        }
        
        
	}
    
   
}

#pragma mark - nav con delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"qazqaz");
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController.viewControllers count]>1) {
        [self removepanGestureReconginzerWhileNavConPushed:YES];
    }else
    {
        [self removepanGestureReconginzerWhileNavConPushed:NO];
    }

}

- (void)removepanGestureReconginzerWhileNavConPushed:(BOOL)push
{
    NSLog(@"push:%d",push);
    if (push) {
        if (_panGestureReconginzer) {
            [self.contentView removeGestureRecognizer:_panGestureReconginzer];
            _panGestureReconginzer = nil;
        }
    }else
    {
        if (!_panGestureReconginzer) {
            _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
            [self.contentView addGestureRecognizer:_panGestureReconginzer];
        }
    }
}
#pragma mark - side bar select delegate
- (void)leftSideBarSelectWithController:(UIViewController *)controller
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)controller setDelegate:self];
    }
    if (_currentMainController == nil) {
		controller.view.frame = self.contentView.bounds;
		_currentMainController = controller;
		[self addChildViewController:_currentMainController];
		[self.contentView addSubview:_currentMainController.view];
		[_currentMainController didMoveToParentViewController:self];
	} else if (_currentMainController != controller && controller !=nil) {
		controller.view.frame = self.contentView.bounds;
		[_currentMainController willMoveToParentViewController:nil];
		[self addChildViewController:controller];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_currentMainController
						  toViewController:controller
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_currentMainController removeFromParentViewController];
									[controller didMoveToParentViewController:self];
									_currentMainController = controller;
								}
         ];
	}
    
    [self showSideBarControllerWithDirection:SideBarShowDirectionNone];
}


- (void)rightSideBarSelectWithController:(UIViewController *)controller
{
    
}

- (void)showSideBarControllerWithDirection:(SideBarShowDirection)direction
{
    
    if (direction!=SideBarShowDirectionNone) {
        UIView *view ;
        if (direction == SideBarShowDirectionLeft)
        {
            view = self.leftSideBarViewController.view;
        }else
        {
            view = self.rightSideBarViewController.view;
        }
        [self.navBackView bringSubviewToFront:view];
    }
    [self moveAnimationWithDirection:direction duration:MoveAnimationDuration];
}



#pragma animation

- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    NSLog(@"mov;");
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(0, 0);
            }
                break;
            case SideBarShowDirectionLeft:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(ContentOffset, 0);
            }
                break;
            case SideBarShowDirectionRight:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(-ContentOffset, 0);
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        self.contentView.userInteractionEnabled = YES;
        self.navBackView.userInteractionEnabled = YES;
        
        if (direction == SideBarShowDirectionNone) {
           
            if (_tapGestureRecognizer) {
                [self.contentView removeGestureRecognizer:_tapGestureRecognizer];
                _tapGestureRecognizer = nil;
            }
            sideBarShowing = NO;
            
            
        }else
        {
            [self contentViewAddTapGestures];
             sideBarShowing = YES;
        }
        currentTranslate = self.contentView.transform.tx;
	};
    self.contentView.userInteractionEnabled = NO;
    self.navBackView.userInteractionEnabled = NO;
    [UIView animateWithDuration:duration animations:animations completion:complete];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch  moveing ...");
   /* switch (self.isPress)
    {
        case 2:
        {
            UITouch *touch=[touches anyObject];
            CGPoint oldPoint=[touch previousLocationInView:touch.view];
            CGPoint newPoint=[touch locationInView:touch.view];
            NSLog(@"bar:%d",self.touch_num += newPoint.x-oldPoint.x);
            CGPoint offSet=CGPointMake(newPoint.x-oldPoint.x, newPoint.y-oldPoint.y);
            if(self.view.center.x + offSet.x >= 87 && self.view.center.x + offSet.x < 160)
            {
                self.view.center=CGPointMake(self.view.center.x+offSet.x, self.view.center.y);
                NSLog(@"tuch begon2");
                NSLog(@"%f",self.view.center.x);
            }
            else if(self.view.center.x + offSet.x < 160)
            {
                self.view.center=CGPointMake(87, self.view.center.y);
                NSLog(@"tuch begon2");
            }
        }
            break;
        case 1:
        {
            UITouch *touch=[touches anyObject];
            CGPoint oldPoint=[touch previousLocationInView:touch.view];
            CGPoint newPoint=[touch locationInView:touch.view];
            NSLog(@"%d",self.touch_num += newPoint.x-oldPoint.x);
            CGPoint offSet=CGPointMake(newPoint.x-oldPoint.x, newPoint.y-oldPoint.y);
            self.viewweather.center=CGPointMake(self.viewweather.center.x+offSet.x, self.viewweather.center.y);
            NSLog(@"tuch begon1");
        }
            break;
            
    }
    */
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  //  UITouch *touch=[touches anyObject];
   // CGPoint start=[touch locationInView:self.view];
    NSLog(@"tuch begon");
   /* self.touch_num = 0;
    if (CGRectContainsPoint(self.viewweather.frame, start))
    {
        _isPress = 1;
        NSLog(@"ispresss is 1");
    }
    else if(CGRectContainsPoint(self.view.frame, start))
    {
        _isPress = 2;
    }
    */
}
 

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   /* switch (self.isPress)
    {
        case 2:
        {
            [self rightbarmove : 1];
        }
            break;
        case 1:
        {
            if(self.touch_num <= -100)
                [self weathermove : 1];
            if(self.touch_num >= 100)
                [self weathermove : 2];
            
            if(self.touch_num > -100 && self.touch_num < 100)
            {
                [UIView beginAnimations:Nil context:nil];
                [UIView setAnimationDuration:0.3];
                [UIView setAnimationDelegate:self];
                self.viewweather.center=CGPointMake(160, self.viewweather.center.y);
                [UIView commitAnimations];
            }
        }
            break;
    }*/
    NSLog(@"endtouch");
}


@end
