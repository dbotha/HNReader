//
//  FetchCommentsRequestDelegate.h
//  HackerNewsReader
//
//  Created by Deon Botha on 09/10/2010.
//  Copyright 2010 None. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum GetCommentsFailureReason {
	FAIL2 = 2
} GetCommentsFailureReason;

@protocol FetchCommentsRequestDelegate

- (void)finishedGettingComments:(NSArray*/*<Comment>*/)comment;
- (void)failedToGetCommentsWithReason: (GetCommentsFailureReason) reason;

@end
