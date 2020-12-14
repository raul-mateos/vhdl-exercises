% export_txt(file_name, x)

function export_txt(file_name, x)

if (nargin ~= 2)
  error('Invalid number of arguments')
end 

if (~isvector(x) || ~isinteger(x))
  error('x must be a vector of integers')
end 


fp = fopen(file_name, 'w');
for i = 1:length(x)
  fprintf(fp, '%d\n', x(i));
end;
fclose(fp);

end
