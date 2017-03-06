 function export_ascii_sym(MAT_SYM,FILENAME,MAT_NAME)
 

 % Usage example
 %
 % export_ascii_sym(symbolic_matrix,'file','matrix_name')
 %
 % where 
 %	symbolic_matrix is the name of a symbolic matrix 
 %	present in the workspace
 %
 %	'file' is the filename where the ascii information 
 %	will be stored
 %
 %	'matrix_name' is the resulting matrix of the function
 %	The last two fields must be either 'char' type 
 % variables or strings within characters "'"
 %
 %	The function assigns "file.m" as the function file.
 %
 % Thank you very much for your patience
 

 [m,n]=size(MAT_SYM);
 

 character=char(MAT_SYM);
 

 sym_variables=symvar(character);
 

 clear character;
 

 full_filename=[FILENAME,sprintf('.m')];
 

 fid = fopen(full_filename,'w');
 

 fprintf(fid,'function [%s]= %s(',MAT_NAME,FILENAME);
 

 for i=1:1:size(sym_variables,1),
 	if i==size(sym_variables,1),
 	fprintf(fid,'%s)',char(sym_variables(i)));
 	else
 	fprintf(fid,'%s, ',char(sym_variables(i)));
 	end
 end
 

 fprintf(fid,'\n%% Depending variables :\n');
 

 for i=1:1:size(sym_variables,1),
 	fprintf(fid,'%% \t\t\t\t\t\t %s \n',char(sym_variables(i)));
 end
 

 fprintf(fid,'\n');
 	
 fprintf(fid,'%s = [\n',MAT_NAME);
 

 for i=1:1:m,
 	for j=1:1:n,
 	aux=char(MAT_SYM(i,j));
 	if j==n,
 	fprintf(fid,'%s',aux);
 	else
 	fprintf(fid,'%s, ',aux);
 	end
 	end
 	fprintf(fid,'; \n');
 end
 

 fprintf(fid,'];');
 

 fclose(fid);