//
//  LightningTalksDetailTableViewController.m
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/08.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "LightningTalkDetailedTableViewController.h"
#import "Room.h"
#import "Speaker.h"
#import "SpeakerDetaildTableViewController.h"
#import "SpeakerDetaildTableViewController.h"


#define TIME_SECTON             0
#define TITLE_SECTION           1
#define SPEAKERS_SECTION        2
#define ROOM_SECTION            3
#define ABSTRACT_SECTION        4



@implementation LightningTalkDetailedTableViewController

+ (LightningTalkDetailedTableViewController *)lightningTalkDetailedTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
}


- (Session *)session
{
    return self.lightningTalk.session;
}

- (LightningTalk *)lightningTalk
{
    return (LightningTalk *)self.detailedObject;
}

- (NSInteger)sectionTypeForSection:(NSInteger)section
{
    NSString *title = [self tableView:nil titleForHeaderInSection:section];
    if ([title isEqualToString:NSLocalizedString(@"Session:title", nil)]) {
        return TITLE_SECTION;
    } else
    if ([title isEqualToString:NSLocalizedString(@"Session:dayTimeTitle", nil)]) {
        return TIME_SECTON;
    } else
    if ([title isEqualToString:NSLocalizedString(@"Session:speakers", nil)]) {
        return SPEAKERS_SECTION;
    } else
    if ([title isEqualToString:NSLocalizedString(@"Session:room", nil)]) {
        return ROOM_SECTION;
    } else
    if ([title isEqualToString:NSLocalizedString(@"Session:summary", nil)]) {
        return ABSTRACT_SECTION;
    }
    return 0;
}


- (UITableViewCell *)cellForTableView:(UITableView *)tableView inSection:(NSInteger)section
{
    section = [self sectionTypeForSection:section];
    UITableViewCell *cell = nil;
    if (section == TITLE_SECTION) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"] autorelease];
            cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:20.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 10;
        }
    } else
    if (section == SPEAKERS_SECTION || section == ROOM_SECTION || section == TIME_SECTON) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HasDetailCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HasDetailCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else
    if (section == ABSTRACT_SECTION) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DescriptionCell"] autorelease];
            cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:16.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 100;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [self sectionTypeForSection:indexPath.section];
    switch (section) {
    case TITLE_SECTION:
        return [self cellHeightForTableView:tableView text:[self.detailedObject valueForKey:@"title"] indexPath:indexPath];
    case ABSTRACT_SECTION:
        return [self cellHeightForTableView:tableView text:[self.detailedObject valueForKey:@"summary"] indexPath:indexPath];
    default:
        return 44.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [self sectionTypeForSection:indexPath.section];
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (section == SPEAKERS_SECTION) {
        NSArray *speakers = self.lightningTalk.sortedSpeakers;
        if ([speakers count]) {
            Speaker *speaker = [speakers objectAtIndex:indexPath.row];
            cell.textLabel.text = speaker.name;
            BOOL hasDisclosure = [speaker.profile length] || [speaker.belongings count];
            cell.accessoryType = hasDisclosure ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            cell.selectionStyle = hasDisclosure ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
        } else {
            // セルの高さを計算する為にダミーのセルを返すのでnilの場合がある
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [self sectionTypeForSection:indexPath.section];
    if (section == SPEAKERS_SECTION) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType != UITableViewCellAccessoryNone) {
            SpeakerDetaildTableViewController *controller = [SpeakerDetaildTableViewController speakerDetailedTableViewController];
            Speaker *speaker = [self.lightningTalk.sortedSpeakers objectAtIndex:indexPath.row];
            controller.detailedObject = speaker;
            controller.tableView.backgroundColor = self.tableView.backgroundColor;
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)didChangeRegion
{
    self.detailedObject = [self.lightningTalk lightningTalkForRegion:self.region];
    [self reloadData];
}


@end
