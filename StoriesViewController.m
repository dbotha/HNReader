//
//  StoriesViewController.m
//  HackerNewsReader
//
//  Created by Deon Botha on 09/10/2010.
//  Copyright 2010 None. All rights reserved.
//

#import "StoriesViewController.h"
#import "StoryCell.h"
#import "EGORefreshTableHeaderView.h"
#import "FetchStoriesRequest.h"
#import "LoadNextPageTableFooterView.h"

@interface StoriesViewController (Private)
- (void)dataSourceDidFinishLoadingNewData;
- (CGFloat)totalStoriesHeight;
@end


@implementation StoriesViewController
@synthesize reloading=_refreshing;


- (id)initWithStories:(NSArray *)stories nextStoryPageURL:(NSURL*) url {
	if (self = [super initWithStyle: UITableViewStylePlain]) {
		_stories = [[NSMutableArray alloc] initWithCapacity: [stories count] * 4];
		[_stories addObjectsFromArray:stories];
		_nextStoryPageURL = [url retain];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (_refreshHeaderView == nil) {
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320.0f, self.tableView.bounds.size.height)];
		_refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		[self.tableView addSubview:_refreshHeaderView];
		[_refreshHeaderView release];
		
		_loadNextPageFooterView = [[LoadNextPageTableFooterView alloc] initWithFrame: CGRectZero];
		_loadNextPageFooterView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		[self.tableView addSubview:_loadNextPageFooterView];
		[_loadNextPageFooterView release];
		
		self.tableView.showsVerticalScrollIndicator = YES;
	}
}

- (void)viewDidUnload {
	_refreshHeaderView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	_loadNextPageFooterView.frame = CGRectMake(0.0f, self.tableView.contentSize.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
	[_loadNextPageFooterView setNeedsDisplay];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	_loadNextPageFooterView.frame = CGRectMake(0.0f, self.tableView.contentSize.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
	[_loadNextPageFooterView setNeedsDisplay];
}
	 


- (void)dealloc {
	[_loadStoriesRequest cancelFetching];
	[_loadStoriesRequest release];
	[_refreshHeaderView release];
	[_nextStoryPageURL release];
	[_stories release];
	[super dealloc];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_stories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"StoryCell";
	StoryCell *cell = (StoryCell *) [super.tableView dequeueReusableCellWithIdentifier: cellIdentifier];
	if (cell == nil) {
		cell = [[[StoryCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentifier] autorelease];
	} 
	
	cell.story = [_stories objectAtIndex: indexPath.row];
	return cell;
}

#pragma mark UITableViewDelegate methods

- (CGFloat)cellHeightForStory:(Story *)story {
	CGFloat labelWidth = self.tableView.bounds.size.width - 20;
	CGSize maxSize = CGSizeMake(labelWidth, MAXFLOAT);
	CGSize titleSize = [story.title sizeWithFont:[UIFont boldSystemFontOfSize:14] 
							   constrainedToSize: maxSize
								   lineBreakMode: UILineBreakModeTailTruncation];
	
	CGSize domainSize;
	if ([[story.domain stringByTrimmingCharactersInSet: 
		  [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0) {
		domainSize = [story.domain sizeWithFont:[UIFont boldSystemFontOfSize:12] 
							  constrainedToSize: maxSize
								  lineBreakMode: UILineBreakModeTailTruncation];
	}
	
	NSString *details = [NSString stringWithFormat: @"%d points | posted by %@", story.numPoints, story.submitterUsername];
	CGSize detailsSize = [details sizeWithFont:[UIFont systemFontOfSize:12] 
							 constrainedToSize: maxSize
								 lineBreakMode: UILineBreakModeTailTruncation];
	
	return 10.0f + titleSize.height + domainSize.height + detailsSize.height;	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self cellHeightForStory: [_stories objectAtIndex: indexPath.row]];
}

- (CGFloat)totalStoriesHeight {
	CGFloat totalHeight = 0;
	for (Story *story in _stories) {
		totalHeight += [self cellHeightForStory:story];
	}
	return totalHeight;
}

#pragma mark EGORefreshTableHeaderView methods (pull down to refresh)
- (void)refreshTableViewDataSource {
	// TODO: if currently loading next page ensure that the pull up to load
	// widget is reset
	_loadingNextPage = NO;
	[_loadStoriesRequest cancelFetching];
	_loadStoriesRequest = [[FetchStoriesRequest alloc] 
					   initWithURL:[NSURL URLWithString: @"http://news.ycombinator.com"] 
						  delegate:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {	
	if (scrollView.isDragging) {
		if (_refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_refreshing) {
			[_refreshHeaderView setState:EGOOPullRefreshNormal];
		} else if (_refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_refreshing) {
			[_refreshHeaderView setState:EGOOPullRefreshPulling];
		}
		
		CGFloat height = self.tableView.contentSize.height - self.tableView.frame.size.height;
		if (_loadNextPageFooterView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > height && scrollView.contentOffset.y < (height + 65.0f) && !_loadingNextPage) {
			[_loadNextPageFooterView setState:EGOOPullRefreshNormal];
		} else if (_loadNextPageFooterView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y > (height + 65.0f) && !_loadingNextPage) {
			[_loadNextPageFooterView setState:EGOOPullRefreshPulling];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (scrollView.contentOffset.y <= - 65.0f && !_refreshing) {
		_refreshing = YES;
		[self refreshTableViewDataSource];
		[_refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	} else if (scrollView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.frame.size.height) + 65.0f && !_loadingNextPage) {
		_loadingNextPage = YES;
		_refreshing = NO;
		[_loadStoriesRequest cancelFetching];
		_loadStoriesRequest = [[FetchStoriesRequest alloc] initWithURL: _nextStoryPageURL delegate: self];
		
		[_loadNextPageFooterView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)fadeAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[_loadNextPageFooterView setState:EGOOPullRefreshNormal];
	_loadNextPageFooterView.frame = CGRectMake(0.0f, self.tableView.contentSize.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
	_loadNextPageFooterView.alpha = 1.0f;
	[_loadNextPageFooterView setNeedsDisplay];	
}

#pragma mark FetchStoriesRequestDelegate methods
- (void)finishedGettingStories:(NSArray*/*<Story>*/)stories nextStoryPageURL:(NSURL*)url {
	[_loadStoriesRequest release];
	_loadStoriesRequest = nil;	
	if (_refreshing) {		
		NSLog(@"refreshed stories!");
		[_stories release];
		_stories = [stories retain];
		[_nextStoryPageURL release];
		_nextStoryPageURL = [url retain];
		
		_refreshing = NO;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.3];
		[UIView commitAnimations];		
		[_refreshHeaderView setState:EGOOPullRefreshNormal];
		[_refreshHeaderView setCurrentDate];  //  should check if data reload was successful 
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		[self.tableView reloadData];
		
		// replace footer at bottom of scroll view incase it was way further
		// down at the end of some other page.
		_loadNextPageFooterView.frame = CGRectMake(0.0f, self.tableView.contentSize.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
		_loadNextPageFooterView.alpha = 1.0f;
		[_loadNextPageFooterView setNeedsDisplay];
	} else {
		NSLog(@"got next stories!");
		NSAssert(_loadingNextPage, @"Got a finished getting stories callback when not refreshing or loading next page");
		_loadingNextPage = NO;
		[_stories addObjectsFromArray:stories];
		[_nextStoryPageURL release];
		_nextStoryPageURL = [url retain];
		NSLog(@"pre reload contentHeight: %f", self.tableView.contentSize.height);
		[self.tableView reloadData];
		NSLog(@"post reload contentHeight: %f", self.tableView.contentSize.height);
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(fadeAnimationDidStop:finished:context:)];
		[UIView setAnimationDuration:0.7f];
		[_loadNextPageFooterView setAlpha:0.0f];
		[UIView commitAnimations];
	}
}

- (void)failedToGetStoriesWithReason:(GetStoriesFailureReason)reason {
	[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[_loadStoriesRequest release];
	_loadStoriesRequest = nil;
	NSLog(@"failed to get stories");
	if (_refreshing) {
		
	} else {
		NSAssert(_loadingNextPage, @"Got a finished getting stories callback when not refreshing or loading next page");
	}
}

@end
