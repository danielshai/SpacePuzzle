//
//  GViewViewController.m
//  SpacePuzzle

#import "SpacePuzzleController.h"
#import "Element.h"
#import "Converter.h"
#import "Box.h"
#import "Star.h"
#import "Player.h"
#import "Button.h"

@implementation SpacePuzzleController
@synthesize board = _board;
@synthesize scene = _scene;
@synthesize currentUnit = _currentUnit;
@synthesize bigL = _bigL;
@synthesize littleJohn = _littleJohn;
@synthesize player = _player;

-(void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    _scene = [MainScene sceneWithSize:skView.bounds.size];
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    
    _player = [[Player alloc] init];
    
    [self setupBoard];
    [self setupElements];
    [self setupUnits];
    
    // Present the scene.
    [skView presentScene:_scene];
    
    // Add observers to the view.
    [self observeText:UNIT_MOVED Selector:@selector(unitMoved:)];
    
    // Input recognizers.
    UITapGestureRecognizer *singleTapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapR.numberOfTapsRequired = 1;
    [_scene.view addGestureRecognizer:singleTapR];
    
    UITapGestureRecognizer *doubleTapR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(doubleTap:)];
    doubleTapR.numberOfTapsRequired = 2;
    [_scene.view addGestureRecognizer:doubleTapR];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [_scene.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [_scene.view addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [_scene.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_scene.view addGestureRecognizer:swipeRight];
}

/*
 *  Called when the user taps once. */
-(void)singleTap:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:_scene.view];
        
        // Convert to board coordinates. Invert with -9.
        location = [Converter convertMousePosToCoord:location];
        location.y = abs(location.y - 9);
        
        [self unitWantsToMoveTo:location];
    }
}

/* 
 *  Called when the user double taps the view. */
-(void)doubleTap:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:_scene.view];
        
        // Convert to board coordinates. Invert with -9.
        location = [Converter convertMousePosToCoord:location];
        location.y = abs(location.y - 9);
        
        [self unitWantsToDoActionAt:location];
    }
}

-(void)swipeUp:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.y -= 1;
        [self unitWantsToMoveTo:location];
    }
}

-(void)swipeDown:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.y += 1;
        [self unitWantsToMoveTo:location];
    }
}

-(void)swipeLeft:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.x -= 1;
        [self unitWantsToMoveTo:location];
    }
}

-(void)swipeRight:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = CGPointMake(_currentUnit.x, _currentUnit.y);
        location.x += 1;
        [self unitWantsToMoveTo:location];
    }
}

/*
 *  Loads the board according to the level. ADD LEVELFACTORY!!!. */
-(void)setupBoard {
    // TEMP CODE.
    _board = [[Board alloc] init];
    // Load the board.

    NSString *path = [[NSBundle mainBundle] pathForResource:@"mario" ofType:@"splvl"];
    
    [_board loadBoard:path];
    
    for(int i = 0; i < BOARD_SIZE_Y; i++) {
        for(int j = 0; j < BOARD_SIZE_X; j++) {
            BoardCoord *bc = [_board.board objectAtIndex:BOARD_SIZE_X*i + j];
            [_scene setupBoardX:[bc x] Y:[bc y] Status:[bc status]];
        }
    }
}

-(void)setupElements {
    // Talk to the scene what to show.
    NSEnumerator *enumerator = [[_board elementDictionary] objectEnumerator];
    Element *obj;
    while((obj = [enumerator nextObject])) {
        CGPoint p = CGPointMake([obj x], [obj y]);
        NSString *str = NSStringFromClass([obj class]);
        
        [_scene setupElement:p Name:str];
    }
}

/*
 *  Called when a unit wants to move to a location on the board. This method checks if the move is possible,
 *  if so moves the unit. If unit moves to star, consume the star. */
-(void)unitWantsToMoveTo:(CGPoint)loc {
    // The position that the unit wants to move to.
    NSInteger x  = loc.x;
    NSInteger y = loc.y;
    NSNumber *nextPosKey = [NSNumber numberWithInt:y*BOARD_SIZE_X + x];
    NSInteger nextPosIntKey = [nextPosKey integerValue];
    // The unit who wants to move's position.
    NSInteger unitX = _currentUnit.x;
    NSInteger unitY = _currentUnit.y;
    NSNumber *unitKey = [NSNumber numberWithInt:unitY*BOARD_SIZE_X + unitX];
    NSInteger unitIntKey = [unitKey integerValue];
    
    // First check if the movement was inside the board and if the tile isn't |void| (which units cannot
    // move to).
    if(x >= 0 && x < BOARD_SIZE_X && y >= 0 && y < BOARD_SIZE_Y
       && [[[_board board] objectAtIndex:nextPosIntKey] status] != MAPSTATUS_VOID) {
        // Checks if the move is 1 step in x or y, but not both at the same time.
        if( ((x - unitX == 1 || x - unitX == -1) && y == unitY) ||
            ((y - unitY == 1 || y - unitY == -1) && x == unitX) )
        {
            // If |bigL| is standing on a cracked tile and moves away from it. This will destroy the tile,
            // making it void, and also destroying the item on it.
            if ([[[_board board] objectAtIndex:unitIntKey] status] == MAPSTATUS_CRACKED && _currentUnit == _bigL) {
                [[_board elementDictionary] removeObjectForKey:unitKey];
                [_scene removeElementAtPosition:unitKey];
                [[[_board board] objectAtIndex:unitIntKey] setStatus:MAPSTATUS_VOID];
                [_scene refreshTileAtFlatIndex:unitIntKey WithStatus:MAPSTATUS_VOID];
            }
           
            // Updates the position of curKey to the one that the unit is moving towards.
            NSNumber *nextPos = [NSNumber numberWithInt:y*BOARD_SIZE_X + x];
            // Check elements on the board.
            Element *e = [[_board elementDictionary] objectForKey:nextPos];
            
            // If the element isn't blocking, move unit.
            if(![e blocking]) {
                _currentUnit.x = x;
                _currentUnit.y = y;
                [_scene updateUnit:CGPointMake(x, y)];
                [e movedTo];
                
                // If the element is a star.
                if([e isKindOfClass:[Star class]]) {
                    _player.starsTaken += 1;
                    [[_board elementDictionary] removeObjectForKey:nextPosKey];
                    [_scene removeElementAtPosition:nextPosKey];
                }
            }
        }
    }
}

/*
 *  Called when a unit (i.e. the user) wants to do an action. First checks if the action is possible,
 *  then chooses an action based on what element the action is performed on. */
-(void)unitWantsToDoActionAt:(CGPoint)loc {
    NSInteger x = loc.x;
    NSInteger y = loc.y;

    NSNumber *actionPointKey = [NSNumber numberWithInt:y*BOARD_SIZE_X + x];
    
    NSInteger unitX = _currentUnit.x;
    NSInteger unitY = _currentUnit.y;
    
    CGPoint unitPoint = CGPointMake(unitX, unitY);
    CGPoint actionPoint = CGPointMake(x, y);
 
    // Checks if element will be next to the unit.
    if( ((x - unitX == 1 || x - unitX == -1) && y == unitY) ||
       ((y - unitY == 1 || y - unitY == -1) && x == unitX) )
    {
        Element *e = [[_board elementDictionary] objectForKey:actionPointKey];
    
        // If the element exists.
        if(e) {
            // Do action depending on element type.
            if ([e isKindOfClass:[Box class]]) {
                NSInteger dir = [Converter convertCoordsTo:actionPoint Direction:unitPoint];
                [self doActionOnRock:e InDirection:dir];
            } else if ([e isKindOfClass:[Button class]]) {
                [self doActionOnButton:e];
            }
        }
    }
}

/*
 *  Does an action on a box based on the direction. The action moves the box to a tile. */
-(void)doActionOnBox:(Element *)rock InDirection:(NSInteger)dir{
    NSNumber *nextKey;
    CGPoint nextPos;
    Element *e;
    NSNumber *elementKey = [NSNumber numberWithInteger:rock.y*BOARD_SIZE_X + rock.x];
    
    if (dir == RIGHT) {
        nextKey = [NSNumber numberWithInt:rock.y*BOARD_SIZE_X + rock.x + 1];
        e = [[_board elementDictionary] objectForKey:nextKey];
        nextPos = CGPointMake(rock.x + 1, rock.y);
    } else if (dir == LEFT) {
        nextKey = [NSNumber numberWithInt:rock.y*BOARD_SIZE_X + rock.x - 1];
        e = [[_board elementDictionary] objectForKey:nextKey];
        nextPos = CGPointMake(rock.x - 1, rock.y);
    } else if (dir == UP) {
        nextKey = [NSNumber numberWithInt:(rock.y - 1)*BOARD_SIZE_X + rock.x];
        e = [[_board elementDictionary] objectForKey:nextKey];
        nextPos = CGPointMake(rock.x, rock.y - 1);
    } else {
        nextKey = [NSNumber numberWithInt:(rock.y + 1)*BOARD_SIZE_X + rock.x];
        e = [[_board elementDictionary] objectForKey:nextKey];
        nextPos = CGPointMake(rock.x, rock.y + 1);
    }
    
    // Add more elements which cannot be pushed upon to if-statement.
    if (![e isKindOfClass:[Box class]]) {
        NSInteger intKey = [nextKey integerValue];
        NSInteger nextTile = [[[_board board] objectAtIndex:intKey] status];
        
        CGPoint posPreMove = CGPointMake(rock.x, rock.y);
        [rock doMoveAction:dir];
        
        if(nextTile != MAPSTATUS_SOLID) {
            [[_board elementDictionary] removeObjectForKey:elementKey];
            [_scene removeElementAtPosition:elementKey];
            if(nextTile == MAPSTATUS_CRACKED) {
                [[_board elementDictionary] removeObjectForKey:nextKey];
                [_scene removeElementAtPosition:nextKey];
                [[[_board board] objectAtIndex:intKey] setStatus:MAPSTATUS_VOID];
                [_scene refreshTileAtFlatIndex:intKey WithStatus:MAPSTATUS_VOID];
            }
        } else {
            [_board moveElementFrom:posPreMove To:nextPos];
            [_scene moveElement:posPreMove NewCoord:nextPos];
        }
        //nextTile should invoke its "doAction"...
    }
}

-(void)doActionOnButton:(Element *)button {
    Button *e = (Button*)button;
    e.state = !e.state;
    NSNumber *elementTargetKey = [NSNumber numberWithInteger:button.y*BOARD_SIZE_X + button.x];
    NSInteger targetKey = [elementTargetKey integerValue];
    [[_board elementDictionary] objectForKey:e.element.key];
}

/*
 *  Called when a notification of unit movement is sent from the |MainScene|. Updates the data model of the
 *  unit accordingly. */
-(void)unitMoved:(NSNotification *)notification {
    NSArray *data = [self getDataFromNotification:notification Key:UNIT_MOVED];
    NSValue *val = [data objectAtIndex:0];
    // UPDATE DATA MODEL.
}

-(NSArray*) getDataFromNotification:(NSNotification *)notif Key:(NSString *)key {
    NSDictionary *userInfo = notif.userInfo;
    NSSet *objectSent = [userInfo objectForKey:key];
    return [objectSent allObjects];
}

/*
 *  Creates the units. */
-(void)setupUnits {
    _bigL = [[BigL alloc] init];
    _littleJohn = [[LittleJohn alloc] init];
    
    _currentUnit = _littleJohn;
    _littleJohn.x = _board.startPos.x;
    _littleJohn.y = _board.startPos.y;
    CGPoint p = CGPointMake(_littleJohn.x, _littleJohn.y);
    [_scene setupUnits:p];
}

/*
 *  Adds a notification to listen to from this class. */
-(void)observeText:(NSString *)text Selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:text object:nil];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
