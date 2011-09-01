//
//  StoryCell.h
//  HackerNewsReader
//
//  Created by Deon Botha on 05/09/2010.
//  Copyright 2010 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

@interface StoryCell : UITableViewCell {
	Story *_story;
	
	UILabel *_storyTitleLabel;
	UILabel *_domainLabel;
	UILabel *_additionalDetailsLabel; // story points, posted by, submission time etc
	
}

@property (nonatomic, retain) Story *story;

@end
