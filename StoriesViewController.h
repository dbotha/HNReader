//
//  StoriesViewController.h
//  HackerNewsReader
//
//  Created by Deon Botha on 09/10/2010.
//  Copyright 2010 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchStoriesRequestDelegate.h"

@class EGORefreshTableHeaderView;
@class FetchStoriesRequest;
@class LoadNextPageTableFooterView;

@interface StoriesViewController : UITableViewController
		<UITableViewDataSource, UITableViewDelegate, FetchStoriesRequestDelegate>{
	NSMutableArray/*<Story>*/ *_stories;
	NSURL *_nextStoryPageURL;
			
	FetchStoriesRequest *_loadStoriesRequest;
	EGORefreshTableHeaderView *_refreshHeaderView;
	LoadNextPageTableFooterView *_loadNextPageFooterView;
	BOOL _refreshing, _loadingNextPage;
}

@property(assign,getter=isReloading) BOOL reloading;

- (id)initWithStories:(NSArray *)stories nextStoryPageURL:(NSURL*)url;

@end
