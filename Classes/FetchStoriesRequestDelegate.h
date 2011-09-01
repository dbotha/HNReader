//
//  FetchStoriesRequestDelegate.h
//  HackerNewsReader
//
//  Created by Deon Botha on 09/10/2010.
//  Copyright 2010 None. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum GetStoriesFailureReason {
	FAIL = 1
} GetStoriesFailureReason;

@protocol FetchStoriesRequestDelegate <NSObject>

- (void)finishedGettingStories:(NSArray*/*<Story>*/)stories nextStoryPageURL:(NSURL*) url;
- (void)failedToGetStoriesWithReason: (GetStoriesFailureReason) reason;

@end
