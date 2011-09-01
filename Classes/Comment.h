//
//  Comment.h
//  HackerNewsReader
//
//  Created by Deon Botha on 05/09/2010.
//  Copyright 2010 None. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Comment : NSObject {
	NSString *_submitterUsername;
	NSString *_submissionTime;
	NSString *_submitterProfileURLStr;
	NSString *_comment;
	NSMutableArray/*<Comment>*/ *_replies;
	NSInteger _numPoints;
	NSUInteger _depth;
}

@property (nonatomic, readonly) NSString *submitterUsername, *submissionTime, *submitterProfileURLStr, *comment;
@property (nonatomic, readonly) NSArray *replies;
@property (nonatomic, readonly) NSInteger numPoints;
@property (nonatomic, readonly) NSUInteger depth;

-(id) initWithSubmitter: (NSString *) username 
		 submissionTime: (NSString *) submissionTime
 submitterProfileURLStr: (NSString *) profileURLStr
				comment: (NSString *) comment 
			  numPoints: (NSInteger) numPoints
				  depth: (NSUInteger) depth;

-(void) addReply: (Comment *) comment;

@end
