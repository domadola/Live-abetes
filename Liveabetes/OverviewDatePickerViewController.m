//
//  OverviewDatePickerViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/28/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "OverviewDatePickerViewController.h"
#import "OverviewTableViewController.h"

@interface OverviewDatePickerViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation OverviewDatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (sender == self.doneButton) {
        if ([[segue destinationViewController] isKindOfClass:[OverviewTableViewController class]]) {
            OverviewTableViewController *overview = (OverviewTableViewController*)[segue destinationViewController];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:self.datePicker.date];
            
            dateComponents.second = 59;
            dateComponents.minute = 59;
            dateComponents.hour = 23;
            NSDate *startOfDay = [calendar dateFromComponents:dateComponents];
            overview.date = startOfDay;
            overview.dateNeedsUpdate = YES;
            NSLog(@"outgoing date was set to %@", startOfDay);
        } else {
            NSLog(@"destination is something else: %@", [segue destinationViewController]);
        }
        
    }
    
}


@end
