//
//  FetchStoriesRequest.m
//  HackerNewsReader
//
//  Created by Deon Botha on 09/10/2010.
//  Copyright 2010 None. All rights reserved.
//

#import "FetchStoriesRequest.h"
#import "Story.h"
#import "RegexKitLite.h"

#define NUM_STORIES_PER_PAGE 30

@implementation FetchStoriesRequest
- (id)initWithURL:(NSURL *)url delegate:(id<FetchStoriesRequestDelegate>)delegate {
	if (self = [super init]) {
		_responseData = [[NSMutableData alloc] initWithLength: 0];
		NSURLRequest *req = [NSURLRequest requestWithURL: url];
		_conn = [[NSURLConnection alloc] initWithRequest: req delegate: self];
		_delegate = [delegate retain];
		NSLog(@"Fetching stories from %@", url);
	}
	
	return self;
}

- (void)cancelFetching {
	[_conn cancel];
	
	[_delegate	   release];	
	[_conn         release];
	[_responseData release];
	
	_delegate	  = nil;
	_conn         = nil;
	_responseData = nil;
}

+ (NSArray/*<Story>*/ *)getStoriesFromHTML:(NSString *) html {
	NSMutableArray *stories = [NSMutableArray arrayWithCapacity: NUM_STORIES_PER_PAGE];
	NSArray *rows = [html componentsMatchedByRegex: @"<tr.*?<\\/tr"];
	for (int i = 0; i < [rows count]; ++i) {
		NSString *row = [rows objectAtIndex: i];
		NSArray *cols = [row componentsMatchedByRegex: @"<td.*?<\\/td"];
		if ([cols count] == 3 && i + 1 < [rows count]) {
			// this row and the one below it (i + 1) potentially indicate a pair that contain
			// the details of a story submission, lets look further.
			
			//	<tr>
			//			<td align=right valign=top class="title">1.</td>
			//			<td>
			//				<center>
			//				<a id=up_1585085 href="vote?for=1585085&dir=up&whence=%6e%65%77%73"><img src="http://ycombinator.com/images/grayarrow.gif" border=0 vspace=3 hspace=2></	
			//					a><span>id=down_1585085></span>
			//				</center>
			//			</td>
			//			<td class="title">
			//				<a href="http://sheddingbikes.com/posts/1281257293.html">
			//					Common Programmer Health Problems
			//				</a>
			//				<span class="comhead"> (sheddingbikes.com) </span>
			//			</td>
			//	</tr>
			NSString *col = [cols objectAtIndex: 2];
			NSString *storyURLStr = [col stringByMatching: @"href=\"(.*?)\"" capture: 1];
			NSString *storyTitle = [col stringByMatching: @"<a.*?>(.*?)<" capture: 1];
			NSString *domain = [col stringByMatching: @"<span.*?class=\"comhead\".*?\\((.*?)\\)" capture: 1];
			
			//	<tr>
			//		<td colspan=2></td>
			//		<td class="subtext">
			//			<span id=score_1662348>113 points</span> by 
			//				<a href="user?id=iamelgringo">iamelgringo</a> 
			//				8 hours ago  | <a href="item?id=1662348">23 comments</a>
			//		</td>
			//	</tr>
			
			// Attempt to get the submitting username and the number of comments
			NSString *rowBelow = [rows objectAtIndex: i + 1];
			NSArray *aElemsContent = [rowBelow componentsMatchedByRegex: @"<a.*?>(.*?)<" capture: 1];
			if ([aElemsContent count] != 2) {
				continue;
			}
			NSString *username = [aElemsContent objectAtIndex: 0];
			NSString *numCommentsStr = [[aElemsContent objectAtIndex: 1] stringByMatching: @"\\d*"];
			NSUInteger numComments = numCommentsStr == NULL ? 0 : [numCommentsStr intValue];
			
			// Attempt to get the users profile url & the story comments url
			NSArray *hrefVals = [rowBelow componentsMatchedByRegex:  
								 @"href=\"(.*?)\"" capture: 1];
			if ([hrefVals count] != 2) {
				continue;
			}
			NSString *userProfileURLStr = [hrefVals objectAtIndex: 0];
			NSString *commentsURLStr = [hrefVals objectAtIndex: 1];
			
			// Attempt to get story points & submission time
			NSString *numPointsStr = [rowBelow stringByMatching: @"(-?\\d+)\\s+[Pp]oints?" capture: 1];
			NSInteger numPoints = [numPointsStr intValue];
			NSString *submissionTime = [rowBelow stringByMatching: @"\\d+\\s+([Ss]econd|[Mm]inute|[Hh]our|[Dd]ay)s?"];
			
			Story *story = [[Story alloc] initWithTitle: storyTitle
												 urlStr: storyURLStr 
												 domain: domain 
											  submitter: username 
								 submitterProfileURLStr: userProfileURLStr 
										 submissionTime: submissionTime 
										 commentsURLStr: commentsURLStr
											  numPoints: numPoints 
											numComments: numComments];
			[stories addObject: story];
			[story release];
		}
	}
	
	return stories;
}

+ (NSString *)getNextPageURLStringFromHTML:(NSString *) html {
	// <a href="/x?fnid=W6BfGmRgtW" rel="nofollow">More</a>
	NSArray *captureComponents = [html arrayOfCaptureComponentsMatchedByRegex: @"(x\\?fnid=.*?)\".*?>(.*?)<"];
	for (NSArray *components in captureComponents) {
		if ([(NSString *) [components objectAtIndex: 2] 
			 isMatchedByRegex: @"[Mm]ore"]) {
			return [components objectAtIndex: 1];
		}
	}
	
	return nil;
}

- (void)dealloc {
	[_delegate     release];
	[_conn         release];
	[_responseData release];
	
	[super dealloc];
}

#pragma mark NSURLConnection delegate methods
-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return YES;
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"didReceiveResponse %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"appending %dB", [data length]);
	[_responseData appendData: data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"connectionDidFinishLoading");
	NSString *responseContent = [[NSString alloc] initWithData: _responseData 
													  encoding: NSUTF8StringEncoding];
	NSArray *stories = [FetchStoriesRequest getStoriesFromHTML: responseContent];
	if ([stories count] == 0) {
		[responseContent release];
		[_delegate failedToGetStoriesWithReason: 0]; // TODO: proper reason codes
		return;
	}
	NSString *urlStr = [FetchStoriesRequest getNextPageURLStringFromHTML: responseContent];
	NSURL *nextPageURL = [NSURL URLWithString:urlStr relativeToURL: [NSURL URLWithString: @"http://news.ycombinator.com"]];
	[responseContent release];
	[_delegate finishedGettingStories: stories nextStoryPageURL: nextPageURL];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	NSLog(@"didSendBodyData: %db/%db", bytesWritten, totalBytesWritten);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return cachedResponse;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
	NSLog(@"willSendRequest");
	return request;
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
	return NO;
}


@end
