//
//  A1cViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/16/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "A1cViewController.h"
#import "JBLineChartView.h"
#import "JBColorConstants.h"
#import "AddA1cViewController.h"
#import "A1c.h"
#import "AppDelegate.h"

@interface A1cViewController () <JBLineChartViewDataSource, JBLineChartViewDelegate>

@property (strong, nonatomic) JBLineChartView *lineChartView;
@property (weak, nonatomic) IBOutlet UITextField *targetTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) NSArray *graphDataPoints; // of A1c.h

@property (weak, nonatomic) IBOutlet UIView *graphView;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation A1cViewController

- (IBAction)unwindToA1CView:(UIStoryboardSegue *)segue
{
    if ([[segue sourceViewController] isKindOfClass:[AddA1cViewController class]]) {
        AddA1cViewController *source = [segue sourceViewController];
        A1c *a1c = source.a1c;
        if (a1c != nil) {
            //[self.dailyReadings addObject:newReading];
            //[self.tableView reloadData];
//            [self loadWithData];
//            [self.tableView reloadData];
            [self updateData];
        }
    }
}

- (IBAction)backgroundButtonPressed:(id)sender
{
    [self.targetTextField resignFirstResponder];
}

- (NSDateFormatter*)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    return _dateFormatter;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSNumber*)targetA1c
{
    return [NSNumber numberWithFloat:[self.targetTextField.text floatValue]];
}

//- (NSNumber*)maximumFromArray:(NSArray*)array
//{
//    return [NSNumber numberWithFloat:9.0f];
//}
//
//- (NSNumber*)minimumFromArray:(NSArray *)array
//{
//    return [NSNumber numberWithFloat:4.0f];
//}

//- (float)verticalPaddingOfLineChartWithData:(NSArray*)array // 15% of range
//{
//    return ([[self minimumFromArray:array] floatValue] + [[self maximumFromArray:array] floatValue]) * .15f;
//}

- (NSArray*)fiveMostRecentA1cFloats
{
//    return @[[NSNumber numberWithFloat:4.5],
//             [NSNumber numberWithFloat:5.8],
//             [NSNumber numberWithFloat:7.6],
//             [NSNumber numberWithFloat:5.4],
//             [NSNumber numberWithFloat:8.2]];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"A1c"];
    request.fetchLimit = 5;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"date <= %@", [NSDate date]];
    NSArray *results = [self.context executeFetchRequest:request error:NULL];
    
    NSLog(@"Count: %i", results.count);
    for (int i = 0; i < 5 && i < results.count; i++) {
        A1c* curA1c = results[i];
        NSLog(@"a1c:%f for date:%@", [curA1c.a1c floatValue], curA1c.date);
    }
    
    return [NSMutableArray arrayWithArray:results];
}

- (void)updateData
{
    [self.lineChartView setState:JBChartViewStateCollapsed animated:NO];
    [self initWithFakeData];
    [self.lineChartView reloadData];
    [self.lineChartView setState:JBChartViewStateExpanded animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Line chart setup
    self.lineChartView = [[JBLineChartView alloc] init];
    self.lineChartView.frame = CGRectMake(5.0f, 5.0f, self.graphView.bounds.size.width - 10.0f, self.graphView.bounds.size.height - 10.0f);
//    self.lineChartView.frame = CGRectMake(5.0f, 5.0f, self.view.bounds.size.width - 10.0f, self.view.bounds.size.height - 10.0f);
    self.lineChartView.delegate = self;
    self.lineChartView.dataSource = self;
    
    [self initWithFakeData];
    self.targetTextField.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"A1cGoal"] stringValue];
    
    //self.lineChartView.maximumValue = [[self maximumFromArray:self.graphDataPoints] floatValue];
    //self.lineChartView.minimumValue = [[self minimumFromArray:self.graphDataPoints] floatValue];
    
    //self.lineChartView.backgroundColor = ColorLineChartControllerBackground;
    
    [self.graphView addSubview:self.lineChartView];
//    [self.view addSubview:self.lineChartView];
    
    [self.lineChartView setState:JBChartViewStateCollapsed animated:NO];
    
//    UIView *gridView = [[UIView alloc] initWithFrame:self.lineChartView.bounds];
//    gridView.backgroundColor = [UIColor blackColor];
//    [self.lineChartView insertSubview:gridView atIndex:0];
    
    [self.lineChartView reloadData];
    
    int64_t delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.lineChartView setState:JBChartViewStateExpanded animated:YES];
            });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWithFakeData
{
    _graphDataPoints = [self fiveMostRecentA1cFloats];
}

#pragma mark - LineChart Data Source methods

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 2; // number of lines in chart
    // line 1 is a1c graph, line 2 is horizontal line representing target
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return [self.graphDataPoints count]; // number of values for a line
}

#pragma  mark - LineChart Delegate methods

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    if (lineIndex == 1) {
        return [[self targetA1c] floatValue];
    }
    A1c *a1c = [self.graphDataPoints objectAtIndex:horizontalIndex];
    return [a1c.a1c floatValue];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    //if (lineIndex == 1) return; // don't need a tool tip for target a1c line
    [self.targetTextField resignFirstResponder];
    
    if (lineIndex == 0) {
        A1c *selected = [self.graphDataPoints objectAtIndex:horizontalIndex];
        self.dateLabel.text = [self.dateFormatter stringFromDate:selected.date];
        self.dateLabel.hidden = NO;
    }
    
    [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
    NSString *tooltipText = [NSString stringWithFormat:@"%.1f", [self lineChartView:lineChartView verticalValueForHorizontalIndex:horizontalIndex atLineIndex:lineIndex]];
    [self.tooltipView setText:tooltipText]; //[[self.graphDataPoints objectAtIndex:horizontalIndex] stringValue]];
    
}

- (void)didUnselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    self.dateLabel.hidden = YES;
    [self setTooltipVisible:NO animated:YES];
}

#pragma mark - LineChart customization

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return lineIndex == 1 ? kJBColorLineChartDefaultDashedLineColor : [UIColor blueColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    A1c* selectedA1c = [self.graphDataPoints objectAtIndex:horizontalIndex];
    return [selectedA1c.a1c floatValue] > [[self targetA1c] floatValue] ? kJBColorLineChartDefaultDashedLineColor : [UIColor blueColor];
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return lineIndex == 0 ? 2.0f : 1.0f;
}

- (IBAction)targetA1cChanged:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:[self.targetTextField.text floatValue]] forKey:@"A1cGoal"];
    NSLog(@"Updating data");
    
    [self updateData];
}
- (IBAction)targetA1cEditDidEnd:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:[self.targetTextField.text floatValue]] forKey:@"A1cGoal"];
    NSLog(@"Updating data");
    
    [self updateData];}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForLineAtLineIndex:(NSUInteger)lineIndex
{
    return lineIndex == 0 ? 8.0f : 1.0f;
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return lineIndex == 0 ? JBLineChartViewLineStyleDashed : JBLineChartViewLineStyleSolid; // style of line in chart
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
    return lineIndex == 0 ? YES : NO;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5]; // color of selected line
}

- (UIColor *)verticalSelectionColorForLineChartView:(JBLineChartView *)lineChartView
{
    return [UIColor grayColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    return (lineIndex == 1) ? [UIColor redColor]: [UIColor blueColor];
}

- (JBChartView*)chartView
{
    return self.lineChartView;
}

#pragma mark - Managed Object Context
- (NSManagedObjectContext *)context
{
    if (_context != nil) {
        return _context;
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _context = appDelegate.context;
    return _context;
}
//- (NSManagedObjectContext *)context
//{
//    if (!_context) {
//        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//        _context = appDelegate.context;
//    }
//    
//    return _context;
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = [segue destinationViewController];
        if ([navController.topViewController isKindOfClass:[AddA1cViewController class]]) {
            AddA1cViewController *addController = (AddA1cViewController*)navController.topViewController;
            addController.context = self.context;
        }
    }
}

@end
