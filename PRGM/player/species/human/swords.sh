#!/bin/bash

#v_		- Verbs
#b_		- body parts
#b_*_e	- Part Exists
#*_f	- Force a Word

#Verbs
export v_walk=walk
export v_run=run

#Body Words
export b_skin=skin
export b_hair=hair
#Head
export b_head=head
export b_face=face
export b_eye=eye
export b_eyes=eyes
export b_nose=nose
export b_ear=ear
export b_ears=ears
export b_mouth=mouth
export b_lips=lips
export b_hair=hair
export b_scalp=scalp

#Arms
export b_arm=arm
export b_arms=arms
export b_armpit=armpit
export b_armpits=armpits
export b_hand=hand
export b_hands=hands
export b_shoulder=shoulder
export b_shoulders=shoulders
export b_elbow=elbow
export b_elbows=elbows
export b_forearm=forearm
export b_forearms=forearms
export b_finger=finger
export b_fingers=fingers
export b_nail="finger nail"
export b_nails="finger nails"
#export b_pawpad="finger print"
#export b_pawpads="finger prints"


#Body
export b_body=body
export b_chest=chest
export b_chest_f=chest
export b_upper_body=chest
export b_lower_body=torso
export b_waist=waist
export b_hips=waist
export b_crotch=crotch
if [ "$_gender" = Female ]; then
export b_chest=breasts
export b_hips=hips
fi

#Legs
export b_leg=leg
export b_legs=legs
export b_thigh=thigh
export b_thighs=thighs
export b_knee=knee
export b_knees=knees
export b_ankle=ankle
export b_ankles=ankles
export b_foot=foot
export b_feet=feet
export b_toe=toe
export b_toes=toes


#Existant Parts
export b_fur_e=false
export b_tail_e=false
export b_heel_e=true


