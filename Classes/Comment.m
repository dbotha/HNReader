//
//  Comment.m
//  HackerNewsReader
//
//  Created by Deon Botha on 05/09/2010.
//  Copyright 2010 None. All rights reserved.
//

#import "Comment.h"


@implementation Comment

@synthesize submitterUsername=_submitterUsername, submissionTime=_submissionTime,
submitterProfileURLStr=_submitterProfileURLStr, comment=_comment, replies=_replies,
numPoints=_numPoints, depth=_depth;

-(id) initWithSubmitter: (NSString *) username 
		 submissionTime: (NSString *) submissionTime
 submitterProfileURLStr: (NSString *) profileURLStr
				comment: (NSString *) comment 
			  numPoints: (NSInteger) numPoints 
				  depth: (NSUInteger) depth {
	if (self = [super init]) {
		_submitterUsername		= [username retain];
		_submissionTime			= [submissionTime retain];
		_submitterProfileURLStr = [profileURLStr retain];
		_comment				= [comment retain];
		_replies				= [[NSMutableArray alloc] init];
		_numPoints				= numPoints;
		_depth					= depth;
	}
	
	return self;
}

-(void) addReply: (Comment *) comment {
	[_replies addObject: comment];
}

-(void) dealloc {
	[_submitterUsername release];
	[_submissionTime release];
	[_submitterProfileURLStr release];
	[_comment release];
	[_replies release];
	[super dealloc];
}

@end
