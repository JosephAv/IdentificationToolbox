(* ::Package:: *)

(* 
*             Smoothing.m -     a Mathematica Package for Data Smoothing
*
*                                       Marco Gabiccini
*
*             Dipartimento di Ingegneria Meccanica, Nucleare e della Produzione
*             Facolt\[AGrave] di Ingegneria - Universit\[AGrave] di Pisa
*             56122 Pisa (PI) - Italy
*
*  Copyright (c) 2010-2011, Marco Gabiccini
*  Permission is granted to copy, modify and redistribute this file,
*  provided that this header message is retained. 
*
* Version 0.01
*
*)

Needs["ScrewCalculusPro`", "ScrewCalculusPro`ScrewCalculusPro`"]

BeginPackage["Smoothing`", "ScrewCalculusPro`"]

(*
*  Preamble for Function Usage
*
*  Document all of the functions which are defined in this file.
*  Example: obtain documentation for function RotationQ just typing
*           ?RotationQ
*  
*)

(*
*  Beginning of private section of the package
*)

(* Utility functions for manipulating matrices *)

MovingLeastSquaresSmoothing::usage=
"To be completed."

MovingAverageSmoothing::usage=
"To be completed."


(* Begin["`Private`"] *)

eps = 10^(-12);

ReadMarkersDataManyFiles[filenameslist_]:=
	Module[{MaxNMarker, (* Nmarker,*) MarkerFirstIndex, i, j, jcount, length, ID, samples, row, col,
		    nofiles, k},
		
		nofiles = Length[filenameslist];  
		rawdata = ReadList[filenameslist[[1]], Number, RecordLists -> True];
		
		For[ k=2, k<=nofiles, k++,
			
			rawdata = Join[ rawdata, ReadList[filenameslist[[k]], Number, RecordLists -> True] ];
			
		];
		
		length = Length[rawdata];
		 
		 (* con questa parte commentata dobbiamo fornire nel main
		    la MarkerIDs e il loro numero *)
		(*
		MaxNMarker = 100; 
		Nmarker = 1;
		
		MarkerFirstIndex = rawdata[[1,1]];
		 
		MarkerIDs = Table[0, {MaxNMarker}];
		
		MarkerIDs[[1]] = MarkerFirstIndex;
		
		For[i = 2, i < MaxNMarker, i++, 
			MarkerIDs[[i]] = rawdata[[i,1]];
			Nmarker ++;
			If[Abs[ MarkerIDs[[i]] - MarkerFirstIndex] < eps, Break[] ];
			 ];
			 
		Nmarker = Nmarker - 2;
		
		MarkerIDs = MarkerIDs[[1;;Nmarker]];
		
		*)
		
		samples = 1;
		
		For[jcount = 1, jcount<=length, jcount++,
		
		   If[ IntegerQ[ rawdata[[jcount, 1]] ], 
		  		Continue[];
		  		,
			    samples = samples + 1;
				Continue[];	
		  	 ];
		    ];
		    
		Print["Allocating XYZs matrix..."];   
		
		XYZs = Table[0, {Global`Nmarker},{samples} ];
		XYZs[[All, 1]] = Global`MarkerIDs; 
			
		col = 2;
		  
		 For[ j=1, j<=length, j++,
		 	
		 	(*Print["Reading line j=", j];*)
		 	ID = rawdata[[j, 1]];
		  	
		  	Which[ (IntegerQ[ ID ]) && (MemberQ[Global`MarkerIDs, ID ]), 
		  		
		  		row = Position[ Global`MarkerIDs, ID ][[1,1]];
		  		
		  		(*Print["Copying new value for marker in position = ", row];*)
		  		
			    XYZs[[row, col]] = rawdata[[j, 3;;5]];,
			    
			    (Not[IntegerQ[ ID ]]),
			    
			    (*Print["Switching to a new time instant... ", col+1];*)
		  		col = col + 1;
				Continue[];	
		  	];
			
		  ];
	    
	    Nsamples = samples;
	    
	    Nrows = Global`Nmarker;
	    Ncols = Nsamples;
			 
		Return[XYZs];	
		Print["Finished!"]; 
		
	];

ReadMarkersData[filename_]:=
	Module[{MaxNMarker, (* Nmarker,*) MarkerFirstIndex, i, j, jcount, length, ID, samples, row, col},
		
		rawdata = ReadList[filename, Number, RecordLists -> True];
		length = Length[rawdata];
		 
		 (* con questa parte commentata dobbiamo fornire nel main
		    la MarkerIDs e il loro numero *)
		(*
		MaxNMarker = 100; 
		Nmarker = 1;
		
		MarkerFirstIndex = rawdata[[1,1]];
		 
		MarkerIDs = Table[0, {MaxNMarker}];
		
		MarkerIDs[[1]] = MarkerFirstIndex;
		
		For[i = 2, i < MaxNMarker, i++, 
			MarkerIDs[[i]] = rawdata[[i,1]];
			Nmarker ++;
			If[Abs[ MarkerIDs[[i]] - MarkerFirstIndex] < eps, Break[] ];
			 ];
			 
		Nmarker = Nmarker - 2;
		
		MarkerIDs = MarkerIDs[[1;;Nmarker]];
		
		*)
		
		samples = 1;
		
		For[jcount = 1, jcount<=length, jcount++,
		
		   If[ IntegerQ[ rawdata[[jcount, 1]] ], 
		  		Continue[];
		  		,
			    samples = samples + 1;
				Continue[];	
		  	 ];
		    ];
		    
		Print["Allocating XYZs matrix..."];   
		
		XYZs = Table[0, {Global`Nmarker},{samples} ];
		XYZs[[All, 1]] = Global`MarkerIDs; 
			
		col = 2;
		  
		 For[ j=1, j<=length, j++,
		 	
		 	(*Print["Reading line j=", j];*)
		 	ID = rawdata[[j, 1]];
		  	
		  	Which[ (IntegerQ[ ID ]) && (MemberQ[Global`MarkerIDs, ID ]), 
		  		
		  		row = Position[ Global`MarkerIDs, ID ][[1,1]];
		  		
		  		(*Print["Copying new value for marker in position = ", row];*)
		  		
			    XYZs[[row, col]] = rawdata[[j, 3;;5]];,
			    
			    (Not[IntegerQ[ ID ]]),
			    
			    (*Print["Switching to a new time instant... ", col+1];*)
		  		col = col + 1;
				Continue[];	
		  	];
			
		  ];
	    
	    Nsamples = samples;
	    
	    Nrows = Global`Nmarker;
	    Ncols = Nsamples;
		Print["Finished!"]; 			 
		Return[XYZs];	

		
	];
	
DefineRange[MarkerPos_]:=
	Module[{Xmin, Xmax,
		    Ymin, Ymax,
		    Zmin, Zmax},
		
		Xmin = Min[CoordsXYZs[[ MarkerPos, 2 ;; ]][[All, All, 1]]];
		Xmax = Max[CoordsXYZs[[ MarkerPos, 2 ;; ]][[All, All, 1]]];
		
		Ymin = Min[CoordsXYZs[[ MarkerPos, 2 ;; ]][[All, All, 2]]];
		Ymax = Max[CoordsXYZs[[ MarkerPos, 2 ;; ]][[All, All, 2]]];
		
		Zmin = Min[CoordsXYZs[[ MarkerPos, 2 ;; ]][[All, All, 3]]];
		Zmax = Max[CoordsXYZs[[ MarkerPos, 2 ;; ]][[All, All, 3]]];
		
		Return[{ {Xmin, Xmax}, {Ymin, Ymax}, {Zmin, Zmax} }];
		
	];	

(* Battaglia and Senni 2011/12/21 *)
DefineRangeWRToBracelet[MarkerPos_]:=
	Module[{Xmin, Xmax,
		    Ymin, Ymax,
		    Zmin, Zmax},
		
		Xmin = Min[SmoothedCoordsXYZsWRToBracelet[[ MarkerPos, 2 ;; ]][[All, All, 1]]];
		Xmax = Max[SmoothedCoordsXYZsWRToBracelet[[ MarkerPos, 2 ;; ]][[All, All, 1]]];
		
		Ymin = Min[SmoothedCoordsXYZsWRToBracelet[[ MarkerPos, 2 ;; ]][[All, All, 2]]];
		Ymax = Max[SmoothedCoordsXYZsWRToBracelet[[ MarkerPos, 2 ;; ]][[All, All, 2]]];
		
		Zmin = Min[SmoothedCoordsXYZsWRToBracelet[[ MarkerPos, 2 ;; ]][[All, All, 3]]];
		Zmax = Max[SmoothedCoordsXYZsWRToBracelet[[ MarkerPos, 2 ;; ]][[All, All, 3]]];
		
		Return[{ {Xmin, Xmax}, {Ymin, Ymax}, {Zmin, Zmax} }];
		
	];	
(* end Battaglia and Senni 2011/12/21 *)

ZeroCoordsPositions[list_] := Module[
   {i, n, zeroBoundaries, thisbound, first, opened, this, previous},
   
   n = Length[list];
   zeroBoundaries = {};
   thisbound = {};
   first = list[[1]];
   opened = 0;
   
   		If[Not[first === 0],
    			thisbound = Append[thisbound, 1];
    			opened = 1;
    					  , 
    		    thisbound = Append[thisbound, 0];
                opened = 1;
           ];
           
           (*
             Print["Opened = ", opened];
             Print["thisbound = ", thisbound];
            *)
   
   For[i = 2, i <= n, i++, (* Print["Reading list :: element i:", i]; *)
    					  this = list[[i]];
                          previous = list[[i - 1]];
    
   			 Which[
   			 	
   			 	
   			 	   opened == 1,
     				     (* Print["Opened branch"]; *)
     
                         If[Not[this === 0],
      
                            thisbound = Append[thisbound, i];
             				zeroBoundaries = Append[zeroBoundaries, thisbound];
             				(* Print["Added : ", zeroBoundaries]; *)
             				thisbound = {};
             				opened = 0;
        					];,
     
    			    opened == 0,
    			           
    			           (* Print["Closed branch"]; *)
     
   						  If[((Not[previous === 0]) && (this === 0)),
       
       						 thisbound = Append[thisbound, i-1];
       						opened = 1;
       						];
      			   ];
        ];
        
        If[opened == 1,
        	
        	thisbound = Append[thisbound, n+1];
            zeroBoundaries = Append[zeroBoundaries, thisbound];
        	
        ];
        
        If[zeroBoundaries[[1]] == {1,2},
           zeroBoundaries = Drop[zeroBoundaries, 1];
           ];
        
        Return[zeroBoundaries];
   
   ];
   

(*	
ZeroCoordsPositions[list_]:=
	Module[{zeroListPositions, length, zeroBoundaries, i, this, next, j, ffwdthis, ffwdnext},
		
		zeroListPositions = Flatten[Position[list, 0]];
		(*Print[zeroListPositions];*)
		length = Length[zeroListPositions];
		zeroBoundaries = {};
		
		For[i = 1, i < length, i++,
			
			Print["Main cycle i:", i];
			
			this = zeroListPositions[[i]];
			next = zeroListPositions[[i+1]];
			
			Print["Value of this:", this];
			
			(*If[i == length - 1,
	                 Break[]		
			  ];
			  *)
			  
			 Print["Value of next:", next]; 
			
			 If[ (next-this) > 1,
				
				Print["Segment added: (", this-1,", ", this+1,")"];
				zeroBoundaries = Append[zeroBoundaries, {this-1, this+1}],
				
				For[j = i+1, j < length, j++,
					
					Print["Entering nested cycle j:", j];
					
					ffwdthis   = zeroListPositions[[j]];
					ffwdnext   = zeroListPositions[[j+1]];
					
					Which[
						j+1 == length, 
						zeroBoundaries = Append[zeroBoundaries, {this-1, ffwdnext+1}];
						Print["Segment added: (", this-1,", ", ffwdnext+1,")"];
						Print["Visited all vector elements!"];
						i=j;
						Print["Back to main cycle with i:", i];
						Break[];
					    ,
					    
				        (ffwdnext - ffwdthis) > 1,
				    	zeroBoundaries = Append[zeroBoundaries, {this-1, ffwdthis+1}];
				    	Print["Segment added: (", this-1,", ", ffwdthis+1,")"];
				    	i=j;
				    	Print["Back to main cycle with i:", i];
				    	Break[];
				    	,
				    	
				    	True,
				    	j;
				         ];
				    ];
				   
				
			   ];
			
		   ];
		
		Return[zeroBoundaries];
		
	];	
*)
	
ZeroCoordsPositionsToRemove[list_]:=
	Module[{zeroListPositions, length, zeroBoundaries, i, this, next, j, ffwdthis, ffwdnext},
		
		zeroListPositions = Position[list, 0];
		
		Return[zeroListPositions];
	];	
	
BridgeList[list_, span_:0]:=
	Module[{modlist, listlength, boundarylist, boundarylistlength, i, left, right, preright, postleft,
		
		    maxleftspan, maxrightspan, begin, end, FunOrder, tholes, tholesRescaled, holes, Xholes, Yholes, Zholes, u, f, fx, fy, fz, bridge},
		
		modlist = list;
		
		listlength = Length[list];
		boundarylist = ZeroCoordsPositions[list];
		boundarylistlength = Length[boundarylist];
		
		For[i=1, i<=boundarylistlength, i++,
		
		  left     = boundarylist[[i,1]];
		  right    = boundarylist[[i,2]];
		  
		  Which[(left==0) && (right == listlength + 1),
		  	               modlist = Table[{0,0,0}, {listlength}];
		  	               Continue[];,
		  	     
		  	    left == 0, 
		  	               (* Print["Recovering head values..."]; *)
		  	               modlist[[1 ;; right-1]] = Table[ modlist[[right]], {right-1} ];
		  	               Continue[];,
		  	    right == listlength + 1,
		  	               (* Print["Recovering tail values..."]; *)
		  	               modlist[[left+1 ;; listlength]] = Table[ modlist[[left]], {listlength-left} ];
		  	               Continue[];,
		  	    True,
		  	               (*
		  	               Definiamo il max span a sx e dx per costruire la curva smooth
		  	               *)
		  	               
		  	               
		  	              If[(i>1) && (i<boundarylistlength) && (span != 0),
		  	              	
		  	              	(* Print["Spline bridging..."]; *)
		  	               	preright = boundarylist[[i-1,2]];
		  	           	    postleft = boundarylist[[i+1,1]]; 	
		  	               	
		  	                maxleftspan  = left - preright;
		  	                maxrightspan = postleft - right;	
		  	               	
		  	                begin = left  - Min[maxleftspan, 3];
		  	                end   = right + Min[maxrightspan, 3];	
		  	               
		  	                FunOrder = Min[3, maxleftspan + maxrightspan + 1]; 
		  	                     (* 1 + maxleftspan + 1  + maxrightspan - 1, perche per una cubica servono almeno 4 punti *)
		  	               	,
		  	                
		  	                (* Print["Simple linear bridging..."]; *)
		  	                begin = Max[left - 0, 1];
		  	                end   = Min[right + 0, listlength];
		  	                FunOrder = 1;
		  	                 ];
		  	                 
		  	                tholes = Join[ Range[begin, left, 1], Range[right, end, 1] ];
		  	               
                            (*tholesRescaled = Rescale[tholes];*)
                            		  	               
		  	                holes = Join[ modlist[[begin;;left]], modlist[[right;;end]] ]; 
		  	                
		  	                Xholes = holes[[All, 1]]; 
		  	                Yholes = holes[[All, 2]]; 
		  	                Zholes = holes[[All, 3]]; 
		  	               
		  	                
		  	                fx = Interpolation[ Thread[ List[tholes, Xholes] ], InterpolationOrder->FunOrder ];
		  	                fy = Interpolation[ Thread[ List[tholes, Yholes] ], InterpolationOrder->FunOrder ];
		  	                fz = Interpolation[ Thread[ List[tholes, Zholes] ], InterpolationOrder->FunOrder ];
		  	                
		  	               
		  	               bridge = Table[{fx[t], fy[t], fz[t]}, {t, left+1, right-1}];
		  	               
		  	               (*bridge = Table[BSplineFunction[holes, SplineDegree->FunOrder][u], {u, tholesRescaled}];*)
		  	               
		  	                (* vedere anche le BsplineFunction *)
		  	               
		  	               (*modlist[[left+1 ;; right-1]] = Sequence@@bridge;*)
		  	               
		  	               modlist[[left+1 ;; right-1]] = bridge;
		  	               
		  	                                 
		  	             
		    ];
		
		   ];
		   
		   Return[modlist]; 
		
	];	
	
RepairData[]:=
	Module[{},
		
		CoordsXYZs = Table[ Prepend[ BridgeList[ XYZs[[i, 2;;]] ], XYZs[[i, 1]] ], {i, 1, Nrows} ];
		
	];
	
SmoothData[samples_, futureshift_]:=
	Module[{},
		
		SmoothedCoordsXYZs = Table[ Prepend[ MovingAverageFilter[ CoordsXYZs[[i, 2;;]], samples, futureshift ], XYZs[[i, 1]] ], {i, 1, Nrows} ]; 
		
	];		
	
OptimalRigidPose[XT_, YT_]:=
	Module[{X, Y, xbar, ybar, Xtilde, Ytilde,
		    Co, 
		    Ropt, Qopt, U, V, Sigma, NewSigma, dopt},
		
		(* 
		   XT are the local coordinates  of points P_i, i.e. in the cad model 
		   YT are the global coordinates of points P_i, i.e. as measured by the Phase Space
		   they are expected to be organized as XT = { {x1, y1, z1}, {x2, y2, z2}, {x3, y3, z3} } etc.
		 *)
		X = Transpose[XT];
		Y = Transpose[YT];
		
		xbar = Mean[XT];
		ybar = Mean[YT];
		
		Xtilde = X - xbar;
		Ytilde = Y - ybar;
		
		Co = Ytilde.Transpose[Xtilde];

		(*Ropt = Co.MatrixInverseSqrt[Transpose[Co].Co];*)
		
		{U, Sigma, V} = SingularValueDecomposition[Co];
		
		NewSigma = {
			        {1, 0, 0                  },
			        {0, 1, 0                  },
			        {0, 0, Det[U.Transpose[V]]}
			        };

		Ropt = U.NewSigma.Transpose[V];		
		dopt = ybar - Ropt.xbar;

		
		Return[{Ropt, dopt}];
		
	];
	
MatrixSqrt[mat_]:=
	Module[{vals, vecs, sqrt},
		
		{vals, vecs} = Eigensystem[N[mat]];
		
		sqrt = Transpose[vecs].DiagonalMatrix[Sqrt[vals]].vecs;
		
		Return[sqrt];
		
	];		
	
MatrixInverseSqrt[mat_]:=
	Module[{vals, vecs, invsqrt},
		
		{vals, vecs} = Eigensystem[N[mat]];
		
		invsqrt = Transpose[vecs].DiagonalMatrix[1/Sqrt[vals]].vecs;
		
		Return[invsqrt];
		
	];			


	
FadingList[listXYZ_, span_]:=
	Module[{length, init},
		
		length = Length[listXYZ];
		
		If[ length - span > 1, 
			
			init = length - span,
			init = 1];
			
		Return[ listXYZ[[init;;]] ];	
		
	];	
	
MovingAverageFilter[listXYZ_, samples_, futureshift_]:=
	Module[{length, avglist, i, start, end},
		
		length = Length[listXYZ];
		
		(* nota bene: futureshift deve essere <= samples - 1 *)
		
		avglist = {};
		
		For[i=1, i<=length, i++,
		
		    start = i + futureshift - samples + 1;
		    end = i + futureshift;
		    
		    If[ start < 1, start=1;, start = i + futureshift - samples + 1; ];
		    If[ end<= length, end = i + futureshift;, end=length];
		    
		    avglist = Append[ avglist, Mean[ listXYZ[[start;;end]] ] ];
		    
		   (* If[ start < 1,
		    	
		    	avglist = Append[ avglist, Mean[ listXYZ[[1;;i]] ] ];,
		    	
		    	avglist = Append[ avglist, Mean[ listXYZ[[start;;i]] ] ];
		    	
		      ];
		    *)
		
		   ];
		   
		   Return[avglist]; 
		
	];	
	
NestedMovingAverageFilter[list_, samples_, futureshift_, loops_]:=
	Module[{filter},
		
		filter = Nest[MovingAverageFilter[#, samples, futureshift]&, list, loops];
		
		Return[filter];
	];		

MovingLeastSquaresSmoothing[x_, basis_, weightfun_, listx_, listu_]:=
	Module[{basisAtx, P, M, B, A, res},
		
		basisAtx = basis[x];
		
		P = Map[basis[#]&, listx];
		
		M = DiagonalMatrix[weightfun[x, #]& /@ listx];
		
		B = Transpose[P].M;
		
		A = B.P;
		
		res = basisAtx.PseudoInverse[A].B.listu;
		
		Return[res];
		
	];	
				

MovingAverageSmoothing[listx_, listu_, span_]:=
	Module[{initL, ma, finalL, a, b, finalListx, finalListu},
		
 		initL  = Length@listu;
 		ma 	   = MovingAverage[listu, span];
		finalL = Length@ma;
		
		a = First[listx];
		b = Last[listx];
		
		finalListx = Range[a, b, (b-a)/(finalL - 1)]; 
		finalListu = ma;
		
		Return[Transpose[{finalListx, finalListu}]]; 
		
	];
	
CenteredMovingAverageFilter[list_, span_]:=
	Module[{initLength, leftzeros, rightzeros, leftvalues, rightvalues, extendedlist, finalLength, filter},
		
		initLength = Length@listu; (* compute the list length *)
		
		leftzeros  = 0. Range[Floor[  (span-1)/2 ]];
		rightzeros = 0. Range[Ceiling[(span-1)/2 ]];
		
		(*
		leftvalues = Table[ First[list], {Floor  [(span-1) ]}];
		rightvalues = Table[ Last[list], {Ceiling[(span-1) ]}];
		*)
		
		(* extendedlist = Join[leftvalues, list, rightvalues]; *)
		
		extendedlist = Join[leftzeros, list, rightzeros];
		
		(* finalLength = Length@extendedlist; *)
		
		(* filter = Map[(1/span)*Apply[Plus,#]&, Partition[extendedlist, span, 1]]; *)
		
		filter = MovingAverage[extendedlist, span];
		
		Return[filter];
	];
	
RightMovingAverageFilter[list_, span_]:=
	Module[{initLength, leftzeros, rightzeros, extendedlist, finalLength, filter},
		
		initLength = Length@listu; (* compute the list length *)
		
		rightzeros = 0. Range[Ceiling[(span-1)/2 ]];
		
		(* extendedlist = Join[list, rightzeros]; *)
		
		  filter = Join[list[[1;;span-1]], MovingAverage[list,span] ];
		
		(*finalLength = Length@extendedlist;
		
		filter = Map[(1/span)*Apply[Plus,#]&, Partition[extendedlist, span, 1]];
		*)
		
		Return[filter];
	];	
	
NestedCenteredMovingAverageFilter[list_, span_, loops_]:=
	Module[{filter},
		
		filter = Nest[CenteredMovingAverageFilter[#, span]&, list, loops];
		
		Return[filter];
	];	
	
NestedRightMovingAverageFilter[list_, span_, loops_]:=
	Module[{filter},
		
		filter = Nest[RightMovingAverageFilter[#, span]&, list, loops];
		
		Return[filter];
	];	
	
AdaptiveMovingAverageFilter[list_, span_, order_, min_, max_]:=
	Module[{subsets, volatility, direction, qqd, ldd, halfspan, lqq, qqdsm,
		    ERn, ler, listlong, kn, base, ris1, lris, ris},
		
		subsets    = Partition[list, span, 1];
		volatility = Map[Total[Abs[Differences[#, order]]]&, subsets];
		direction  = Map[Max[Sqrt[(Accumulate[Differences[#, order]])^2]] &, subsets];
		
		qqd = direction/volatility;
		
		ldd      = Length[list];
		halfspan = Round[span/2];
		lqq      = Length[qqd];
		
		qqdsm    = Sin[Pi/2 (MovingAverage[PadLeft[qqd, lqq + halfspan], 3 halfspan])]^2;

        ERn = Round[(qqdsm (min - max) + max)/2];
        ler = Length[ERn];
      
        listlong = PadLeft[list, ldd + max, list[[1]] ];
        listlong = PadRight[listlong, ldd + 2 max, list[[ldd]] ];
 
        base = Table[ Take[listlong, {kn - ERn[[kn - halfspan + 1]] + max, kn + ERn[[kn - halfspan + 1]] + max}], {kn, halfspan, ler + halfspan - 1}];
  
        ris1 = Flatten[Map[Mean[#] &, base, {1}]];
        ris  = PadRight[ PadLeft[ris1, lris = Length[base] + halfspan - 1, list[[1 ;; halfspan]] ], ldd, list[[ldd - halfspan ;; ldd]]];
        
        Return[ris];
		
	];	

	
(* End[]; *)

EndPackage[];
