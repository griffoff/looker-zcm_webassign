# User Guide

Definition of Terms
By nature, the project requires data to be sub-divided and aggregated at different levels or views. These levels and views have been named to distinguish seemingly identical fields. The names were given based on my best attempt at briefly describing their significance as concisely as possible. However, with a lack of fluency in Market Development jargon, I am not confident I chose the best naming conventions. This section aims to define some terms I use throughout this document.

Levels
The term “Level” refers to granularity as you drill deeper into entities existing within higher level entities (i.e. Institutions within a state, instructors within an institution, etc.). There are many levels. The following are the most notable. (note: an asterisk indicates that pre-aggregated dimensions exist at these levels):
• State
• School*
• Course Topic
• Course Instructor*
• Course
• Section

Pre-Aggregated Dimensions (Rolled-up Values)
Typically, measures are used to aggregate values when putting together a report. These measures are dynamic and are aggregated at the time of the query for the most granular field pulled in by the user. Pre-aggregated dimensions, on the other hand, are static. They are calculated for a specific scenario and must be used in that scenario to be accurate. Pre-aggregated measures are helpful in allowing us to see rolled up values, like # sections at an institution, side by side with drilled down values, the # sections for each instructor at that institution. Due to this, there is a potential for pre-aggregated dimensions to be used incorrectly. Here are some things to consider if you decide to use them:
1.  Pre-aggregated dimensions only exist for the school and/or instructor levels.
2.  A Pre-aggregated dimension’s value counts unique values for all academic years and course topics that define the view  it is associated with.
3.  It is important that when using pre-aggregated dimensions, the level at which the aggregation takes place, must be at the same level or higher (“Rolled-Up”) as the most granular field in the query.
4.  If you decide to use a pre-aggregated measure and want to look at values broken out by academic year or course topic, make sure to pivot these fields (rather than add to rows). The pre-aggregated dimension will not be broken out, but measures will.
5.  Be mindful of cardinality when exporting a report into another application (i.e. excel) for further analysis. Looker calculates unique values which may be counted multiple times when rolled-up outside of Looker. For example, Prof. Plum, a section instructor, teaches sections under three different course instructors. If you pull a report that counts the number of section instructors for each course instructor Prof. Plum would be counted three times if you were to roll-up the value of each course instructor to the institution level.
Below are the fields which have been pre-aggregated.

Number of Sections
Number of Course Topics
Number of Academic Years w/ Registrations
Number of Section Instructors Managed
Number of Registrations


Views
A view is like a model within the larger model. It uses different rules and parameters to filter and select a subset of data that reports values from different perspectives. This model contains three different views :
1.  Lifetime View – This is the base view for the model and is used as the starting point for the other two views. It includes data from all academic years available and is used to report on an entity’s loyalty and longevity using WebAssign.
2.  Targeted View – Filters and selects data from the Lifetime view, but only includes recent academic years. Entities without recent activity are not included on this list and pre-aggregated dimensions for those that do only calculate on the academic years included
3.  Core Gateway View – Also filters and selects data from the Lifetime view, for the same period as the Targeted view, but only includes courses that fall under one of the 3 Core Gateway course topics .

This user guide is not finished. Contact Chip Moreland with questions
    - cmorelan@gmail.com
    - (916) 850-5479
