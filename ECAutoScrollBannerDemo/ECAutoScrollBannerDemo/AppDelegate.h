//
//  AppDelegate.h
//  ECAutoScrollBannerDemo
//
//  Created by EchoZuo on 2017/11/27.
//  Copyright © 2017年 Echo.Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

