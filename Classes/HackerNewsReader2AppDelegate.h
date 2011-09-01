//
//  HackerNewsReaderAppDelegate.h
//  HackerNewsReader
//
//  Created by Deon Botha on 08/08/2010.
//  Copyright None 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FetchStoriesRequestDelegate.h"
#import "FetchCommentsRequestDelegate.h"

@class FetchStoriesRequest;
@interface HackerNewsReader2AppDelegate : NSObject <UIApplicationDelegate, 
		FetchStoriesRequestDelegate, FetchCommentsRequestDelegate> {
    UIWindow *window;
	UINavigationController *navController;
	FetchStoriesRequest *_fetchStoriesRequest;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) UINavigationController *navController;

@end

