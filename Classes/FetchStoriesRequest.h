
//
//  FetchStoriesRequest.h
//  HackerNewsReader
//
//  Created by Deon Botha on 09/10/2010.
//  Copyright 2010 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchStoriesRequestDelegate.h"

@interface FetchStoriesRequest : NSObject {
	NSURLConnection *_conn;
	NSMutableData *_responseData;
	id<FetchStoriesRequestDelegate> _delegate;
}

- (id)initWithURL:(NSURL *)url delegate: (id<FetchStoriesRequestDelegate>) delegate;
- (void)cancelFetching;

@end
