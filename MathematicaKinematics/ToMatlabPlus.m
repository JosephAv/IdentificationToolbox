(* ::Package:: *)

(* :Title:  To Matlab Plus *)

(* :Author:  Felipe Belo,
             Universita di Pisa,
             felipebelo@gmail.com
*)

(* :Date:    24 Apr 2010 *)

(* :Summary:
	This package extends the functions of the ToMatlab package:
	http://library.wolfram.com/infocenter/MathSource/577/
*)

(* :Package Version:        0.1 *)

(* :Mathematica Version:    7.0.0 *)

(* REQUIRES TOMATLAB LIBRARY INSTALLED TO WORK *)

(*-----------------------------------*)



BeginPackage["ToMatlabPlus`"];


Off[General::spell1,General::spell];


CreateMatlabFile::usage="CreateMatlabFile[function,functionName,params,directory] TODO";


CreateMatlabFileParser::usage="CreateMatlabFileParser[functionName,inputs,params,directory] TODO.
CreateMatlabFileParser[functionName,inputs,directory]";


Begin["`Private`"];


<<ToMatlab.m


CreateParamsString[list__]:=StringDrop[
StringJoin[ToString[#]<>","&/@({list}//Flatten)],
-1]


CreateFunctionString[fun_, params_]:=
ToString["function out = "<>ToString[fun]<>"("<>CreateParamsString[params]<>") \n \n "<>"out"]


CreateMatlabFile[function_,functionName_,params_,directory_]:=
Module[{stringAux},
stringAux=CreateFunctionString[functionName,params];
WriteMatlab[function, FileNameJoin[{directory,StringJoin[functionName,".m"]}]
,stringAux]
];


CreateMatlabFileParser[functionName_,inputs_,params_,directory_]:=
Module[{numofinputs,numofparams,insInputStr,paramsInputStr,functionStr,paramsStr,outputStr,scriptStr},
numofinputs=Length[inputs//Flatten];
numofparams=Length[params//Flatten];
insInputStr=StringDrop[
StringJoin["in("<>ToString[#]<>")," &/@Table[i,{i,numofinputs}]],
-1];
If[numofparams>0,
paramsInputStr=StringDrop[StringJoin["params("<>ToString[#]<>")," &/@Table[i,{i,numofparams}]],-1];
paramsStr=StringJoin["params = [",CreateParamsString[params], "];"];
];
functionStr = StringJoin["function out = ",functionName,"Parser(in)"];
If[numofparams>0,
outputStr=StringJoin["out = ",functionName, "(",insInputStr,",",paramsInputStr, ");"];
scriptStr = StringJoin[functionStr,"\n\n","Parameters\n\n",paramsStr,"\n\n",outputStr,"\n"];,
outputStr=StringJoin["out = ",functionName, "(",insInputStr, ");"];   (*Complete parser*)
scriptStr = StringJoin[functionStr,"\n\n",outputStr,"\n"];
];
Export[FileNameJoin[{directory,StringJoin[functionName,"Parser.m"]}],scriptStr,"String"];
]


CreateMatlabFileParser[functionName_,inputs_,directory_]:=
CreateMatlabFileParser[functionName,inputs,{},directory];


End[];


On[General::spell1,General::spell];


EndPackage[]
