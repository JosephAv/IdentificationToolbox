(* ::Package:: *)

(* ::Section:: *)
(*Incipit*)


BeginPackage["UsefullStuffs`"]
Needs["ScrewCalculusPro`"]

PositionSimulation::usage = "";
PositionSimulation2::usage = "";
CreateDynamicQ::usage = "";
CreateDynamicQNum::usage = "";
CreateQIndex::usage = "";
CreateNumericParameterVector::usage = "";
CreateParameterVector::usage = "";
CreateNumericMarkerVector::usage = "";
CreateMarkerVector::usage = "";
DefineSettingIndexNames::usage = "";
DefineMarkerIndexNames::usage = "";
FreeXP::usage = "";
FreeXM::usage = "";
Assign::usage = "";
UpdateParameters::usage = "";
Update\[Rho]\[Phi]\[Delta]::usage = "";
UpdateMarkers::usage = "";
MultiplePostureResidualWithAll::usage = "";
MultiplePostureObjectiveFunctionWithAll::usage = "";
UpdateDynamicQ::usage = "";
FreeDynamicQ::usage = "";
SinglePostureResidual::usage = "";
XYZsModel::usage = "";
AnglesFromZ::usage= "";
XYZsJacobian::usage= "";
XYZsReducedJacobian::usage= "";
ExpandToTriplets::usage= "";
JacobianAnglesFromZ::usage= "";
ResidualJacobianConstrained::usage= "";
ResidualWithPriorsGradientConstrained::usage= "";
ResidualWithPriorsHessianConstrained::usage= "";
SinglePostureObjectiveFunctionConstrained::usage= "";
SinglePostureResidualConstrained::usage= "";
IdentifySinglePostureConstrainedZ::usage= "";
SinglePostureObjectiveFunctionWithPriorConstrained::usage= "";
IdentifySinglePostureEKFConstrained::usage= "";
ResidualWithPriorsHessian::usage= "";
IdentifyManyPosturesEKFConstrained::usage= "";
IdentifyMultiplePostureWithAllConstrained::usage= "";
XYZsRotation::usage= "";


(* ::Section:: *)
(*PositionSimulation & PositionSimulation2*)


Begin["`Private`"]
PositionSimulation[gWorldHMK1_,gWorldHMK2_,gWorldHMK3_,gWorldHMK4_,gWorldFMK1_,gWorldFMK2_,gWorldFMK3_,gWorldFMK4_,gWorldAMK1_,
gWorldAMK2_,gWorldAMK3_,gWorldAMK4_,gWorldRMK1_,gWorldRMK2_,gWorldRMK3_,gWorldRMK4_,v_]:=
Module[{p1},

HMK1 = gWorldHMK1[v[[1]],v[[2]],v[[3]],v[[4]],v[[5]],v[[6]],v[[7]]];
HMK2 = gWorldHMK2[v[[1]],v[[2]],v[[3]],v[[4]],v[[5]],v[[6]],v[[7]]];
HMK3 = gWorldHMK3[v[[1]],v[[2]],v[[3]],v[[4]],v[[5]],v[[6]],v[[7]]];
HMK4 = gWorldHMK4[v[[1]],v[[2]],v[[3]],v[[4]],v[[5]],v[[6]],v[[7]]];
FMK1 = gWorldFMK1[v[[1]],v[[2]],v[[3]],v[[4]],v[[5]]];
FMK2 = gWorldFMK2[v[[1]],v[[2]],v[[3]],v[[4]],v[[5]]];
FMK3 = gWorldFMK3[v[[1]],v[[2]],v[[3]],v[[4]],v[[5]]];
FMK4 = gWorldFMK4[v[[1]],v[[2]],v[[3]],v[[4]],v[[5]]];
AMK1 = gWorldAMK1[v[[1]],v[[2]],v[[3]]];
AMK2 = gWorldAMK2[v[[1]],v[[2]],v[[3]]];
AMK3 = gWorldAMK3[v[[1]],v[[2]],v[[3]]];
AMK4 = gWorldAMK4[v[[1]],v[[2]],v[[3]]];
RMK1 = gWorldRMK1;
RMK2 = gWorldRMK2;
RMK3 = gWorldRMK3;
RMK4 = gWorldRMK4;
pHMK1 = {HMK1[[1]][[4]], HMK1[[2]][[4]], HMK1[[3]][[4]]};
pHMK2 = {HMK2[[1]][[4]], HMK2[[2]][[4]], HMK2[[3]][[4]]};
pHMK3 = {HMK3[[1]][[4]], HMK3[[2]][[4]], HMK3[[3]][[4]]};
pHMK4 = {HMK4[[1]][[4]], HMK4[[2]][[4]], HMK4[[3]][[4]]};
pFMK1 = {FMK1[[1]][[4]], FMK1[[2]][[4]], FMK1[[3]][[4]]};
pFMK2 = {FMK2[[1]][[4]], FMK2[[2]][[4]], FMK2[[3]][[4]]};
pFMK3 = {FMK3[[1]][[4]], FMK3[[2]][[4]], FMK3[[3]][[4]]};
pFMK4 = {FMK4[[1]][[4]], FMK4[[2]][[4]], FMK4[[3]][[4]]};
pAMK1 = {AMK1[[1]][[4]], AMK1[[2]][[4]], AMK1[[3]][[4]]};
pAMK2 = {AMK2[[1]][[4]], AMK2[[2]][[4]], AMK2[[3]][[4]]};
pAMK3 = {AMK3[[1]][[4]], AMK3[[2]][[4]], AMK3[[3]][[4]]};
pAMK4 = {AMK4[[1]][[4]], AMK4[[2]][[4]], AMK4[[3]][[4]]};
pRMK1 = {RMK1[[1]][[4]], RMK1[[2]][[4]], RMK1[[3]][[4]]};
pRMK2 = {RMK2[[1]][[4]], RMK2[[2]][[4]], RMK2[[3]][[4]]};
pRMK3 = {RMK3[[1]][[4]], RMK3[[2]][[4]], RMK3[[3]][[4]]};
pRMK4 = {RMK4[[1]][[4]], RMK4[[2]][[4]], RMK4[[3]][[4]]};
vect = {pRMK1,pRMK2,pRMK3,pRMK4,pAMK1,pAMK2,pAMK3,pAMK4,pFMK1,pFMK2,pFMK3,pFMK4,pHMK1,pHMK2,pHMK3,pHMK4};
Return[vect];

];
End[]



Begin["`Private`"]
PositionSimulation2[gWorldEE_,gWorldW2_,gWorldW1_,gWorldB2_,gWorldE2_,gWorldE1_,gWorldB1_,gWorldS3_,gWorldS2_,gWorldS1_,v_]:=
Module[{p1},

mEE = gWorldEE[v[[1]],v[[2]],v[[3]],v[[4]],v[[5]],v[[6]],v[[7]]];
mW2 = gWorldW2[v[[1]],v[[2]],v[[3]],v[[4]],v[[5]],v[[6]],v[[7]]];
mW1 = gWorldW1[v[[1]],v[[2]],v[[3]],v[[4]],v[[5]],v[[6]]];
mB2 = gWorldB2[v[[1]],v[[2]],v[[3]],v[[4]],v[[5]]];
mE2 = gWorldE2[v[[1]],v[[2]],v[[3]],v[[4]],v[[5]]];
mE1 = gWorldE1[v[[1]],v[[2]],v[[3]],v[[4]]];
mB1 = gWorldB1[v[[1]],v[[2]],v[[3]]];
mS3 = gWorldS3[v[[1]],v[[2]],v[[3]]];
mS2 = gWorldS2[v[[1]],v[[2]]];
mS1 = gWorldS1[v[[1]]];

pEE = {mEE[[1]][[4]], mEE[[2]][[4]], mEE[[3]][[4]]};
pW2 = {mW2[[1]][[4]], mW2[[2]][[4]], mW2[[3]][[4]]};
pW1 = {mW1[[1]][[4]], mW1[[2]][[4]], mW1[[3]][[4]]};
pB2 = {mB2[[1]][[4]], mB2[[2]][[4]], mB2[[3]][[4]]};
pE2 = {mE2[[1]][[4]], mE2[[2]][[4]], mE2[[3]][[4]]};
pE1 = {mE1[[1]][[4]], mE1[[2]][[4]], mE1[[3]][[4]]};
pB1 = {mB1[[1]][[4]], mB1[[2]][[4]], mB1[[3]][[4]]};
pS3 = {mS3[[1]][[4]], mS3[[2]][[4]], mS3[[3]][[4]]};
pS2 = {mS2[[1]][[4]], mS2[[2]][[4]], mS2[[3]][[4]]};
pS1 = {mS1[[1]][[4]], mS1[[2]][[4]], mS1[[3]][[4]]};

vect2 = {pS1,pS2,pS3,pB1,pE1,pE2,pB2,pW1,pW2,pEE};
Return[vect2];

];
End[]



(* ::Section:: *)
(*CreateDynamicQ & CreateDynamicQNum & CreateQIndex*)


CreateDynamicQ[Nframes_]:=
Module[{AllFramesQs, jay0},

        Clear["Xq*"];

	    AllFramesQs = Table[
		ToExpression/@{
		StringJoin["Xqs1f", ToString[jay0]],
		StringJoin["Xqs2f", ToString[jay0]],
		StringJoin["Xqs3f", ToString[jay0]],
		StringJoin["Xqe1f", ToString[jay0]],
		StringJoin["Xqe2f", ToString[jay0]],
		StringJoin["Xqw1f", ToString[jay0]],
		StringJoin["Xqw2f", ToString[jay0]]
		},

	    {jay0, Nframes} ];

	DynQ = AllFramesQs;
 
	Return[DynQ];
]

CreateDynamicQNum[Nframes_]:=
Module[{AllFramesQs, jay},

	AllFramesQs = Table[
		
		ToExpression/@{
		StringJoin["qs1f0", ToString[jay]],
		StringJoin["qs2f0", ToString[jay]],
		StringJoin["qs3f0", ToString[jay]],
		StringJoin["qe1f0", ToString[jay]],
		StringJoin["qe2f0", ToString[jay]],
		StringJoin["qw1f0", ToString[jay]],
		StringJoin["qw2f0", ToString[jay]]
		},

	    {jay, Nframes}];

	DynQNum = AllFramesQs;
 
	Return[DynQNum];
]

CreateQIndex[]:=
Module[{},

    Clear["iq*"];

	iDynQ = {
		    iqs1,
			iqs2,
			iqs3,
			iqe1,
			iqe2,
			iqw1,
			iqw2};
			
		(* iDynQ = iDynQ[[indToKeep]]; *)
 
	        MapThread[ Set, {iDynQ, Range[ Length[iDynQ] ]} ];
	
 			Return[iDynQ];
]


(* ::Section:: *)
(*CreateNumericParameterVector*)


CreateNumericParameterVector[]:=
	Module[{},
		XPNum =
{
(*** GEOMETRIC PARAMETERS ***)
(* World -> S1 *)
(* 1 *)        dxWorldS10,
(* 2 *)		dyWorldS10,
(* 3 *)		dzWorldS10,
(* 4 *)		alphaWorldS10,
(* 5 *)		betaWorldS10,
(* 6 *)		gammaWorldS10,
(* S1 -> S2 *)
(* 1 *)        dxS1S20,
(* 2 *)		dyS1S20,
(* 3 *)		dzS1S20,
(* 4 *)		alphaS1S20,
(* 5 *)		betaS1S20,
(* 6 *)		gammaS1S20,
(* S2 -> S3 *)
(* 1 *)        dxS2S30,
(* 2 *)		dyS2S30,
(* 3 *)		dzS2S30,
(* 4 *)		alphaS2S30,
(* 5 *)		betaS2S30,
(* 6 *)		gammaS2S30,
(* S3 -> B1 *)
(* 1 *)        dxS3B10,
(* 2 *)		dyS3B10,
(* 3 *)		dzS3B10,
(* 4 *)		alphaS3B10,
(* 5 *)		betaS3B10,
(* 6 *)		gammaS3B10,
(* B1 -> E1 *)
(* 1 *)        dxB1E10,
(* 2 *)		dyB1E10,
(* 3 *)		dzB1E10,
(* 4 *)		alphaB1E10,
(* 5 *)		betaB1E10,
(* 6 *)		gammaB1E10,
(* E1 -> E2*)
(* 1 *)        dxE1E20,
(* 2 *)		dyE1E20,
(* 3 *)		dzE1E20,
(* 4 *)		alphaE1E20,
(* 5 *)		betaE1E20,
(* 6 *)		gammaE1E20,
(* E2 -> B2 *)
(* 1 *)        dxE2B20,
(* 2 *)		dyE2B20,
(* 3 *)		dzE2B20,
(* 4 *)		alphaE2B20,
(* 5 *)		betaE2B20,
(* 6 *)		gammaE2B20,
(* B2 -> W1 *)
(* 1 *)        dxB2W10,
(* 2 *)		dyB2W10,
(* 3 *)		dzB2W10,
(* 4 *)		alphaB2W10,
(* 5 *)		betaB2W10,
(* 6 *)		gammaB2W10,
(* W1 -> W2 *)
(* 1 *)        dxW1W20,
(* 2 *)		dyW1W20,
(* 3 *)		dzW1W20,
(* 4 *)		alphaW1W20,
(* 5 *)		betaW1W20,
(* 6 *)		gammaW1W20,
(* W2 -> EE *)
(* 1 *)        dxW2EE0,
(* 2 *)		dyW2EE0,
(* 3 *)		dzW2EE0,
(* 4 *)		alphaW2EE0,
(* 5 *)		betaW2EE0,
(* 6 *)		gammaW2EE0
};

	    Return[XPNum];
		
];


(* ::Section:: *)
(*CreateParameterVector & FreeXP*)


CreateParameterVector[]:=
	Module[{},
		XP =
{
(*** GEOMETRIC PARAMETERS ***)
(* World -> S1 *)
(* 1 *)        XdxWorldS1,
(* 2 *)		XdyWorldS1,
(* 3 *)		XdzWorldS1,
(* 4 *)		XalphaWorldS1,
(* 5 *)		XbetaWorldS1,
(* 6 *)		XgammaWorldS1,
(* S1 -> S2 *)
(* 1 *)        XdxS1S2,
(* 2 *)		XdyS1S2,
(* 3 *)		XdzS1S2,
(* 4 *)		XalphaS1S2,
(* 5 *)		XbetaS1S2,
(* 6 *)		XgammaS1S2,
(* S2 -> S3 *)
(* 1 *)        XdxS2S3,
(* 2 *)		XdyS2S3,
(* 3 *)		XdzS2S3,
(* 4 *)		XalphaS2S3,
(* 5 *)		XbetaS2S3,
(* 6 *)		XgammaS2S3,
(* S3 -> B1 *)
(* 1 *)        XdxS3B1,
(* 2 *)		XdyS3B1,
(* 3 *)		XdzS3B1,
(* 4 *)		XalphaS3B1,
(* 5 *)		XbetaS3B1,
(* 6 *)		XgammaS3B1,
(* B1 -> E1 *)
(* 1 *)        XdxB1E1,
(* 2 *)		XdyB1E1,
(* 3 *)		XdzB1E1,
(* 4 *)		XalphaB1E1,
(* 5 *)		XbetaB1E1,
(* 6 *)		XgammaB1E1,
(* E1 -> E2*)
(* 1 *)        XdxE1E2,
(* 2 *)		XdyE1E2,
(* 3 *)		XdzE1E2,
(* 4 *)		XalphaE1E2,
(* 5 *)		XbetaE1E2,
(* 6 *)		XgammaE1E2,
(* E2 -> B2 *)
(* 1 *)        XdxE2B2,
(* 2 *)		XdyE2B2,
(* 3 *)		XdzE2B2,
(* 4 *)		XalphaE2B2,
(* 5 *)		XbetaE2B2,
(* 6 *)		XgammaE2B2,
(* B2 -> W1 *)
(* 1 *)        XdxB2W1,
(* 2 *)		XdyB2W1,
(* 3 *)		XdzB2W1,
(* 4 *)		XalphaB2W1,
(* 5 *)		XbetaB2W1,
(* 6 *)		XgammaB2W1,
(* W1 -> W2 *)
(* 1 *)        XdxW1W2,
(* 2 *)		XdyW1W2,
(* 3 *)		XdzW1W2,
(* 4 *)		XalphaW1W2,
(* 5 *)		XbetaW1W2,
(* 6 *)		XgammaW1W2,
(* W2 -> EE *)
(* 1 *)        XdxW2EE,
(* 2 *)		XdyW2EE,
(* 3 *)		XdzW2EE,
(* 4 *)		XalphaW2EE,
(* 5 *)		XbetaW2EE,
(* 6 *)		XgammaW2EE
};
	    
	    Return[XP];
		
	];

(* CLEAR XP FROM THE NUMERIC VALUES *)

FreeXP[]:=
	Module[{},
		
		Clear[
(*** GEOMETRIC PARAMETERS ***)
(* World -> S1 *)
(* 1 *)        XdxWorldS1,
(* 2 *)		XdyWorldS1,
(* 3 *)		XdzWorldS1,
(* 4 *)		XalphaWorldS1,
(* 5 *)		XbetaWorldS1,
(* 6 *)		XgammaWorldS1,
(* S1 -> S2 *)
(* 1 *)        XdxS1S2,
(* 2 *)		XdyS1S2,
(* 3 *)		XdzS1S2,
(* 4 *)		XalphaS1S2,
(* 5 *)		XbetaS1S2,
(* 6 *)		XgammaS1S2,
(* S2 -> S3 *)
(* 1 *)        XdxS2S3,
(* 2 *)		XdyS2S3,
(* 3 *)		XdzS2S3,
(* 4 *)		XalphaS2S3,
(* 5 *)		XbetaS2S3,
(* 6 *)		XgammaS2S3,
(* S3 -> B1 *)
(* 1 *)        XdxS3B1,
(* 2 *)		XdyS3B1,
(* 3 *)		XdzS3B1,
(* 4 *)		XalphaS3B1,
(* 5 *)		XbetaS3B1,
(* 6 *)		XgammaS3B1,
(* B1 -> E1 *)
(* 1 *)        XdxB1E1,
(* 2 *)		XdyB1E1,
(* 3 *)		XdzB1E1,
(* 4 *)		XalphaB1E1,
(* 5 *)		XbetaB1E1,
(* 6 *)		XgammaB1E1,
(* E1 -> E2*)
(* 1 *)        XdxE1E2,
(* 2 *)		XdyE1E2,
(* 3 *)		XdzE1E2,
(* 4 *)		XalphaE1E2,
(* 5 *)		XbetaE1E2,
(* 6 *)		XgammaE1E2,
(* E2 -> B2 *)
(* 1 *)        XdxE2B2,
(* 2 *)		XdyE2B2,
(* 3 *)		XdzE2B2,
(* 4 *)		XalphaE2B2,
(* 5 *)		XbetaE2B2,
(* 6 *)		XgammaE2B2,
(* B2 -> W1 *)
(* 1 *)        XdxB2W1,
(* 2 *)		XdyB2W1,
(* 3 *)		XdzB2W1,
(* 4 *)		XalphaB2W1,
(* 5 *)		XbetaB2W1,
(* 6 *)		XgammaB2W1,
(* W1 -> W2 *)
(* 1 *)        XdxW1W2,
(* 2 *)		XdyW1W2,
(* 3 *)		XdzW1W2,
(* 4 *)		XalphaW1W2,
(* 5 *)		XbetaW1W2,
(* 6 *)		XgammaW1W2,
(* W2 -> EE *)
(* 1 *)        XdxW2EE,
(* 2 *)		XdyW2EE,
(* 3 *)		XdzW2EE,
(* 4 *)		XalphaW2EE,
(* 5 *)		XbetaW2EE,
(* 6 *)		XgammaW2EE
];

CreateParameterVector[];
	    
	    Return[XP];
		
	];



(* ::Section:: *)
(*CreateNumericMarkerVector*)


CreateNumericMarkerVector[]:=
	Module[{},
(* Numeric Marker Vector *)
XMNum = {

		(* Reference = stella sul torace *)
			
			(* MK1 *)
			alphaWorldRMK1,
			betaWorldRMK1,
			gammaWorldRMK1,
			dxWorldRMK1,
			dyWorldRMK1,
			dzWorldRMK1,
			
			(* MK2 *)
			alphaWorldRMK2,
			betaWorldRMK2,
			gammaWorldRMK2,
			dxWorldRMK2,
			dyWorldRMK2,
			dzWorldRMK2,

		    (* MK3 *)
			alphaWorldRMK3,
			betaWorldRMK3,
			gammaWorldRMK3,
			dxWorldRMK3,
			dyWorldRMK3,
			dzWorldRMK3,

			(* MK4 *)
			alphaWorldRMK4,
			betaWorldRMK4,
			gammaWorldRMK4,
			dxWorldRMK4,
			dyWorldRMK4,
			dzWorldRMK4,
			
			(* Arm = stella sul braccio *)
			
			(* MK1 *)
			alphaB1AMK1,
			betaB1AMK1,
			gammaB1AMK1,
			dxB1AMK1,
			dyB1AMK1,
			dzB1AMK1,
			
			(* MK2 *)
			alphaB1AMK2,
			betaB1AMK2,
			gammaB1AMK2,
			dxB1AMK2,
			dyB1AMK2,
			dzB1AMK2,

			(* MK3 *)
			alphaB1AMK3,
			betaB1AMK3,
			gammaB1AMK3,
			dxB1AMK3,
			dyB1AMK3,
			dzB1AMK3,

			(* MK4 *)
			alphaB1AMK4,
			betaB1AMK4,
			gammaB1AMK4,
			dxB1AMK4,
			dyB1AMK4,
			dzB1AMK4,

			
			(* Forearm = stella sull'avambraccio *)
			
			(* MK1 *)
			alphaB2FMK1,
			betaB2FMK1,
			gammaB2FMK1,
			dxB2FMK1,
			dyB2FMK1,
			dzB2FMK1,
			
			(* MK2 *)
			alphaB2FMK2,
			betaB2FMK2,
			gammaB2FMK2,
			dxB2FMK2,
			dyB2FMK2,
			dzB2FMK2,

			(* MK3 *)
			alphaB2FMK3,
			betaB2FMK3,
			gammaB2FMK3,
			dxB2FMK3,
			dyB2FMK3,
			dzB2FMK3,

			(* MK4 *)
			alphaB2FMK4,
			betaB2FMK4,
			gammaB2FMK4,
			dxB2FMK4,
			dyB2FMK4,
			dzB2FMK4,
		
		 (* Hand = stella sulla mano *)
			
			(* MK1 *)
			alphaEEHMK1,
			betaEEHMK1,
			gammaEEHMK1,
			dxEEHMK1,
			dyEEHMK1,
			dzEEHMK1,
			
			(* MK2 *)
			alphaEEHMK2,
			betaEEHMK2,
			gammaEEHMK2,
			dxEEHMK2,
			dyEEHMK2,
			dzEEHMK2,

			(* MK3 *)
			alphaEEHMK3,
			betaEEHMK3,
			gammaEEHMK3,
			dxEEHMK3,
			dyEEHMK3,
			dzEEHMK3,

			(* MK4 *)
			alphaEEHMK4,
			betaEEHMK4,
			gammaEEHMK4,
			dxEEHMK4,
			dyEEHMK4,
			dzEEHMK4
};
		
		
Return[XMNum];
];



(* ::Section:: *)
(*CreateMarkerVector & FreeXM*)


CreateMarkerVector[]:=
	Module[{},
(* Symbolic Marker Vector *)
XM = {
			
		(* Reference = stella sul torace *)
			
			(* MK1 *)
			XalphaWorldRMK1,
			XbetaWorldRMK1,
			XgammaWorldRMK1,
			XdxWorldRMK1,
			XdyWorldRMK1,
			XdzWorldRMK1,
			
			(* MK2 *)
			XalphaWorldRMK2,
			XbetaWorldRMK2,
			XgammaWorldRMK2,
			XdxWorldRMK2,
			XdyWorldRMK2,
			XdzWorldRMK2,

		    (* MK3 *)
			XalphaWorldRMK3,
			XbetaWorldRMK3,
			XgammaWorldRMK3,
			XdxWorldRMK3,
			XdyWorldRMK3,
			XdzWorldRMK3,

			(* MK4 *)
			XalphaWorldRMK4,
			XbetaWorldRMK4,
			XgammaWorldRMK4,
			XdxWorldRMK4,
			XdyWorldRMK4,
			XdzWorldRMK4,
			
			(* Arm = stella sul braccio *)
			
			(* MK1 *)
			XalphaB1AMK1,
			XbetaB1AMK1,
			XgammaB1AMK1,
			XdxB1AMK1,
			XdyB1AMK1,
			XdzB1AMK1,
			
			(* MK2 *)
			XalphaB1AMK2,
			XbetaB1AMK2,
			XgammaB1AMK2,
			XdxB1AMK2,
			XdyB1AMK2,
			XdzB1AMK2,

			(* MK3 *)
			XalphaB1AMK3,
			XbetaB1AMK3,
			XgammaB1AMK3,
			XdxB1AMK3,
			XdyB1AMK3,
			XdzB1AMK3,

			(* MK4 *)
			XalphaB1AMK4,
			XbetaB1AMK4,
			XgammaB1AMK4,
			XdxB1AMK4,
			XdyB1AMK4,
			XdzB1AMK4,

			
			(* Forearm = stella sull'avambraccio *)
			
			(* MK1 *)
			XalphaB2FMK1,
			XbetaB2FMK1,
			XgammaB2FMK1,
			XdxB2FMK1,
			XdyB2FMK1,
			XdzB2FMK1,
			
			(* MK2 *)
			XalphaB2FMK2,
			XbetaB2FMK2,
			XgammaB2FMK2,
			XdxB2FMK2,
			XdyB2FMK2,
			XdzB2FMK2,

			(* MK3 *)
			XalphaB2FMK3,
			XbetaB2FMK3,
			XgammaB2FMK3,
			XdxB2FMK3,
			XdyB2FMK3,
			XdzB2FMK3,

			(* MK4 *)
			XalphaB2FMK4,
			XbetaB2FMK4,
			XgammaB2FMK4,
			XdxB2FMK4,
			XdyB2FMK4,
			XdzB2FMK4,
		
		 (* Hand = stella sulla mano *)
			
			(* MK1 *)
			XalphaEEHMK1,
			XbetaEEHMK1,
			XgammaEEHMK1,
			XdxEEHMK1,
			XdyEEHMK1,
			XdzEEHMK1,
			
			(* MK2 *)
			XalphaEEHMK2,
			XbetaEEHMK2,
			XgammaEEHMK2,
			XdxEEHMK2,
			XdyEEHMK2,
			XdzEEHMK2,

			(* MK3 *)
			XalphaEEHMK3,
			XbetaEEHMK3,
			XgammaEEHMK3,
			XdxEEHMK3,
			XdyEEHMK3,
			XdzEEHMK3,

			(* MK4 *)
			XalphaEEHMK4,
			XbetaEEHMK4,
			XgammaEEHMK4,
			XdxEEHMK4,
			XdyEEHMK4,
			XdzEEHMK4
};
		
		
Return[XM];
];


FreeXM[]:=
	Module[{},
		
		Clear[
			
		(* Reference = stella sul torace *)
			
			(* MK1 *)
			XalphaWorldRMK1,
			XbetaWorldRMK1,
			XgammaWorldRMK1,
			XdxWorldRMK1,
			XdyWorldRMK1,
			XdzWorldRMK1,
			
			(* MK2 *)
			XalphaWorldRMK2,
			XbetaWorldRMK2,
			XgammaWorldRMK2,
			XdxWorldRMK2,
			XdyWorldRMK2,
			XdzWorldRMK2,

		    (* MK3 *)
			XalphaWorldRMK3,
			XbetaWorldRMK3,
			XgammaWorldRMK3,
			XdxWorldRMK3,
			XdyWorldRMK3,
			XdzWorldRMK3,

			(* MK4 *)
			XalphaWorldRMK4,
			XbetaWorldRMK4,
			XgammaWorldRMK4,
			XdxWorldRMK4,
			XdyWorldRMK4,
			XdzWorldRMK4,
			
			(* Arm = stella sul braccio *)
			
			(* MK1 *)
			XalphaB1AMK1,
			XbetaB1AMK1,
			XgammaB1AMK1,
			XdxB1AMK1,
			XdyB1AMK1,
			XdzB1AMK1,
			
			(* MK2 *)
			XalphaB1AMK2,
			XbetaB1AMK2,
			XgammaB1AMK2,
			XdxB1AMK2,
			XdyB1AMK2,
			XdzB1AMK2,

			(* MK3 *)
			XalphaB1AMK3,
			XbetaB1AMK3,
			XgammaB1AMK3,
			XdxB1AMK3,
			XdyB1AMK3,
			XdzB1AMK3,

			(* MK4 *)
			XalphaB1AMK4,
			XbetaB1AMK4,
			XgammaB1AMK4,
			XdxB1AMK4,
			XdyB1AMK4,
			XdzB1AMK4,

			
			(* Forearm = stella sull'avambraccio *)
			
			(* MK1 *)
			XalphaB2FMK1,
			XbetaB2FMK1,
			XgammaB2FMK1,
			XdxB2FMK1,
			XdyB2FMK1,
			XdzB2FMK1,
			
			(* MK2 *)
			XalphaB2FMK2,
			XbetaB2FMK2,
			XgammaB2FMK2,
			XdxB2FMK2,
			XdyB2FMK2,
			XdzB2FMK2,

			(* MK3 *)
			XalphaB2FMK3,
			XbetaB2FMK3,
			XgammaB2FMK3,
			XdxB2FMK3,
			XdyB2FMK3,
			XdzB2FMK3,

			(* MK4 *)
			XalphaB2FMK4,
			XbetaB2FMK4,
			XgammaB2FMK4,
			XdxB2FMK4,
			XdyB2FMK4,
			XdzB2FMK4,
		
		 (* Hand = stella sulla mano *)
			
			(* MK1 *)
			XalphaEEHMK1,
			XbetaEEHMK1,
			XgammaEEHMK1,
			XdxEEHMK1,
			XdyEEHMK1,
			XdzEEHMK1,
			
			(* MK2 *)
			XalphaEEHMK2,
			XbetaEEHMK2,
			XgammaEEHMK2,
			XdxEEHMK2,
			XdyEEHMK2,
			XdzEEHMK2,

			(* MK3 *)
			XalphaEEHMK3,
			XbetaEEHMK3,
			XgammaEEHMK3,
			XdxEEHMK3,
			XdyEEHMK3,
			XdzEEHMK3,

			(* MK4 *)
			XalphaEEHMK4,
			XbetaEEHMK4,
			XgammaEEHMK4,
			XdxEEHMK4,
			XdyEEHMK4,
			XdzEEHMK4
			
		];
		
		CreateMarkerVector[];
		
		Return[XM];
	];
	



(* ::Section:: *)
(*DefineSettingIndexNames & DefineMarkerIndexNames*)


DefineSettingIndexNames[]:=
	Module[{},
		
	     iXP = 
{
(* World -> S1 *)
(* 1 *)        idxWorldS1,
(* 2 *)		idyWorldS1,
(* 3 *)		idzWorldS1,
(* 4 *)		ialphaWorldS1,
(* 5 *)		ibetaWorldS1,
(* 6 *)		igammaWorldS1,
(* S1 -> S2 *)
(* 1 *)        idxS1S2,
(* 2 *)		idyS1S2,
(* 3 *)		idzS1S2,
(* 4 *)		ialphaS1S2,
(* 5 *)		ibetaS1S2,
(* 6 *)		igammaS1S2,
(* S2 -> S3 *)
(* 1 *)        idxS2S3,
(* 2 *)		idyS2S3,
(* 3 *)		idzS2S3,
(* 4 *)		ialphaS2S3,
(* 5 *)		ibetaS2S3,
(* 6 *)		igammaS2S3,
(* S3 -> B1 *)
(* 1 *)        idxS3B1,
(* 2 *)		idyS3B1,
(* 3 *)		idzS3B1,
(* 4 *)		ialphaS3B1,
(* 5 *)		ibetaS3B1,
(* 6 *)		igammaS3B1,
(* B1 -> E1 *)
(* 1 *)        idxB1E1,
(* 2 *)		idyB1E1,
(* 3 *)		idzB1E1,
(* 4 *)		ialphaB1E1,
(* 5 *)		ibetaB1E1,
(* 6 *)		igammaB1E1,
(* E1 -> E2*)
(* 1 *)        idxE1E2,
(* 2 *)		idyE1E2,
(* 3 *)		idzE1E2,
(* 4 *)		ialphaE1E2,
(* 5 *)		ibetaE1E2,
(* 6 *)		igammaE1E2,
(* E2 -> B2 *)
(* 1 *)        idxE2B2,
(* 2 *)		idyE2B2,
(* 3 *)		idzE2B2,
(* 4 *)		ialphaE2B2,
(* 5 *)		ibetaE2B2,
(* 6 *)		igammaE2B2,
(* B2 -> W1 *)
(* 1 *)        idxB2W1,
(* 2 *)		idyB2W1,
(* 3 *)		idzB2W1,
(* 4 *)		ialphaB2W1,
(* 5 *)		ibetaB2W1,
(* 6 *)		igammaB2W1,
(* W1 -> W2 *)
(* 1 *)        idxW1W2,
(* 2 *)		idyW1W2,
(* 3 *)		idzW1W2,
(* 4 *)		ialphaW1W2,
(* 5 *)		ibetaW1W2,
(* 6 *)		igammaW1W2,
(* W2 -> EE *)
(* 1 *)        idxW2EE,
(* 2 *)		idyW2EE,
(* 3 *)		idzW2EE,
(* 4 *)		ialphaW2EE,
(* 5 *)		ibetaW2EE,
(* 6 *)		igammaW2EE
};

 MapThread[ Set, {iXP, Range[ Length[iXP] ]} ];

Return[iXP];

];


DefineMarkerIndexNames[]:=
	Module[{},
		
iXM = {
			
		(* Reference = stella sul torace *)
			
			(* MK1 *)
			ialphaWorldRMK1,
			ibetaWorldRMK1,
			igammaWorldRMK1,
			idxWorldRMK1,
			idyWorldRMK1,
			idzWorldRMK1,
			
			(* MK2 *)
			ialphaWorldRMK2,
			ibetaWorldRMK2,
			igammaWorldRMK2,
			idxWorldRMK2,
			idyWorldRMK2,
			idzWorldRMK2,

		    (* MK3 *)
			ialphaWorldRMK3,
			ibetaWorldRMK3,
			igammaWorldRMK3,
			idxWorldRMK3,
			idyWorldRMK3,
			idzWorldRMK3,

		    (* MK4 *)
			ialphaWorldRMK4,
			ibetaWorldRMK4,
			igammaWorldRMK4,
			idxWorldRMK4,
			idyWorldRMK4,
			idzWorldRMK4,
			
			(* Arm = stella sul braccio *)
			
			(* MK1 *)
			ialphaB1AMK1,
			ibetaB1AMK1,
			igammaB1AMK1,
			idxB1AMK1,
			idyB1AMK1,
			idzB1AMK1,
			
			(* MK2 *)
			ialphaB1AMK2,
			ibetaB1AMK2,
			igammaB1AMK2,
			idxB1AMK2,
			idyB1AMK2,
			idzB1AMK2,

			(* MK3 *)
			ialphaB1AMK3,
			ibetaB1AMK3,
			igammaB1AMK3,
			idxB1AMK3,
			idyB1AMK3,
			idzB1AMK3,

			(* MK4 *)
			ialphaB1AMK4,
			ibetaB1AMK4,
			igammaB1AMK4,
			idxB1AMK4,
			idyB1AMK4,
			idzB1AMK4,

			
			(* Forearm = stella sull'avambraccio *)
			
			(* MK1 *)
			ialphaB2FMK1,
			ibetaB2FMK1,
			igammaB2FMK1,
			idxB2FMK1,
			idyB2FMK1,
			idzB2FMK1,
			
			(* MK2 *)
			ialphaB2FMK2,
			ibetaB2FMK2,
			igammaB2FMK2,
			idxB2FMK2,
			idyB2FMK2,
			idzB2FMK2,

			(* MK3 *)
			ialphaB2FMK3,
			ibetaB2FMK3,
			igammaB2FMK3,
			idxB2FMK3,
			idyB2FMK3,
			idzB2FMK3,

			(* MK4 *)
			ialphaB2FMK4,
			ibetaB2FMK4,
			igammaB2FMK4,
			idxB2FMK4,
			idyB2FMK4,
			idzB2FMK4,
		
		 (* Hand = stella sulla mano *)
			
			(* MK1 *)
			ialphaEEHMK1,
			ibetaEEHMK1,
			igammaEEHMK1,
			idxEEHMK1,
			idyEEHMK1,
			idzEEHMK1,
			
			(* MK2 *)
			ialphaEEHMK2,
			ibetaEEHMK2,
			igammaEEHMK2,
			idxEEHMK2,
			idyEEHMK2,
			idzEEHMK2,

			(* MK3 *)
			ialphaEEHMK3,
			ibetaEEHMK3,
			igammaEEHMK3,
			idxEEHMK3,
			idyEEHMK3,
			idzEEHMK3,

			(* MK4 *)
			ialphaEEHMK4,
			ibetaEEHMK4,
			igammaEEHMK4,
			idxEEHMK4,
			idyEEHMK4,
			idzEEHMK4
};
			
			MapThread[ Set, {iXM, Range[ Length[iXM] ]} ];

        Return[iXM];
		
	];	


(* ::Section:: *)
(*Assign*)


(* ASSIGN TO A VECTOR XP THE NUMERIC VALUES *)
Assign[XP_, XPNum_]:=
	Module[{},
		
		MapThread[Set, {XP, XPNum}];
		
		Return[XP];
	];


(* ::Section:: *)
(*XYZsModel*)


XYZsModel[
	{qs1_, qs2_, qs3_, qe1_, qe2_, qw1_, qw2_}]:=
	Module[{result},
	
result = {
	(* Braccio *)
	RigidPosition[gWorldAMK1[qs1, qs2, qs3]],
	RigidPosition[gWorldAMK2[qs1, qs2, qs3]],
	RigidPosition[gWorldAMK3[qs1, qs2, qs3]],
	RigidPosition[gWorldAMK4[qs1, qs2, qs3]],
    (* Avambraccio *)
	RigidPosition[gWorldFMK1[qs1, qs2, qs3, qe1, qe2]],
	RigidPosition[gWorldFMK2[qs1, qs2, qs3, qe1, qe2]],
	RigidPosition[gWorldFMK3[qs1, qs2, qs3, qe1, qe2]],
	RigidPosition[gWorldFMK4[qs1, qs2, qs3, qe1, qe2]],
	(* Mano *)
	RigidPosition[gWorldHMK1[qs1, qs2, qs3, qe1, qe2, qw1, qw2]],
	RigidPosition[gWorldHMK2[qs1, qs2, qs3, qe1, qe2, qw1, qw2]],
	RigidPosition[gWorldHMK3[qs1, qs2, qs3, qe1, qe2, qw1, qw2]],
	RigidPosition[gWorldHMK4[qs1, qs2, qs3, qe1, qe2, qw1, qw2]]
	
};

Return[result];
];



(* ::Section:: *)
(*XYZs Rotation*)


Begin["`Private`"]
XYZsRotation[filename_]:=
	Module[{data1, i, j, data, ROWS, M, COLS, M1, data2},
		
		data = filename;
		{ROWS, COLS} = Dimensions[data];

Print["Rotating XYZs matrix..."];   

		M = {{0,1,0},{-1,0,0},{0,0,1}};
		data1 = data;

		For[i = 1, i<=ROWS, i++,
			For[j = 2, j<=COLS, j++,
				If[data[[i,j]] == 0, data1[[i,j]] = 0];
				If[data[[i,j]] != {0,0,0} , data1[[i,j]] = M.data[[i,j]] ];
		    ];
		];

		M1 = {{1,0,0},{0,0,1},{0,-1,0}};
		data2 = data1;

		For[i = 1, i<=ROWS, i++,
			For[j = 2, j<=COLS, j++,
				If[data1[[i,j]] == 0, data2[[i,j]] = 0];
				If[data1[[i,j]] != {0,0,0} , data2[[i,j]] = M1.data1[[i,j]] ];
		    ];
		];

Print["Rotation complete"];		
Return[data2]
   
];
End[]


(* ::Section:: *)
(*MultiplePostureObjectiveFunctionWithAll*)


UpdateParameters[values_, pos_]:=
	Module[{},
		
		XPNum[[pos]] = values;
		FreeXP[];
		Assign[XP, XPNum];
		
		Return[XP];
		
	];

Update\[Rho]\[Phi]\[Delta][values_, pos_]:=
	Module[{},
		n\[Rho]1 = values[[1]];
		n\[Phi]1 = values[[2]];
		n\[Delta]1 = values[[3]];
		n\[Rho]2 = values[[4]];
		n\[Phi]2 = values[[5]];
		n\[Delta]2 = values[[6]];
		n\[Rho]3 = values[[7]];
		n\[Phi]3 = values[[8]];
		n\[Delta]3 = values[[9]];

		Clear[\[Rho]1,\[Phi]1,\[Delta]1,\[Rho]2,\[Phi]2,\[Delta]2,\[Rho]3,\[Phi]3,\[Delta]3];

		\[Rho]1 = n\[Rho]1;
		\[Phi]1 = n\[Phi]1;
		\[Delta]1 = n\[Delta]1;
		\[Rho]2 = n\[Rho]2;
		\[Phi]2 = n\[Phi]2;
		\[Delta]2 = n\[Delta]2;
		\[Rho]3 = n\[Rho]3;
		\[Phi]3 = n\[Phi]3;
		\[Delta]3 = n\[Delta]3;
		
		Return[{\[Rho]1,\[Phi]1,\[Delta]1,\[Rho]2,\[Phi]2,\[Delta]2,\[Rho]3,\[Phi]3,\[Delta]3}];
		
	];

FreeDynamicQ[nf_]:=
	Module[{},
		
	Clear["Xq*"];

    CreateDynamicQ[nf];
	    
	Return[DynQ];
		
	];

UpdateDynamicQ[nf_]:=
	Module[{},
		
		(*CreateDynamicQ[nf];*)
		FreeDynamicQ[nf];
		
		Assign[DynQ, DynQNum];
		
	];

SinglePostureResidual[MarkerCoords_, q_?VectorQ]:=
		Module[{MarkerPoints, MarkerIndices,
			   residual
			   },
(*Questa funzione calcola i residui in una certa postura.*)			
			MarkerPoints  = MarkerCoords[[1]];

			MarkerIndices = MarkerCoords[[2]];
			
			residual = Flatten[ MarkerPoints - XYZsModel[q][[MarkerIndices]] ]; (*vettore colonna lungo 36*)
			
			Return[residual];
			
		];



MultiplePostureResidualWithAll[TableMarkerCoords_, XX_?VectorQ, GeomPosx_?VectorQ, \[Rho]\[Phi]\[Delta]Posx_?VectorQ, qPosx_?VectorQ]:=
Module[{
	
	     iii, 
	     noFrames   = Length[TableMarkerCoords], 
	     noGeomParsToIdentify = Length[GeomPosx],
	     no\[Rho]\[Phi]\[Delta]ToIdentify = Length[\[Rho]\[Phi]\[Delta]Posx],
	     noQToIdentify = Length[qPosx],
	     endParametersIndex,
	     startIndex,
	     endIndex,
	     r = {},
	     res1
	    },

	    (* the first noGeomPars in XX are Geometric Parameters to be identified *)
	    UpdateParameters[ XX[[1 ;; noGeomParsToIdentify]], GeomPosx];

	    
	    (* the third noBMToIdentify in XX are the Bone Marker Parameters to be identified *)
	    Update\[Rho]\[Phi]\[Delta][ XX[[noGeomParsToIdentify+1 ;; noGeomParsToIdentify+no\[Rho]\[Phi]\[Delta]ToIdentify ]], \[Rho]\[Phi]\[Delta]Posx];
	    		
	   endParametersIndex = noGeomParsToIdentify+no\[Rho]\[Phi]\[Delta]ToIdentify; 		

	    For[iii = 1, iii <= noFrames, iii++,
	    	
	    	startIndex = (endParametersIndex) + (iii-1) noQToIdentify + 1;
	    	endIndex   = (endParametersIndex) + iii noQToIdentify;
	    	
			DynQNum[[iii]][[qPosx]] = XX[[ startIndex  ;; endIndex ]];
			
			(* condizione aggiuntiva *)
			
			(*Print[XX]*)
			Print[ XX[[ startIndex ;; endIndex ]] ]
			Print[" \n "]
			
			If[
				Length[qPosx]<7,
				DynQNum[[iii]][[Complement[qPosx,Range[7]]]] = 0*Range[Length[Complement[qPosx,Range[7]]]];
				(* else do nothing *)
			];
		];



	UpdateDynamicQ[noFrames]; 


	For [iii = 1, iii <= noFrames, iii++,

		

		AppendTo[ r, SinglePostureResidual[TableMarkerCoords[[iii]], DynQ[[iii]]] ];

	
	];

	(* res1 = Join[ Flatten[r] , 10 XX[[(endParametersIndex) + 1 ;;]] ]; *)
	
	   res1 = Flatten[r];
	
	Return[res1];
];

(*******************************************************************************)


MultiplePostureObjectiveFunctionWithAll[TableMarkerCoords_, XX_?VectorQ, GeomPosx_?VectorQ,\[Rho]\[Phi]\[Delta]Posx_?VectorQ, qPosx_?VectorQ]:=
	Module[{residual, obj},
		
		residual = MultiplePostureResidualWithAll[TableMarkerCoords, XX, GeomPosx, \[Rho]\[Phi]\[Delta]Posx, qPosx];
		obj = (0.5) (residual.residual);
		
		(*Print["Objective function value: ", obj];*)
		
		Return[obj];
	
	];


(* ::Section:: *)
(*Full Fledge Optimization*)


IdentifyMultiplePostureWithAllConstrained[Xsym_, TableMarkerCoords_, InitialValues_, GeomPosx_, \[Rho]\[Phi]\[Delta]Posx_, qPosx_, MaxIter_:40, accuracy_:4, precision_:4]:=
	Module[{Sol, EvalData, temp,
		    XsymGeom, Xsym\[Rho]\[Phi]\[Delta], XsymQ,
		    MedValGeom, MedVal\[Rho]\[Phi]\[Delta], II},

	        {Sol, EvalData} = Reap[Block[{iter = 1, eval = 1},

            Print["Identification started..."];
            
            MedValGeom = InitialValues[[ 1;;Length[GeomPosx] ]];
            MedVal\[Rho]\[Phi]\[Delta]   = InitialValues[[ Length[GeomPosx]+1 ;; Length[GeomPosx]+Length[\[Rho]\[Phi]\[Delta]Posx] ]];
            
            XsymGeom  = Xsym[[ 1 ;; Length[GeomPosx] ]];
            Xsym\[Rho]\[Phi]\[Delta]    = Xsym[[ Length[GeomPosx]+1 ;; Length[GeomPosx]+Length[\[Rho]\[Phi]\[Delta]Posx] ]];
            XsymQ     = Partition[ Xsym[[ Length[GeomPosx]+Length[\[Rho]\[Phi]\[Delta]Posx]+1 ;; ]], 7];
            
			FindMinimum[{ MultiplePostureObjectiveFunctionWithAll[TableMarkerCoords, Xsym, GeomPosx, \[Rho]\[Phi]\[Delta]Posx, qPosx],
			
			 (*Vincoli sulle variabili da ottimizzare. Sui parametri geometrici si sceglie un range di +-100mm rispetto ai valori medi*)
			 (And @@ Table[-100.0 + MedValGeom[[II]] <= XsymGeom[[II]] <= 100.0 + MedValGeom[[II]], {II, 1, Length[GeomPosx]}]) &&

			 (*Vincoli sulle \[Rho] +- 50 mm*)
			 (And @@ Table[-50.0 + MedVal\[Rho]\[Phi]\[Delta][[II]] <= Xsym\[Rho]\[Phi]\[Delta][[II]] <= 50.0 + MedVal\[Rho]\[Phi]\[Delta][[II]], {II, 1, Length[\[Rho]\[Phi]\[Delta]Posx],3}]) &&
			 
			 (*Vincoli sulle \[Phi]1 e \[Delta]1 +- 1 rad*)
			 (And @@ Table[-1.0 + MedVal\[Rho]\[Phi]\[Delta][[II]] <= Xsym\[Rho]\[Phi]\[Delta][[II]] <= 1.0 + MedVal\[Rho]\[Phi]\[Delta][[II]], {II, 2, 3}]) &&
			 
			 (*Vincoli sulle \[Phi]2 e \[Delta]2 +- 1 rad*)
			 (And @@ Table[-1.0 + MedVal\[Rho]\[Phi]\[Delta][[II]] <= Xsym\[Rho]\[Phi]\[Delta][[II]] <= 1.0 + MedVal\[Rho]\[Phi]\[Delta][[II]], {II, 5, 6}]) &&

			 (*Vincoli sulle \[Phi]3 e \[Delta]3 +- 1 rad*)
			 (And @@ Table[-1.0 + MedVal\[Rho]\[Phi]\[Delta][[II]] <= Xsym\[Rho]\[Phi]\[Delta][[II]] <= 1.0 + MedVal\[Rho]\[Phi]\[Delta][[II]], {II, 8, 9}]) &&

			 (*Vincoli sulle variabili da ottimizzare. Sugli angoli si usano upper bounds e lower bounds*)
			 (And @@ Table[ And @@ MapThread[ (#1 <= #2 <= #3)&, {qLB, XsymQ[[II]], qUB} ], {II, 1, Length[TableMarkerCoords]} ]) 
			            },	         
		     	         
		       Thread[ List[ Xsym, InitialValues] ],
		       (* Xsym, *)
				
				(* Method->"InteriorPoint", *)
				 
                 (* Method->{"Newton", "StepControl"->{"LineSearch", Method->"Backtracking"}}, *)

				EvaluationMonitor:>(
					Print[
						Style["Function evaluation number = ", Red], Style[eval++, Red],
						Style["\nCurrent variables = ", Darker[Red]], Style[Xsym, Darker[Red]]
					];

				),

				StepMonitor:>(
					Print[
						Style["======================================================================================================", Darker[Green],18,Bold],
						
						Style["\n|| ", Darker[Green],14,Bold], Style["Iteration ", Darker[Green],18, Bold], Style[iter++, Darker[Green],18,Bold],
						Style["\n||\n|| Current parameters = ", Darker[Green], 14, Bold], Style[Xsym, Darker[Green],14, Bold],
						Style["\n||\n|| Current objective function value = ", Darker[Orange], 14, Bold], 
						Style[MultiplePostureObjectiveFunctionWithAll[TableMarkerCoords, Xsym, GeomPosx, \[Rho]\[Phi]\[Delta]Posx, qPosx], Darker[Orange],14, Bold],
						
						Style["\n======================================================================================================", Darker[Green],18,Bold]
					];

					Sow[{Xsym, MultiplePostureObjectiveFunctionWithAll[TableMarkerCoords, Xsym, GeomPosx, \[Rho]\[Phi]\[Delta]Posx, qPosx]}];
					
					(* added export to temporary files *)
					(*Export["tmp.mat", {Xsym, MultiplePostureObjectiveFunctionWithAll[TableMarkerCoords, Xsym, GeomPosx, BMPosx, qPosx]}];*)

				),

				AccuracyGoal->accuracy,

				PrecisionGoal->precision,
				
				MaxIterations->MaxIter
			]

		]
	];

	(* FreeXP[]; *)

	temp = If[Length[EvalData[[1]]]==MaxIter, " (Maximum)", ""];

	Print[
		Style["\n\n===================================================", Blue, 20, Bold],
		Style["\nSummary", Blue, 20, Bold],
		Style["\n(Cradle Style Machine)", Blue, 16, Bold],
		Style["\n\nNumber of optimization variables = ", Blue], Style[Length[InitialValues], Blue],
		Style["\nOptimization variables = ", Blue], Style[Xsym, Blue],
		Style["\n\nAccuracy goal = ", Blue], Style[accuracy, Blue],
		Style["\nPrecision goal = ", Blue], Style[precision, Blue],
		Style["\nNumber of iterations = ", Blue], Style[Length[EvalData[[1]]], Blue], Style[temp, Blue],
		Style["\n\nInitial values = ", Blue], Style[InitialValues, Blue],
		Style[  "\nFinal values   = ", Blue], Style[(*Sol[[2,1,2]]*)Sol[[2]], Blue],
		Style["\n\nInitial residual function value = ", Blue], Style[EvalData[[1]][[1,2]], Blue],
		Style[  "\nFinal residual function value   = ", Blue], Style[EvalData[[1]][[-1,2]], Blue],
		Style["\n\n===================================================", Blue, 20, Bold]
	];

	{Sol, EvalData}
];



(* ::Section:: *)
(*Upper and Lower Bounds for Joint Angles*)


(* Upper and Lower Bounds for Joint Angles *)

(*qLB = { -180.Degree, -45.Degree, -150.Degree, -0.Degree, -270.Degree, -90.Degree, -45.Degree};

qUB = {45.Degree, 120Degree, 45.Degree , 150.Degree, 0.Degree, 90.Degree, 10.Degree};*)

qLB = { -180.Degree, -90.Degree, -90.Degree, -0.Degree, -90.Degree, -45.Degree, -90.Degree};

qUB = {0.Degree, 90Degree, 90.Degree , 150.Degree, 90.Degree, 10.Degree, 90.Degree};


(* ::Section:: *)
(*Filtro di Kalman*)


qSymAll = {
	qs1, qs2, qs3, qe1, qe2, qw1, qw2
	};


qSymAM = {qs1, qs2,qs3};
qSymFM = {qs1, qs2,qs3,qe1, qe2};
qSymHM = {qs1, qs2,qs3,qe1, qe2, qw1, qw2};

AMinAll = Flatten[Map[Position[qSymAll, #] &, qSymAM]];
FMinAll = Flatten[Map[Position[qSymAll, #] &, qSymFM]];
HMinAll = Flatten[Map[Position[qSymAll, #] &, qSymHM]];



AnglesFromZ[Z_]:=
	Module[{AngleList, III},
		
		AngleList = 0. Range[7];
		For[III=1, III<=7, III++,
			
			AngleList[[III]] = qLB[[III]] + 0.5*(qUB[[III]] - qLB[[III]])*(Sin[Z[[III]]] + 1);
			];
		
		Return[AngleList];
		
	];



XYZsJacobian[{
	qs1_, qs2_, qs3_, qe1_, qe2_, qw1_, qw2_
	}]:=
	Module[{Jac},
		
		Jac = ZeroMatrix[12*3,7]; (*il riferimento non ha variabili di giunto... le inserisco oppure modifico le dimensioni di Jac?*)
		
		(* Bone Markers *)
		
		(* Arm *)
		Jac[[{1,2,3}, AMinAll]] = JWorldAMK1[qs1, qs2, qs3];
		Jac[[{4,5,6}, AMinAll]] = JWorldAMK2[qs1, qs2, qs3];
		Jac[[{7,8,9}, AMinAll]] = JWorldAMK3[qs1, qs2, qs3];
		Jac[[{10,11,12}, AMinAll]] = JWorldAMK4[qs1, qs2, qs3];

		(*Forearm *)
		Jac[[{13,14,15}, FMinAll]] = JWorldFMK1[qs1, qs2, qs3, qe1, qe2];		
		Jac[[{16,17,18}, FMinAll]] = JWorldFMK2[qs1, qs2, qs3, qe1, qe2];
		Jac[[{19,20,21}, FMinAll]] = JWorldFMK3[qs1, qs2, qs3, qe1, qe2];
		Jac[[{22,23,24}, FMinAll]] = JWorldFMK4[qs1, qs2, qs3, qe1, qe2];
		
		(* Hand *)
		Jac[[{25,26,27}, HMinAll]] = JWorldHMK1[qs1, qs2, qs3, qe1, qe2, qw1, qw2];
		Jac[[{28,29,30}, HMinAll]] = JWorldHMK2[qs1, qs2, qs3, qe1, qe2, qw1, qw2];
		Jac[[{31,32,33}, HMinAll]] = JWorldHMK3[qs1, qs2, qs3, qe1, qe2, qw1, qw2];
		Jac[[{34,35,36}, HMinAll]] = JWorldHMK4[qs1, qs2, qs3, qe1, qe2, qw1, qw2];
		
		Return[Jac]; 
		
	];
(*Jac matrice 36x7*)



XYZsReducedJacobian[rows_, { 
							qs1_, qs2_, qs3_, qE1_, qE2_, qW1_, qW2_
						  }]:= Module[{},
											XYZsJacobian[{
															qs1, qs2, qs3, qE1, qE2, qW1, qW2
															}
															
															][[ rows, All ]]
	];


ExpandToTriplets[LIST_List]:=
	Module[{RES},
		
		RES = Flatten[ {(3 (# - 1) + 1), 3 (# - 1) + 2, 3 (# - 1) + 3} & /@LIST ];
		
		Return[RES];
		
	];



JacobianAnglesFromZ[Z_]:=
	Module[{JacobianList, Jacobian, ii},
		
		JacobianList = Table[0, {7}];
		
		For[ii=1, ii<=7, ii++,
			
			JacobianList[[ii]] = 0.5*(qUB[[ii]]-qLB[[ii]])*Cos[Z[[ii]]];
		];
		Jacobian = DiagonalMatrix[JacobianList];(*7x7*)
		
		Return[Jacobian];
		
	];



ResidualJacobianConstrained[MarkerCoords_, Z_?VectorQ] := 
								Module[{q, Jr, JXofZ, JrZ},
												
												q = AnglesFromZ[Z];
												
												Jr = -XYZsReducedJacobian[ExpandToTriplets[MarkerCoords[[2]]], q];
												
												JXofZ = JacobianAnglesFromZ[Z];
												
												JrZ = Jr.JXofZ;
												
												Return[JrZ];	
												
    ];


ResidualWithPriorsGradientConstrained[MarkerCoords_, Winv_, Pinv_, qPrior_?VectorQ, Z_?VectorQ] := 
								Module[{q, Jr, JrT, r, WinvRed, grad, gradZ},
												
												q = AnglesFromZ[Z];
												
												Jr = -XYZsReducedJacobian[ExpandToTriplets[MarkerCoords[[2]]], q]; (*36x7*)
												JrT = Transpose[Jr];                                               (*7x36*)
												
												r = SinglePostureResidual[MarkerCoords, q];                        (*36x1*)
												
												WinvRed = Winv[[ ExpandToTriplets[MarkerCoords[[2]]], ExpandToTriplets[MarkerCoords[[2]]] ]]; (*36x36*)
												
												grad = JrT.WinvRed.r + Pinv.(q-qPrior);		(*(7x36 .36x36 .36x1) + (7x7 .7x1) = 7x1+7x1*)  (*forse residui sulle configurazioni + boh*)
												
												gradZ = JacobianAnglesFromZ[Z].grad; (*7x7 .7x1*)
												
										 		Return[gradZ];	
												
    ];
(*gradZ 7x1*)


ResidualWithPriorsHessianConstrained[MarkerCoords_, Winv_, Pinv_, Z_?VectorQ] := 
								Module[{q, Jr, JrT, r, WinvRed, hess, JXofZ, hessZ},
												
												q = AnglesFromZ[Z];
												
												Jr = -XYZsReducedJacobian[ExpandToTriplets[MarkerCoords[[2]]], q];
												JrT = Transpose[Jr];
												
												WinvRed = Winv[[ ExpandToTriplets[MarkerCoords[[2]]], ExpandToTriplets[MarkerCoords[[2]]] ]]; 
												
												hess = JrT.WinvRed.Jr + Pinv;		
												
												JXofZ = JacobianAnglesFromZ[Z];
												
												hessZ = JXofZ.hess.JXofZ;
												
												Return[hessZ];	
												
    ];


SinglePostureObjectiveFunctionConstrained[MarkerCoords_, Z_?VectorQ]:=
	Module[{q, residual, obj},
		
		q = AnglesFromZ[Z];
		
		residual = SinglePostureResidual[MarkerCoords, q];
		obj = (0.5) residual.residual;
		
		Return[obj];
	];


SinglePostureResidualConstrained[MarkerCoords_, Z_?VectorQ]:=
		Module[{q, MarkerPoints, MarkerIndices,
			   residual
			   },
			
			q = AnglesFromZ[Z];
			
			MarkerPoints  = MarkerCoords[[1]];
			MarkerIndices = MarkerCoords[[2]];
			
			residual = Flatten[ MarkerPoints - XYZsModel[q][[MarkerIndices]] ];
			
			Return[residual];
			
		];


SinglePostureObjectiveFunctionWithPriorConstrained[MarkerCoords_, Winv_, Pinv_, qPrior_?VectorQ, Z_?VectorQ]:=
	Module[{q,
		residualPenalty, priorPenalty, WinvRed,
		residual, obj},
		
		q = AnglesFromZ[Z];
		
		residualPenalty = SinglePostureResidual[MarkerCoords, q];
		
		priorPenalty = q - qPrior;
		
		WinvRed = Winv[[ ExpandToTriplets[MarkerCoords[[2]]], ExpandToTriplets[MarkerCoords[[2]]] ]]; 
		
		obj = (0.5) (residualPenalty.WinvRed.residualPenalty + priorPenalty.Pinv.priorPenalty);
		
		Return[obj];
	];



ResidualWithPriorsHessian[MarkerCoords_, Winv_, Pinv_, q_?VectorQ] := 
								Module[{Jr, JrT, r, WinvRed, hess},
												
												Jr = -XYZsReducedJacobian[ExpandToTriplets[MarkerCoords[[2]]], q];
												JrT = Transpose[Jr];
												
												WinvRed = Winv[[ ExpandToTriplets[MarkerCoords[[2]]], ExpandToTriplets[MarkerCoords[[2]]] ]]; 
												
												hess = JrT.WinvRed.Jr + Pinv;		
												
												Return[hess];	
												
    ];


IdentifySinglePostureEKFConstrained[MarkerCoords_, ZPrior_, Winv_, Pinv_, MaxIter_:40, accuracy_:4, precision_:4]:=
Module[{Sol, EvalData, temp, ZStart, qPrior, qStart},
	   {Sol, EvalData} = Reap[Block[{iter = 1, eval = 1},

            Print["EKF identification started..."];

            ZStart = ZPrior;
            qPrior = AnglesFromZ[ZPrior];
            qStart = qPrior;

			FindMinimum[SinglePostureObjectiveFunctionWithPriorConstrained[MarkerCoords, Winv, Pinv, qPrior, Z]
		     	         
		      , {Z, ZPrior},
		      
		      Gradient -> (ResidualWithPriorsGradientConstrained[MarkerCoords, Winv, Pinv, qPrior, Z]),
				
				Method->{"Newton",
						 "Hessian"-> (ResidualWithPriorsHessianConstrained[MarkerCoords, Winv, Pinv, Z]),
						 "StepControl"->{"TrustRegion" , "StartingScaledStepSize"->10}},
				 
                 (*Method->{"Newton", "StepControl"->{"LineSearch", Method->"Backtracking"}},*)

				(*EvaluationMonitor:>(
					Print[
						Style["Function evaluation number = ", Red], Style[eval++, Red],
						Style["\nCurrent variables = ", Darker[Red]], Style[X, Darker[Red]]
					];

				),*)

				StepMonitor:>(
					Print[
						Style["======================================================================================================", Darker[Green],18,Bold],
						
						Style["\n|| ", Darker[Green],14,Bold], Style["Iteration ", Darker[Green],18, Bold], Style[iter++, Darker[Green],18,Bold],
						Style["\n||\n|| Current Zs = ", Darker[Green], 14, Bold], Style[Z, Darker[Green],14, Bold],
						Style["\n||\n|| Current Xs = ", Darker[Green], 14, Bold], Style[AnglesFromZ[Z], Darker[Green],14, Bold],
						Style["\n||\n|| Current objective function value = ", Darker[Orange], 14, Bold], 
						Style[SinglePostureObjectiveFunctionWithPriorConstrained[MarkerCoords, Winv, Pinv, qPrior, Z], Darker[Orange],14, Bold],
						
						Style["\n======================================================================================================", Darker[Green],18,Bold]
					];

					Sow[{Z,AnglesFromZ[Z], SinglePostureObjectiveFunctionWithPriorConstrained[MarkerCoords, Winv, Pinv, qPrior, Z],SinglePostureResidualConstrained[MarkerCoords,Z]}];

				),

				AccuracyGoal->accuracy,

				PrecisionGoal->precision,
				
				MaxIterations->MaxIter
			]

		]
	];

	(* FreeXP[]; *)

	temp = If[Length[EvalData[[1]]]==MaxIter, " (Maximum)", ""];

	Print[
		Style["\n\n===================================================", Blue, 20, Bold],
		Style["\nSummary", Blue, 20, Bold],
		Style["\n(Constrained EKF Tracking)", Blue, 16, Bold],
		Style["\n\nNumber of optimization variables = ", Blue], Style[Length[qPrior], Blue],
		Style["\n\nAccuracy goal = ", Blue], Style[accuracy, Blue],
		Style["\nPrecision goal = ", Blue], Style[precision, Blue],
		Style["\nNumber of iterations = ", Blue], Style[Length[EvalData[[1]]], Blue], Style[temp, Blue],
		Style["\n\nInitial Zs = ", Blue], Style[ZStart, Blue],
		Style[ "\nFinal    Zs = ", Blue], Style[Sol[[2,1,2]], Blue],
		Style["\n\nInitial Xs = ", Blue], Style[qStart, Blue],
		Style[ "\nFinal    Xs = ", Blue], Style[AnglesFromZ[ Sol[[2,1,2]] ], Blue],
		Style["\n\nInitial residual function value = ", Blue], Style[EvalData[[1]][[1,3]], Blue],
		Style[  "\nFinal residual function value   = ", Blue], Style[EvalData[[1]][[-1,3]], Blue],
		Style["\n\n===================================================", Blue, 20, Bold]
	];

	{Sol, EvalData}
];



IdentifySinglePostureConstrainedZ[MarkerCoords_, InitialValues_, MaxIter_:40, accuracy_:4, precision_:4]:=
Module[{Sol, EvalData, temp},
	   {Sol, EvalData} = Reap[Block[{iter = 1, eval = 1},

            Print["Identification started..."];
			FindMinimum[SinglePostureObjectiveFunctionConstrained[MarkerCoords, Z]
		     	         
		      , {Z, InitialValues},
				Method->{"LevenbergMarquardt",
						 "Residual" -> (SinglePostureResidualConstrained[MarkerCoords, Z]),
						 "Jacobian"-> (ResidualJacobianConstrained[MarkerCoords, Z]),
						 "StepControl"->{"TrustRegion" , "StartingScaledStepSize"->10}},
				 
                 (* Method->{"Newton", "StepControl"->{"LineSearch", Method->"Backtracking"}}, *)

				(*EvaluationMonitor:>(
					Print[
						Style["Function evaluation number = ", Red], Style[eval++, Red],
						Style["\nCurrent variables = ", Darker[Red]], Style[X, Darker[Red]]
					];

				),*)

				StepMonitor:>(
					Print[
						Style["======================================================================================================", Darker[Green],18,Bold],
						
						Style["\n|| ", Darker[Green],14,Bold], Style["Iteration ", Darker[Green],18, Bold], Style[iter++, Darker[Green],18,Bold],
						Style["\n||\n|| Current Zs = ", Darker[Green], 14, Bold], Style[Z, Darker[Green],14, Bold],
						Style["\n||\n|| Current Xs = ", Darker[Green], 14, Bold], Style[AnglesFromZ[Z], Darker[Green],14, Bold],
						Style["\n||\n|| Current objective function value = ", Darker[Orange], 14, Bold], 
						Style[SinglePostureObjectiveFunctionConstrained[MarkerCoords, Z], Darker[Orange],14, Bold],
						
						Style["\n======================================================================================================", Darker[Green],18,Bold]
					];

					Sow[{Z, AnglesFromZ[Z], SinglePostureObjectiveFunctionConstrained[MarkerCoords, Z],SinglePostureResidualConstrained[MarkerCoords, Z]}];

				),

				AccuracyGoal->accuracy,

				PrecisionGoal->precision,
				
				MaxIterations->MaxIter
			]

		]
	];

	(* FreeXP[]; *)

	temp = If[Length[EvalData[[1]]]==MaxIter, " (Maximum)", ""];

	Print[
		Style["\n\n===================================================", Blue, 20, Bold],
		Style["\nSummary", Blue, 20, Bold],
		Style["\n(Cradle Style Machine)", Blue, 16, Bold],
		Style["\n\nNumber of optimization variables = ", Blue], Style[Length[InitialValues], Blue],
		Style["\n\nAccuracy goal = ", Blue], Style[accuracy, Blue],
		Style["\nPrecision goal = ", Blue], Style[precision, Blue],
		Style["\nNumber of iterations = ", Blue], Style[Length[EvalData[[1]]], Blue], Style[temp, Blue],
		Style["\n\nInitial Zs = ", Blue], Style[InitialValues, Blue],
		Style[ "\nFinal    Zs = ", Blue], Style[Sol[[2,1,2]], Blue],
		Style["\n\nInitial Xs = ", Blue], Style[AnglesFromZ[InitialValues], Blue],
		Style[ "\nFinal    Xs = ", Blue], Style[AnglesFromZ[ Sol[[2,1,2]] ], Blue],
		Style["\n\nInitial residual function value = ", Blue], Style[EvalData[[1]][[1,3]], Blue],
		Style[  "\nFinal residual function value   = ", Blue], Style[EvalData[[1]][[-1,3]], Blue],
		Style["\n\n===================================================", Blue, 20, Bold]
	];

	{Sol, EvalData}
];




IdentifyManyPosturesEKFConstrained[TableMarkerCoords_, InitialValues_, W0_, V0_, P0_, MaxIter_:40, accuracy_:4, precision_:4]:=
Module[{Frames,
	    ZPrior,
	    qPrior, I,
	    PP, W, H,
	    Pinv, Winv,
	    SolStart, EvalStart,
	    Sol, Eval,
	    qlist,
		stream
	    },
	
	Frames = Length[TableMarkerCoords];
	qlist = {};
	
	(* Prima soluzione statica per trovare uno stato iniziale buono, compatibile con le letture del Phase Space *)
	{SolStart, EvalStart} = IdentifySinglePostureConstrainedZ[TableMarkerCoords[[1]], InitialValues, 200, accuracy, precision];
	
	ZPrior = SolStart[[ 2,1,2 ]]; 
	qPrior = AnglesFromZ[ZPrior];

	PP = P0;
	W = W0;

	(* open a file to write a temporary output *)
	(* if the variable tmpfilename exists already, it uses the one defined instead of generating a new one (thus, it would be better to define it in the main notebook) *)
	If[Not[ValueQ[tempfilename]],tempfilename=FileNameJoin[{$TemporaryDirectory,"tmp_IdentifyManyPosturesEKFConstrained_" <> DateString[{"Year","_","Month","_","Day","_h","Hour","_m","Minute"}]<>".txt"}];];
	Print[tempfilename];
	stream=OpenWrite[tempfilename];
	Close[stream];
	RenameFile[tempfilename,tempfilename<>".old"];
	stream=OpenWrite[tempfilename];
	Close[stream];

	For[I=1, I<=Frames, I++,
		
		Print[
			Style["%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%", Darker[Red],18,Bold],
						
		    Style["\n%% ", Darker[Red],14,Bold], 
			Style["\n%% Reconstructing Posture ", Darker[Red], 14, Bold], Style[I, Darker[Red], 14, Bold], 
			Style[" of ", Darker[Red], 14, Bold], Style[Frames, Darker[Red], 14, Bold], 
			Style["\n%% ", Darker[Red],14,Bold],
			Style["\n%% ", Darker[Red],14,Bold], 			
			Style["\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%", Darker[Red],18,Bold]
					];
	
			PP = PP + V0;
			Pinv = PseudoInverse[PP];

			(* currently no update to the measurement noise covariance *)
			Winv = PseudoInverse[W];	
			
			H = ResidualWithPriorsHessian[TableMarkerCoords[[I]], Winv, Pinv, qPrior];	
	
	        {Sol, Eval} = IdentifySinglePostureEKFConstrained[TableMarkerCoords[[I]], ZPrior, Winv, Pinv, MaxIter, accuracy, precision];

	        ZPrior = Sol[[ 2,1,2 ]];
	        qPrior = AnglesFromZ[ZPrior];

	        PP = PseudoInverse[H];

	        (* when appending, the output should be made of all variables (they have to be used with graphic functions and so on...) *)
	        qlist = Append[ qlist, qPrior ];

			(* write every 5 iterations *)
			If[
				Mod[Dimensions[qlist,1],5]=={0},
				DeleteFile[tempfilename<>".old"];
				RenameFile[tempfilename,tempfilename<>".old"];
				stream=OpenWrite[tempfilename];
				Write[stream,qlist];
				Close[stream];
			]

	];
	
	DeleteFile[tempfilename<>".old"];
	DeleteFile[tempfilename];
	Return[qlist];
	
];



(* ::Section:: *)
(*END PACKAGE*)


EndPackage[]
