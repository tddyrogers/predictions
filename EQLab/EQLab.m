(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Input::Initialization:: *)
FunctionsAreInitizialed=False;


(* ::Input::Initialization:: *)
npredictorsDEFAULT=4;
nquestionsDEFAULT=20;


(* ::Input::Initialization:: *)
VARNAME={
"npredictors",
"nquestions"
};
SUPERARRAYNAME={
"EXPERIMENT",
"PLOTS"
};


(* ::Input::Initialization:: *)
InitVariables[]:=Module[
{ivar=1,ivarmax=(VARNAME//Length),userdefined=False,
var="",user="",default=""},
For[ivar=1,ivar<=ivarmax,ivar++,
var=VARNAME[[ivar]];
user=VARNAME[[ivar]]<>"USER";
default=VARNAME[[ivar]]<>"DEFAULT";
userdefined=(user//ToExpression//NumberQ);
Which[userdefined,var<>"="<>user,True,var<>"="<>default]//ToExpression;
]
]

InitSuperarrays[]:=Module[
{isuperarray=1,isuperarraymax=(SUPERARRAYNAME//Length),userdefined=False,
superarray="",user="",default=""},
For[isuperarray=1,isuperarray<=isuperarraymax,isuperarray++,
superarray=SUPERARRAYNAME[[isuperarray]];
superarray<>"={}"//ToExpression;
]
]


Init[]:=Module[
{},
InitVariables[];
InitSuperarrays[];
]

Init[];



(* ::Input::Initialization:: *)
Outcome[question_]:=question[[3]]//Mean//N//Sign;

Surprisal[question_]:=Table[Which[NumericQ[question[[1,i]]]&&NumericQ[question[[4]]],Which[question[[4]]>0,-Log[question[[1,i]]],question[[4]]<0,-Log[1-question[[1,i]]],question[[4]]==0,0],True,I],{i,1,question[[1]]//Length}];
Reward[question_]:=Module[
{R,pi,si,pc,c=1,q,V,smean,\[CapitalDelta]s,ri,ipredictor,r={}(*List of rewards *)},
smean=question[[5]]//Mean;
\[CapitalDelta]s=question[[5]]//StandardDeviation;
V=question[[3]]//Mean//Abs;
R=\[CapitalDelta]s*V//Abs;
pc=Exp[-smean-c*\[CapitalDelta]s];

q=question[[4]];

For[ipredictor=1,ipredictor<=npredictors,ipredictor++,

pi=question[[1,ipredictor]];

si=question[[5,ipredictor]];

ri=Which[
q>0,R Log[pi/pc],
q<0,R Log[(1-pi)/pc],
q==0,0
];

(*update rj: sbig-s can be negative, so use a theta function*)
ri=ri*HeavisideTheta[smean+\[CapitalDelta]s-si]//ReplaceAll[HeavisideTheta[0]->0];

AppendTo[r,ri];


];

r

]



(* ::Input::Initialization:: *)

blankpredictorcontainer[]:=Module[
{forecast},
forecast=ConstantArray[0,npredictors]
]

blankpredictorcontainer[init_]:=Module[
{forecast},
forecast=ConstantArray[init,npredictors]
]

blankquestion[]:=Module[
{question,
p,m,v,q,s,r},

p=blankpredictorcontainer[];
m=0;
v=blankpredictorcontainer[];
q=0;
s=blankpredictorcontainer[Indefinite];
r=blankpredictorcontainer[];

question={
p,
m,
v,
q,
s,
r
};

question
]


blankexperiment[]:=Module[
{experiment,
p,m,v,q,s},
experiment={}
]



(* ::Input::Initialization:: *)

SetAttributes[askquestion,HoldAll];
SetAttributes[predict,HoldAll];
SetAttributes[measure,HoldAll];
SetAttributes[resolve,HoldAll];
SetAttributes[outcome,HoldAll];
SetAttributes[surprisal,HoldAll];
SetAttributes[reward,HoldAll];

predict[experiment_,newquestion_]:=Module[
{p},
p=PREDICT[experiment];
newquestion=newquestion//ReplacePart[1->p];
]

measure[newquestion_]:=Module[
{m},
m=MEASURE[];
newquestion=newquestion//ReplacePart[2->m];
]

resolve[experiment_,newquestion_]:=Module[
{v},
v=RESOLVE[experiment,newquestion];
newquestion=newquestion//ReplacePart[3->v];
]

outcome[newquestion_]:=Module[
{q},
q=Outcome[newquestion];
newquestion=newquestion//ReplacePart[4->q];
]

surprisal[newquestion_]:=Module[
{s},
s=Surprisal[newquestion];
newquestion=newquestion//ReplacePart[5->s];
]

reward[newquestion_]:=Module[
{r},
r=Reward[newquestion];
newquestion=newquestion//ReplacePart[6->r];
]


askquestion[experiment_]:=Module[
{newquestion=blankquestion[]},

predict[experiment,newquestion];
measure[newquestion];
resolve[experiment,newquestion];
outcome[newquestion];
surprisal[newquestion];
reward[newquestion];

AppendTo[experiment,newquestion]

]



(* ::Input::Initialization:: *)

defaultforecastinit=Table[Random[],{i,1,npredictors}];Protect[defaultforecastinit]

DefaultPredict[exp_]:=Module[
{ipredictor,n=(exp//Length),\[Rho]new,RHOnew={}},(*internal variables*)

For[ipredictor=1,ipredictor<=npredictors,ipredictor++,(*loop over users*)

If[(*to execute commands that depend on the question number 'n+1' *)
n==0,(*if*)

\[Rho]new=defaultforecastinit[[ipredictor]],(*then*)

\[Rho]new=exp[[n,1,ipredictor]](*else*)

];

AppendTo[RHOnew,\[Rho]new];

];

RHOnew

]

DefaultMeasure[]:=(Random[]//Which[#<0.4,1,True,-1]&);


(*to match function prototype *)
DefaultResolve[experiment_,question_]:=DefaultResolve[question];
(*actual function*)
DefaultResolve[question_]:=Table[Random[]//Which[#<0.05,-question[[2]],True,question[[2]]]&,{i,1,question[[1]]//Length}]



SetDefaultFunctions[]:=Module[
{},
PREDICT=DefaultPredict;
MEASURE=DefaultMeasure;
RESOLVE=DefaultResolve;

Unprotect[FunctionsAreInitizialed];
FunctionsAreInitizialed=True;
Protect[FunctionsAreInitizialed];

]

SetUserFunctions[]:=Module[
{isprotected=FunctionsAreInitizialed//Attributes//MemberQ[#,Protected]&},

(*Names["Global`UserPredict"];*)

PREDICT=UserPredict;
MEASURE=UserMeasure;
RESOLVE=UserResolve;

Unprotect[FunctionsAreInitizialed];
FunctionsAreInitizialed=True;
Protect[FunctionsAreInitizialed];

]





(* ::Input::Initialization:: *)
PLOTSTYLE1={
ASPECTRATIO->5/8,
IMAGESIZE->360,
IMAGEPADDING->{{0, 20}, {0,20}},
PLOTRANGEPADDING->Scaled[.1],
PLOTMARKERS->"OpenMarkers",
PLOTRANGE->Full,
LABELSTYLE->Directive[Black,Bold,Medium]
};
PLOTSTYLE2={
ASPECTRATIO->5/8,
IMAGESIZE->400,
IMAGEPADDING->{{0, 20}, {0,20}},
PLOTRANGEPADDING->Scaled[.1],
PLOTMARKERS->"OpenMarkers",
PLOTRANGE->Full,
LABELSTYLE->Directive[Black,Bold,Medium]
};

pPlot[iexperiment_]:=(Table[EXPERIMENT[[iexperiment,All,1]][[All,i]],{i,1,npredictors}]//ListLogLinearPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(p\), \(\(\\\ \)\(i\\\ j\)\)]\)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE1);
mPlot[iexperiment_]:=(EXPERIMENT[[iexperiment,All,2]]//ListLogLinearPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(m\), \(\(\\\ \)\(j\)\)]\)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE1);

vPlot[iexperiment_]:=(Table[EXPERIMENT[[iexperiment,All,3]][[All,i]],{i,1,npredictors}]//ListLogLinearPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(v\), \(\(\\\ \)\(i\\\ j\)\)]\)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE1);

qPlot[iexperiment_]:=(EXPERIMENT[[iexperiment,All,4]]//ListLogLinearPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(q\), \(\(\\\ \)\(j\)\)]\)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE1);


sPlot[iexperiment_]:=(Table[EXPERIMENT[[iexperiment,All,5]][[All,i]],{i,1,npredictors}]//ListLogLinearPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(s\), \(\(\\\ \)\(i\\\ j\)\)]\)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE1);

rPlot[iexperiment_]:=(Table[EXPERIMENT[[iexperiment,All,6]][[All,i]],{i,1,npredictors}]//ListLogLogPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->PLOTMARKERS,PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(r\), \(\(\\\ \)\(i\\\ j\)\)]\)"},LabelStyle->LABELSTYLE]&/.PLOTSTYLE1);


sStatPlot[iexperiment_]:=(Table[(Around[EXPERIMENT[[iexperiment,All,5]][[i]]//Mean,EXPERIMENT[[iexperiment,All,5]][[i]]//StandardDeviation]),{i,1,EXPERIMENT[[iexperiment,All,5]]//Length}]//ListLogLinearPlot[#,AspectRatio->ASPECTRATIO,ImageSize->IMAGESIZE,ImagePadding->IMAGEPADDING,PlotRangePadding->PLOTRANGEPADDING,PlotMarkers->{marker1,0.016},PlotStyle->Directive[Red],PlotRange->PLOTRANGE,AxesLabel->{"j","\!\(\*SubscriptBox[\(s\), \(\(\\\ \)\(j\)\)]\)"},LabelStyle->LABELSTYLE(*,Epilog\[Rule]{Directive[Red,Thick],Line[{{0,prob},{100,prob}}]}*)]&/.PLOTSTYLE1);
marker1=Graphics[{Blue,Disk[]}];


(* ::Input::Initialization:: *)

RunExperiment[]:=Module[
{experiment=blankexperiment[],iquestion},

(*to set  default functions if user has not define their own *)
If[
!FunctionsAreInitizialed,
SetDefaultFunctions[],
Unprotect[FunctionsAreInitizialed];
FunctionsAreInitizialed=True;
Protect[FunctionsAreInitizialed]
];

For[iquestion=1,iquestion<=nquestions,iquestion++,
askquestion[experiment]
];

AppendTo[EXPERIMENT,experiment];

]



MakePlots[iexperiment_]:=Module[
{plots={},length},
If[
(EXPERIMENT//Length)<iexperiment,(*if*)

Print["Experiment i = ",iexperiment," no present."],(*then*)

AppendTo[plots,pPlot[iexperiment]];(*else*)
AppendTo[plots,mPlot[iexperiment]];
AppendTo[plots,vPlot[iexperiment]];
AppendTo[plots,qPlot[iexperiment]];
AppendTo[plots,sPlot[iexperiment]];
AppendTo[plots,rPlot[iexperiment]];
AppendTo[plots,sStatPlot[iexperiment]];

length=(PLOTS//Length);

While[length<iexperiment,  AppendTo[PLOTS,0]  ;length++];

PLOTS[[iexperiment]]=plots;

]
]

MakePlots[]:=Module[
{iexperiment},
For[iexperiment=1,iexperiment<=(EXPERIMENT//Length),MakePlots[iexperiment];iexperiment++]
]

ShowPlots[iexperiment_]:=Module[
{},

Grid[
{
{PLOTS[[iexperiment,1]], PLOTS[[iexperiment,2]],PLOTS[[iexperiment,3]]}, 
{PLOTS[[iexperiment,4]],PLOTS[[iexperiment,5]],PLOTS[[iexperiment,6]]},
{Nothing,PLOTS[[iexperiment,7]],Nothing}
},
Spacings->{2,3}
]
]

