// 
//  Session.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/26.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "Session.h"
#import "Day.h"
#import "LightningTalk.h"

@implementation Session 

@dynamic time;
@dynamic title;
@dynamic intermission;
@dynamic profile;
@dynamic attention;
@dynamic summary;
@dynamic position;
@dynamic code;
@dynamic speakers;
@dynamic day;
@dynamic room;
@dynamic lightningTalks;
@dynamic speakerRawData;
@dynamic sessionType;

- (void)awakeFromInsert
{
    self.sessionType = [NSNumber numberWithInt:SessionTypeCodeNormal];
}

+ (NSString *)listScopeName
{
    return @"day";
}

- (NSArray *)displayAttributesForTableViewController:(UITableViewController *)controller editing:(BOOL)editing
{
    return [NSArray arrayWithObjects:@"title", @"speakers.name", @"room.roomDescription", @"summary", @"profile", nil];
}

- (NSString *)dayTimeTitle
{
    return [NSString stringWithFormat:@"%@ %@", self.day.title, self.time];
}

- (BOOL)isSession
{
    return ([self.sessionType intValue] / 100) == 0;
}

- (BOOL)isBreak
{
    return ([self.sessionType intValue] / 100) == 1;
}

- (BOOL)isAnnouncement
{
    return ([self.sessionType intValue] / 100) == 2;
}


@end