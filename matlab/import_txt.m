% y = import_txt(file_name)

function y = import_txt(file_name)

if (nargin ~= 1)
  error('Invalid number of arguments')
end 

y = [];

fp = fopen(file_name, 'r');
if (fp ~= -1)
  y = fscanf(fp, '%d');
  fclose(fp);
else
  error('File not found');
end

end
