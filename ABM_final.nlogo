extensions [csv nw]

globals [
  vpt1 ; Trait - The post that is viewed has a trait. It belongs to some sort of category (interests/hobbies/vibe)
  vpt2 ; trait 2 of the post to add complexity to the categories
  vf ; Number - The number of followers that the agent who has posted the 'viewed post' has. This variable enables greater shifts in the trait when the agent who posted has many followers.
  poster-gender ; Categorical variable - The gender of the agent who's post is viewed (also reffered to as "the poster")
  poster-race ;Categorical varaible - The race of poster
  poster-ethnicity ; Categorical variable - The ethinicity of the poster
  poster-values ; Continuous variable - The values of the poster
  poster-belief ; Continuous variable - The beliefs of the poster
  poster-attitude ; Continuous variable - The attitude of the poster
  poster-age ; Categorical variable - The age of the poster
  attitude-diff ; The difference (absolute) in attitude between viewer and poster
  value-diff ; The difference (absolute) in value between viewer and poster
  belief-diff ; The difference (absolute) in beliefs between viewer and the poster
  race-diff ; The difference in race between viewer and the poster
  gender-diff ; The difference in gender between viewer and the poster
  age-diff ; The difference in age between viewer and the poster
  ethnicity-diff ; The difference in ethnicity between viewer and the poster
  similarity ; The similarity score between two agents - calculated based on the 7 assumptions ('homophilic' categories)
  tick-list ; A list of ticks for R purposes
  o-similarity ;a variable to enable calculations
  calculation ;a list to enable calculation of standard deviation due to problems with the use of the built in standard deviation calculation in net logo
  calculation-sd ;same as above
]

turtles-own [
  who-list ; List for identifying turtles. This has been made for R purposes
  post-list ; List for identifying which tick a given turtle posted in, for R purposes
  like-list ; List for identifying number of likes per tick for any given turtle, for R purposes
  follower-list ; List for identifying how many followers any given turtle has on each tick, for R purposes
  seed ; Number used to generate traits
  o-trait1 ; Trait 1 of the agent when spawned (original trait)
  o-trait2 ; Trait 2 of the agent when spawned
  trait1 ; Current trait 1 of agent
  trait2 ; current trait 2 of agent
  p-trait1 ; Trait 1 portrayed in the post
  p-trait2  ; Trait 2 portrayed in the post
  pervasiveness ; This is meant as a way of formalizing social conformity and the effectiveness of a turtle on the social media platform, this variable covers everything from probability of appearing in algorithm to how beatiful the agent is.
  post? ; Asks whether the agent is posting anything this tick?
  post-likes ; How many likes did the post of this tick get?
  accumulated-likes ; How many likes has the agent received in total
  followers ; How many followers does the agent have?
  eigen-centrality ; Influence of the turtle in the network
  post-tick ; Tick when turtle last posted
  gender ; Gender of agent
  age ; Age of agent
  race ; Race of agent
  ethnicity ; Ethncity of agent
  values ; Values of agent
  beliefs ; Beliefs of agent
  attitude ; Attitude of agent
  wideness ; How diverse is the agent's posting behaviour
  o-pervasiveness ;a variable which enables calculations later on
]

to setup
  clear-all ; Clears up the environment so the model can run.
  reset-ticks ; Clears up the environment so the model can run.
  set tick-list [] ; We need this to be an empty list before we run the model
  ask patches [ set pcolor white ] ; get a white background
  create-turtles 860 [
    interval ; This is a function which sets the agent's variables - it is described further in the "to interval" section
    set color blue
    set shape "circle"
    set post? false ; sets post to false
    set o-pervasiveness normal 25 4 0.1 100000000000 ; This assigns agents a pervasiveness score chosen from a normal distribution with a mean of 50 and a standard deviation of 10 - the normal function will be described further in the "to normal" section
    set pervasiveness o-pervasiveness ;sets the pervasiveness
    set followers 0 ;sets followers to 0
  ]
  layout-circle turtles max-pxcor - 1
end


to go
  post-content ; Agents decide whether or not to post - and produce post if relevant
  review-posts ; Agents decide whether or not to like/follow available posts
  update-trait ; Agents who posted updates their trait depending on number of likes
  update-stuff ; Janitor work mostly (means that this is needed in order for the model to run, but does not need further clarification to understand the conceptual part)
  get-pervasiveness ;updates users pervasiveness based on followers this is a measure of pervasiveness in algorithm as well as social conformity and so on
  tick ;makes that tick happen
end


to interval
  set who-list [] ;make list empty
  set post-list [] ;make list empty
  set like-list [] ;make list empty
  set follower-list [] ;make list empty
  seed-it ;makes a seed for the creation of traits this makes it so peopple can vary more in an interesting way
  set o-trait1 normal  seed 4 0.1  99.9 ;sets agent's trait 1 from a normal distribution with mean = seed and sd = 4
  set trait1 o-trait1 ;sets agent's current traits to the trait they spawn with so they don't start from nothing
  seed-it
  set o-trait2 normal seed 4 0.1 99.9
  set trait2 o-trait2
  set gender random 2 ;sets scores used for homophily they have as many categories as the number + 1
  set age random 4
  set race random 4
  set ethnicity random 194
  set beliefs normal 0.5 0.1 0 1
  set values normal 0.5 0.1 0 1
  set attitude normal 0.5 0.1 0 1
  set wideness normal 5 2.43 0.1 100 ; sets wideness the variable that determines how far posts can vary in traits
end

to seed-it
  set seed normal 50 20 0.1 99.9 ; sets the seed for trait making with mean = 50 and sd = 20
  if seed < 10 [set seed 5] ;these create intervals so that a seed between 0 and 10 becomes 5 and between 10 and 20 becomes 15 and so on
  if seed > 10 and seed < 20 [set seed 15]
  if seed > 20 and seed < 30 [set seed 25]
  if seed > 30 and seed < 40 [set seed 35]
  if seed > 40 and seed < 50 [set seed 45]
  if seed > 50 and seed < 60 [set seed 55]
  if seed > 60 and seed < 70 [set seed 65]
  if seed > 70 and seed < 80 [set seed 75]
  if seed > 80 and seed < 90 [set seed 85]
  if seed > 90 and seed < 100 [set seed 95]
end

to homophily
  ifelse poster-race = race [set race-diff 0] [set race-diff 1] ; sets race-diff to 0 if poster race and viewer race is the same otherwise it sets it to 1
  ifelse poster-gender = gender [set gender-diff 0] [set gender-diff 1] ; sets gender-diff to 0 if poster race and viewer race is the same otherwise it sets it to 1
  ifelse poster-ethnicity = ethnicity [set ethnicity-diff 0] [set ethnicity-diff 1] ; sets ethnicity-diff to 0 if poster race and viewer race is the same otherwise it sets it to 1
  ifelse poster-age = age [set age-diff 0] [set age-diff 1] ; sets age-diff to 0 if poster race and viewer race is the same otherwise it sets it to 1
  set belief-diff abs (poster-belief - beliefs) ; sets belief-diff to the difference between poster beliefs and viewer beliefs
  set value-diff abs (poster-values - values) ; sets value-diff to the difference between poster values and viewer values
  set attitude-diff abs (poster-attitude - attitude) ; sets attitude-diff to the difference between poster attitude and viewer attitude
  set o-similarity (attitude-diff + value-diff + belief-diff + race-diff + gender-diff + ethnicity-diff + age-diff) / 7 ;adds the differences up and divides with 7 so we get a similarity score between 0 and 1

  if o-similarity < 0.2 [set similarity 2.2 * homophily-degree] ; here we make intervals of how homophily modfies chance of like and follow ath this interval people are 220% as likely to like and follow
  if o-similarity > 0.2 and o-similarity < 0.4 [set similarity 2 * homophily-degree] ; 200%
  if o-similarity > 0.4 and o-similarity < 0.6 [set similarity 1.6 * homophily-degree] ; 160%
  if o-similarity > 0.6 and o-similarity < 0.8 [set similarity 1.2 ] ; 120%
  if o-similarity > 0.8 [set similarity 1 ] ;100% this means that the most disimlar people will not have their chance of following and liking modified



  if similarity < 1 [
    set similarity 1] ; this is no longer important don't worry about it




end


to-report normal [mid dev mmin mmax] ;function for disallowing negative values and upper boundaries without ruining the distribution
  let result random-normal mid dev ;picks random number from normal distribution
  if result < mmin or result > mmax [ report normal mid dev mmin mmax ] ;repicks number if outside boundaries this avoids the distribution piling up at the edges which would be a result of making the function simply change values under 0 to 0.1 for example
  report result ;reports the result
end

to post-content

  ask turtles [ if random 200 < round pervasiveness [ set post? true ] ] ;deciding whether to post based on how many followers agents have

  ask turtles with [ post? ] [

    set post-tick ticks ;for csv
    set p-trait1 normal trait1 wideness 0.1 100 ; sets post trait from a normal distribution with mean = trait and sd = wideness
    set p-trait2 normal trait2 wideness 0.1 100
  ] ; generates post traits portrayed based on own trait
end

to review-posts ;this is where the magic happens

  let posters [self] of turtles with [post?] ;sets up future code

  ask turtles [ ;asks all turtles to review posts
    foreach posters [ ;for every post
      x -> if x != self [ ; makes the poster x for further coding and makes sure noone likes their own posts cause that is cringe fam
        set vpt1 [p-trait1] of x ;this is all for code to run when we compare traits and update them
        set vf [followers] of x ;this is for people to update their trait based on what they like
        set poster-gender [gender] of x
        set poster-race [race] of x
        set poster-ethnicity [ethnicity] of x
        set poster-values [values] of x
        set poster-belief [beliefs] of x
        set poster-attitude [attitude] of x
        set poster-age [age] of x
        let trait-similarity abs([p-trait1] of x - [trait1] of self) + abs([p-trait2] of x - [trait2] of self) ; calculates difference in traits
        if trait-similarity < 2.5 [set trait-similarity 2.5] ;avoids low trait-similarity scores taking over the model completely
        homophily ;calculates similarity
        ifelse out-link-to x != nobody  ;if followed bigger chance of liking also no chance of following again, if not followed ask for like and follow
        [
          if random 800 < ([pervasiveness] of x * similarity) / (trait-similarity / 3);the test for whether a follower likes the post essentially the pervasiveness of the poster modified by homophily and trait similarity
          [ask x [set post-likes post-likes + 1] ;updates the post likes of the poster if post is liked
            liked-post] ;this is a function which updates the traits of the agent liking the post
        ]

        [
          if random 1000  < ([pervasiveness] of x * similarity) / (trait-similarity / 3) ; the test for liking a post of someone you don't follow, the same calculation except there is a lower chance of succeess
          [ask x [set post-likes post-likes + 1] ;updates the post likes of the poster if post is liked
            liked-post] ;this is a function which updates the traits of the agent liking the post
          if random 1500 < round ([pervasiveness] of x * similarity) and trait-similarity < 13 [ ; the test for following someone a calculation is made based on poster pervasiveness and similarity between the agents and the agents must be fairly similar
              create-link-to x]
          ]
        ]
      ]
    ]
  ;]
end

to update-trait ;updates the traits of all who posted

  ask turtles with [post?][ ;this function runs only for agents who posted this tick
    if post-likes > 1[ ;if the post got fewer likes than the poster has followers they won't update their future posts based on this post
      set trait1 trait1 + ((p-trait1 - trait1) / 1000) * (post-likes * like-trans) ;changes the given trait towards the trait of the post modified by post likes
      set trait2 trait2 + ((p-trait2 - trait2) / 1000) * (post-likes * like-trans)
      keep-it-real ;a function that keeps agents from straying to far from their original traits and keeps their traits from extreme values causing the normal function to run infinitely trying to produce a number over 0 and under 100
    ]

  ]

end
to liked-post ;updates trait based on what a user likes
  set trait1 trait1 + ((vpt1 - trait1) / 1000) * (vf * follow-trans) / 10 ;moves user trait towards post trait aplified by posters follower count modified by follow-tran
  set trait2 trait2 + ((vpt2 - trait2) / 1000) * (vf * follow-trans) / 10
  keep-it-real
end


to update-stuff

  set tick-list lput ticks tick-list ;updates lists for R
  ask turtles [
    set who-list lput who who-list  ;updates lists for R
    set post-list lput post-tick post-list ;updates lists for R
    set like-list lput post-likes like-list ;updates lists for R
    set followers count in-link-neighbors ; update number of followers based on who links to this specific turtle
    set follower-list lput followers follower-list ;updates lists for R
    set post-likes 0 ;resets post likes so it doesn't accumulate over multiple posts
    set accumulated-likes accumulated-likes + post-likes ; add likes for post in this tick to overall like counter
    set post? false ; reset status of agents, otherwise once someone has posted they will have post-status for eternity
    ifelse followers > 0 [ set size count in-link-neighbors / 10 ][set size 0.1] ; to avoid agents with 0 following to disappear from world
  ]

end

to keep-it-real
  if trait1 > o-trait1 + 13 [set trait1 o-trait1 + 13] ;if the trait of the agent is over 13 points over the original trait it sets the trait to the trait + 13
  if trait1 < o-trait1 - 13 [set trait1 o-trait1 - 13] ;if the trait of the agent is over 13 points under the original trait it sets the trait to the trait - 13
  if trait2 > o-trait2 + 13 [set trait2 o-trait2 + 13]
  if trait2 < o-trait2 - 13 [set trait2 o-trait2 - 13]
      if trait1 < 0 [set trait1 0.1] ;prevents the traits from going under 0
      if trait1 > 100 [set trait1 99] ;prevents the traits from going over 100
      if trait2 < 0 [set trait2 0.1]
      if trait2 > 100 [set trait2 99]
end

to get-pervasiveness ;updates pervasiveness based on followers
    if count links > 1 ;makes sure we don't divide with 0 and create complex numbers
  [
  set calculation [] ;makes the list empty
  ask turtles [
    set calculation lput ((count links / count turtles - followers) ^ 2) calculation ;calculates the difference between followers of each turtle and average followers of turtles squard for standard deviation calculation
  ]

  set calculation-sd sum calculation ;sums up all of the scores
  set calculation-sd sqrt (calculation-sd / count turtles) ;calculates standard deviation square root of sum of score divided by n

  if count links > 15 [ ;so people have some time to get followers before getting ruined
  ask turtles[
    if (followers - (count links / count turtles)) / calculation-sd > 2[ ; sets every agent with a follower count exceeding two standard deviations from the mean amount of followers pervasiveness to twice their original pervasiveness
    set pervasiveness o-pervasiveness * 2
  ]
    if (followers - (count links / count turtles)) / calculation-sd > 1 and (followers - (count links / count turtles)) / calculation-sd < 2 [ ; sets every agent with a follower count exceeding one standard deviation from the mean amount of followers pervasiveness to 160% of their original pervasiveness
     set pervasiveness o-pervasiveness *  1.4
    ]
            if (followers - (count links / count turtles)) / calculation-sd > 0 and (followers - (count links / count turtles)) / calculation-sd < 1 [ ;sets every agent with a follower count between -0.5 and 0.5 standard deviations under the mean to 60 % of their original pervasiveness
      set pervasiveness o-pervasiveness
        ]
    if (followers - (count links / count turtles)) / calculation-sd > -1 and (followers - (count links / count turtles)) / calculation-sd < 0 [ ;sets every agent with a follower count between -0.5 and 0.5 standard deviations under the mean to 60 % of their original pervasiveness
      set pervasiveness o-pervasiveness * 0.8
    ]
    if (followers - (count links / count turtles)) / calculation-sd > -2 and (followers - (count links / count turtles)) / calculation-sd < -0.5[ ;sets every agent with a follower count exceeding minus one standard deviation from the mean amount of followers pervasiveness to 40% of their original pervasiveness
     set pervasiveness o-pervasiveness * 0.6
    ]
      if (followers - (count links / count turtles)) / calculation-sd < -2[ ;sets every agent with a follower count exceeding minus two standard deviation from the mean amount of followers pervasiveness to 20% of their original pervasiveness
        set pervasiveness pervasiveness * 0.2]
  ]
  ]
  ]
end




to resize-nodes
  ifelse all? turtles [size <= 1]
  [ ask turtles [ set size sqrt count link-neighbors ] ]
  [ ask turtles [ set size 1 ] ]
end

to-report in-degree-quantiles

  let in-degree-list [ followers ] of turtles
  let sorted-in-degree-list sort in-degree-list

  let q1-cutoff 0.25 * count turtles
  let q2-cutoff 0.50 * count turtles
  let q3-cutoff 0.75 * count turtles

  let q1 item q1-cutoff sorted-in-degree-list
  let q2 item q2-cutoff sorted-in-degree-list
  let q3 item q3-cutoff sorted-in-degree-list

  report (list list "25% : " q1 list "50% : " q2 list "75% : " q3)

end

to-report average-path-length

  nw:set-context turtles links
  report nw:mean-path-length

end

to-report global-clustering-coefficient
  let closed-triplets sum [ nw:clustering-coefficient * count my-links * (count my-links - 1) ] of turtles
  let triplets sum [ count my-links * (count my-links - 1) ] of turtles
  report closed-triplets / triplets
end

to-report average-clustering-coefficient
  report mean [ nw:clustering-coefficient ] of turtles
end

to-report mean-eigen-centrality

  ask turtles [ set eigen-centrality nw:eigenvector-centrality ]
  report mean [ eigen-centrality ] of turtles

end
@#$#@#$#@
GRAPHICS-WINDOW
3
34
540
572
-1
-1
12.9231
1
10
1
1
1
0
0
0
1
-20
20
-20
20
0
0
1
ticks
30.0

BUTTON
629
36
699
69
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
559
75
699
108
NIL
resize-nodes
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
810
145
1038
300
Degree Distribution
In Degree
Count
1.0
300.0
0.0
20.0
false
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "histogram [followers] of turtles"

MONITOR
810
92
1039
137
Quantiles
in-degree-quantiles
17
1
11

MONITOR
810
36
1039
81
Number of Nodes and Edges
list list \"No. of Nodes: \" count turtles list \"No. of Edges: \" count links
17
1
11

MONITOR
1051
36
1191
81
Avg. no. of followers
count links / count turtles
17
1
11

MONITOR
1052
91
1192
136
Avg. Path Length
average-path-length
17
1
11

MONITOR
1052
145
1254
190
Global Clustering Coefficient
global-clustering-coefficient
17
1
11

MONITOR
1052
201
1254
246
Average Clustering Coefficient
average-clustering-coefficient
17
1
11

MONITOR
1052
255
1254
300
Eigenvector Centrality
mean-eigen-centrality
17
1
11

SLIDER
554
198
726
231
like-trans
like-trans
0
1
0.9
0.1
1
NIL
HORIZONTAL

SLIDER
556
253
728
286
follow-trans
follow-trans
0
100
1.0
0.1
1
NIL
HORIZONTAL

BUTTON
557
28
620
61
go
go\nif count links > 71000 [stop]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
559
485
731
518
homophily-degree
homophily-degree
0
10
1.0
0.1
1
NIL
HORIZONTAL

BUTTON
915
607
1452
640
NIL
nw:set-context turtles links\n  nw:save-graphml \"name.graphml\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

TikTok simulation

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
