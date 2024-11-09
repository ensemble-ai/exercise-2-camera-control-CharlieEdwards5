# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Casey Downing
* *email:* cdowning@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [X] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The position lock camera functions exactly as expected. The vessel is always at the center of the camera frame and it draws a cross in the middle of the screen.
___
### Stage 2 ###

- [X] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The autoscroller camera functions perfectly. The camera moves at a set speed to the right and the vessel is unable to leave the bounds of the camera. The vessel also moves at the same speed as the camera.

___
### Stage 3 ###

- [ ] Perfect
- [X] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The position lock lerp camera is almost perfect. When the vessel moves, the camera follows at a constant speed. When the vessel stops, the camera catches up. However, when the vessel reaches leash distance, the camera begins to make large leaps towards the vessel to keep it within leash distance. This causes the camera to create a stuttering effect.

___
### Stage 4 ###

- [ ] Perfect
- [ ] Great
- [X] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The target focus lerp camera works well but it has some flaws in its implementation. The camera properly looks ahead of the vessel at a constant speed. The camera also returns to the vessel after a set delay which works well. However, when the camera exceeds leash distance, it is forced to stay at leash distance. This causes the camera to teleport when the camera is outside of leash distance and the effect is worsened when the vessel goes super speed. 

This also causes the camera to instantly snap to other side of the vessel when it changes direction since the camera is still considered to be at leash distance. Essentially, the camera is set to be at leash distance if if tries to exceed it. When the vessel quickly changes direction while the camera is set to leash distance, the camera will snap to the new vessel direction while it still wants to maintain exact leash distance.

___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [X] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The 4-way speedup pushzone camera largely does not function properly. When the vessel is within the inner-most bounds of the camera, the camera does not move. When the camera is at the outer bounds of the camera, the camera moves at the same speed as the vessel. So far this part of the implementation is correct. However, when the vessel is within the speedup zone, the camera will move at a set speed regardless of whether the vessel is moving or not. The the camera should only be moving when the vessel is moving. Additionally, it is quite easy for the vessel to end up completely outside the bounds of the camera. When this occurs, the camera essentially becomes a position lock camera.

It appears that the camera will act as a functional push box when the vessel is against the sides. However, as soon as the vessel touches the corner, the camera teleports and the vessel will be outside of the camera. I believe this is due to an overlap in domains. For example, when the camera is touching the top or bottom edges of the push box, the camera moves in both the z-axis and x-axis. However, the top and bottom edges only need to handle the z-axis and can leave the x-axis to the left and right edges. Simply removing [these](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/b5ba46b5703555af585a2b37c16cbfafe2100bbf/Obscura/scenes/four_way_speedup_push_zone.gd#L74) [lines](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/b5ba46b5703555af585a2b37c16cbfafe2100bbf/Obscura/scenes/four_way_speedup_push_zone.gd#L77) seems to fix the issue.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####

* [Local variables prepended with '_'](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/1b9b50621677a2959293dceb167f8b69f5c9e5ed/Obscura/scenes/auto_scroll.gd#L22) - Only private variable names should be prepended with an underscore.

#### Style Guide Exemplars ####

* [Declaring local variables near their use](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/b5ba46b5703555af585a2b37c16cbfafe2100bbf/Obscura/scenes/auto_scroll.gd#L22) - It is good practice to declare local variables near where they are used so they are easy to find.

* [Proper variable order](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/b5ba46b5703555af585a2b37c16cbfafe2100bbf/Obscura/scenes/position_lock_lerping.gd#L5) - The variables are in proper order with exported variables at the top and private variables below.

* [Separating logic sections of code](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/b5ba46b5703555af585a2b37c16cbfafe2100bbf/Obscura/scenes/four_way_speedup_push_zone.gd#L40) - Separting logical sections of code is good for readability and this is done well throughout the code base.

* [Wrapping long conditional expressions](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/b5ba46b5703555af585a2b37c16cbfafe2100bbf/Obscura/scenes/four_way_speedup_push_zone.gd#L33) - This is a great example of wrapping long conditional expressions with parentheses to increase code readability by separating parts of the expression onto new lines.

Overall, the code does a great job following the style guide. Separating logical parts of code and separating conditional expressions onto new lines are parts of the style guide that could be easily overlooked. Even the comments are well written where they consistently start with capital letters and contain a space following the '#'. 
___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####
* [Script files inside scenes folder](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/tree/master/Obscura/scenes) - Most of the camera scripts are inside the scenes folder instead of the scripts folder.

* [Integer division](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/1b9b50621677a2959293dceb167f8b69f5c9e5ed/Obscura/scenes/position_lock_lerping.gd#L6) - Godot handles the vessel base speed as an integer, so the decimal is discarded when dividing by 5. This could cause some small inconsistences depending on the vessel's base speed.

* [Unused variable](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/1b9b50621677a2959293dceb167f8b69f5c9e5ed/Obscura/scenes/lerp_smoothing_with_lead.gd#L11) - The private _speed variable is unused in this class.

* [Exported variables without default values](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/b5ba46b5703555af585a2b37c16cbfafe2100bbf/Obscura/scenes/auto_scroll.gd#L5) - It is good practice to give exported variables default values so that when they are changed in the editor they can be reverted back to working default values.

#### Best Practices Exemplars ####

* [Use of comments](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/b5ba46b5703555af585a2b37c16cbfafe2100bbf/Obscura/scenes/position_lock_lerping.gd#L41) - Comments are used throughout the code base to explain logic. This particular example shows a comment that explains a line of code that could be unclear to a reader of its purpose.

None of the best practices infractions would have a large effect on the code but they could make debugging a little more difficult. Otherwise, I appreciate the attention to detail with the comments.