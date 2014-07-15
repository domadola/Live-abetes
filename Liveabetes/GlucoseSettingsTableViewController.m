//
//  GlucoseSettingsTableViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/14/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "GlucoseSettingsTableViewController.h"
#import "GlucoseReadingsViewController.h"

@interface GlucoseSettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *highTextField;
@property (weak, nonatomic) IBOutlet UITextField *lowTextField;

@end

@implementation GlucoseSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSNumber *high = [[NSUserDefaults standardUserDefaults] objectForKey:@"TargetRangeHigh"];
    self.highTextField.text = [high stringValue];
    
    NSNumber *low = [[NSUserDefaults standardUserDefaults] objectForKey:@"TargetRangeLow"];
    self.lowTextField.text = [low stringValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1; // statics
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2; // static
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Save settings to UserDefaults
    
    if (sender == self.saveButton) {
        int newHigh = self.highTextField.text.intValue;
        int newLow = self.lowTextField.text.intValue;
        
        if (newHigh > newLow) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:newHigh] forKey:@"TargetRangeHigh"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:newLow] forKey:@"TargetRangeLow"];
            
            if ([[segue destinationViewController] isKindOfClass:[GlucoseReadingsViewController class]]) {
                GlucoseReadingsViewController *destination = (GlucoseReadingsViewController*)[segue destinationViewController];
                destination.needToUpdateTable = YES;
            }
        }
    }
    
    
}


@end
