//
//  AppShare.h
//  163news
//
//  Created by dwwang on 10/28/13.
//  Copyright (c) 2013 pps. All rights reserved.
//

#ifndef _63news_AppShare_h
#define _63news_AppShare_h

//IOS 常用的宏积累 具体的使用，可一针对不同的Project来自己获取、或者改名字，方便不增加负担

//常用的IOS开发宏

#pragma mark - 界面 部分

#define NavigationBar_HEIGHT 44 //导航控制器

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) //屏幕宽度

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) //屏幕高度

#define SAFE_RELEASE(x) [x release];x=nil //安全释放

#define RBGCOLOR(r,g,b) [UIColor colorWithRed:0.400 green:0.523 blue:0.949 alpha:1.000] //设置颜色

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#pragma mark - 系统 部分

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue] //当前设备的系统版本
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion]) //当前的系统版本
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0]) //当前的设备的默认语言

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO) //是否是高清屏

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) //是否是IPhone5

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) //是否是IPAD



#pragma mark - 功能部分
//use dlog to print while in debug model
#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...)
#endif


//针对真机iPhone
#if TARGET_OS_IPHONE
//iPhone Device
#endif

//针对模拟器
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


#define USER_DEFAULT [NSUserDefaults standardUserDefaults] //UserDefault


#define degreesToRadian(x) (M_PI * (x) / 180.0) //弧度转角度

#define radianToDegrees(radian) (radian*180.0)/(M_PI) //角度转弧度



//读取本地图片的 和imageNamed一样，但是性能比后者要强很多，两个参数，前面一个是 文件名，后面一个是类型

#define LoadImage(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]] //可以用来直接传图片名字

#define LoadImageWithType(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//例如 imageView.image = LOADIMAGE(@"文件名",@"png");


// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//IOS 常用的宏积累 具体的使用，可一针对不同的Project来自己获取、或者改名字，方便不增加负担

//常用的IOS开发宏

#pragma mark - 界面 部分

#define NavigationBar_HEIGHT 44 //导航控制器

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width) //屏幕宽度

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) //屏幕高度

#define SAFE_RELEASE(x) [x release];x=nil //安全释放

#define RBGCOLOR(r,g,b) [UIColor colorWithRed:0.400 green:0.523 blue:0.949 alpha:1.000] //设置颜色

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


#pragma mark - 系统 部分

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue] //当前设备的系统版本
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion]) //当前的系统版本
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0]) //当前的设备的默认语言

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO) //是否是高清屏

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) //是否是IPhone5

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) //是否是IPAD



#pragma mark - 功能部分
//use dlog to print while in debug model
#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...)
#endif


//针对真机iPhone
#if TARGET_OS_IPHONE
//iPhone Device
#endif

//针对模拟器
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


#define USER_DEFAULT [NSUserDefaults standardUserDefaults] //UserDefault


#define degreesToRadian(x) (M_PI * (x) / 180.0) //弧度转角度

#define radianToDegrees(radian) (radian*180.0)/(M_PI) //角度转弧度



//读取本地图片的 和imageNamed一样，但是性能比后者要强很多，两个参数，前面一个是 文件名，后面一个是类型

#define LoadImage(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]] //可以用来直接传图片名字

#define LoadImageWithType(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//例如 imageView.image = LOADIMAGE(@"文件名",@"png");


// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]





#endif
