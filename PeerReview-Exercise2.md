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
The target focus lerp camera works well but it has some flaws in its implementation. The camera properly looks ahead of the vessel at a constant speed. The camera also returns to the vessel after a set delay. However, when the camera exceeds leash distance, it is forced to stay at leash distance. This causes the camera to teleport when the camera is outside of leash distance and the effect is worsened when the vessel goes super speed. This also causes the camera to instantly snap to other side of the vessel when it changes direction since the camera is still at leash distance.

___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [X] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The 4-way speedup pushzone camera largely does not function properly. When the vessel is within the inner-most bounds of the camera, the camera does not move. When the camera is at the outer bounds of the camera, the camera moves at the same speed as the vessel. So far this part of the implementation is correct. However, when the vessel is within the speedup zone, the camera will move at a set speed regardless of whether the vessel is moving or not, which is an incorrect implementation. Additionally, it is quite easy for the vessel to end up completely outside the bounds of the camera. When this occurs, the camera essentially becomes a position lock camera.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####

#### Style Guide Exemplars ####

___
#### Put style guide infractures ####
[Local variables should not be prepended with '_'](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/1b9b50621677a2959293dceb167f8b69f5c9e5ed/Obscura/scenes/auto_scroll.gd#L22) - Only private variable names should be prepended with an underscore.
___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####
* [Script files inside scenes folder](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/tree/master/Obscura/scenes) - Most of the camera scripts are inside the scenes folder instead of the scripts folder.

* [Integer Division](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/1b9b50621677a2959293dceb167f8b69f5c9e5ed/Obscura/scenes/position_lock_lerping.gd#L6) - Godot handles the vessel base speed as an integer, so the decimal is discarded when dividing by 5. This could cause some small inconsistences depending on the vessel's base speed.

* [Unused variable](https://github.com/ensemble-ai/exercise-2-camera-control-CharlieEdwards5/blob/1b9b50621677a2959293dceb167f8b69f5c9e5ed/Obscura/scenes/lerp_smoothing_with_lead.gd#L11) - The private _speed variable is unused in this class.

#### Best Practices Exemplars ####
