//
//  HackerNewsReaderAppDelegate.m
//  HackerNewsReader
//
//  Created by Deon Botha on 08/08/2010.
//  Copyright None 2010. All rights reserved.
//

#import "HackerNewsReader2AppDelegate.h"
#import "Story.h"
#import "RegexKitLite.h"
#import "Comment.h"
#import "RootViewController.h"
#import "FetchStoriesRequest.h"
#import "StoriesViewController.h"
@implementation HackerNewsReader2AppDelegate

@synthesize window, responseData, navController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    self.navController = [[[UINavigationController alloc] initWithRootViewController: 
						   [[[RootViewController alloc] initWithStyle: UITableViewStylePlain] autorelease]] 
						   autorelease];
	NSLog(@"started up!!!");
	self.navController.delegate = (id<UINavigationControllerDelegate>) self;					  

	UIActivityIndicatorView *loadIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
	loadIndicator.center = CGPointMake(160, 240);
	loadIndicator.hidesWhenStopped = NO;
	[loadIndicator startAnimating];
	
	//[window addSubview: navController.view];
	//navController.view = loadIndicator;
	//navController.
	[window addSubview: navController.view];
	[loadIndicator release];
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [window makeKeyAndVisible];
	
	[[FetchStoriesRequest alloc] initWithURL: [NSURL URLWithString: @"http://news.ycombinator.com"] delegate: self];	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}

#pragma mark FetchStoriesRequestDelegate methods
- (void)finishedGettingStories:(NSArray*/*<Story>*/)stories nextStoryPageURL:(NSURL*)url {
	[navController pushViewController: [[StoriesViewController alloc] initWithStories:stories nextStoryPageURL:url] animated:YES];
}

- (void)failedToGetStoriesWithReason:(GetStoriesFailureReason)reason {
	
}

#pragma mark FetchCommentsRequestDelegate methods

- (void)finishedGettingComments:(NSArray*/*<Comment>*/)comment {
	
}

- (void)failedToGetCommentsWithReason:(GetCommentsFailureReason)reason {
	
}

@end
