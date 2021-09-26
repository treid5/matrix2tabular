function Tabular = Matrix2Tabular(M,SigFigs)
%Matrix2Tabular
%Tim Reid
%April 10, 2018
%
%This function converts a Matlab matrix into the format of the tabular
%   environment in LaTeX. Each value in the matrix is output in
%   scientific noation and rounded to the specified amount of significant
%   figures. 
%
%Inputs
%   The first input is the matrix that you want converted to the style of
%       the LaTeX tabular environment
%   The second input is the amount of significant figures that you want
%       each value rounded to. If this is input as a vector whose length is
%       equal to the amount of columns in the matrix, then the ith column
%       will be rounded to the amount of significant figures specified
%       in the ith entry of the SigFigs vector.
%
%Output
%   The output is a matrix of strings that is formatted like the interior
%       of the LaTeX tabular environment. The output is intended to be copy
%       pasted from the command window into the LaTeX tabular environment.
%       It is up to the user to know how to use the LaTeX tabular
%       environment.
%
%Example
%   A = [1.49,.5*exp(1);.00000983,50*pi];
%   SF = [1,4]
%   Matrix2Tabular(A,SF)
%   OR
%   Matrix2Tabular(A,1)
%

SizeM = size(M);            %Storing the size of the matrix    
TabularRow = [];            %Initilizing the first row of the tabular
SigFigs = floor(SigFigs);   %Protecting the program from stupid inputs

%
%   Determining if the SigFigs input is a number or a vector
%
if (length(SigFigs) == SizeM(2)) == 0
    SigFigs = SigFigs(1)*ones(1,SizeM(2));
end

%
%   Creating the tabular version of the first row
%
%   The Num2SciString function is called to convert numbers to strings
%       where the number is presented rounded and in scientific notation
%
for c = 1:SizeM(2)
    if c < SizeM(2)     %Interior columns have & at the end
        TabularRow = [TabularRow,Num2SciString(M(1,c),SigFigs(c),0)];
    else                %End columns have \\ at the end
        TabularRow = [TabularRow,Num2SciString(M(1,c),SigFigs(c),1)];
    end
end

Tabular = TabularRow;   %Initializing the output with the first row

%
%   Creating the tabular versions of the remaining rows
%
for r = 2:SizeM(1)
    TabularRow=[];
    for c = 1:SizeM(2)
        if c < SizeM(2)
            TabularRow = [TabularRow,Num2SciString(M(r,c),SigFigs(c),0)];
        else
            TabularRow = [TabularRow,Num2SciString(M(r,c),SigFigs(c),1)];
        end
    end
%
%   The rows are padded with spaces so that they are the same size and can
%       be concatenated
%
    SizeTab = size(Tabular);
    SizeRow = size(TabularRow);
    SizeDiff = SizeRow(2)-SizeTab(2);
    if SizeTab(2) < SizeRow(2)
        Tabular = [Tabular,repmat(' ',SizeTab(1),SizeDiff)];
    elseif SizeTab(2) > SizeRow(2)
        TabularRow = [TabularRow,repmat(' ',1,-SizeDiff)];
    end
    Tabular = [Tabular; TabularRow];
end


function Num = Num2SciString(Num,SigFigs,EndCol)
%Num2SciString
%Tim Reid
%April 10, 2018
%
%This function is intended to be used by Matrix2Tabular. This function
%   converts a double precision number into a LaTeX style string verson of
%   the number rounded to the specified amount of significant digits and
%   put into scientific notation.
%
%Output
%   A number is output as a matrix of strings in the form:
%       \( 'ROUNDED NUMBER HERE' \times 10^{EXPONENT HERE} \) &
%   OR
%       \( 'ROUNDED NUMBER HERE' \times 10^{EXPONENT HERE} \) \\

if Num == 0
    if EndCol == 0
        Num = ['\( 0 \) & '];
    else
        Num = ['\( 0 \) \\ '];
    end
    return
elseif SigFigs == 0
    if EndCol == 0
        Num = ['\( ',num2str(Num),' \) & '];
    else
        Num = ['\( ',num2str(Num),' \) \\ '];
    end
    return
else
    NumExp = floor(log(abs(Num))/log(10));   %Finding the number's power of 10
    Num = round(Num/10^NumExp,SigFigs); %Rounding the number to specified digits
end

%
%   Numbers have a \times 10^x if x is not zero
%       Numbers have a & at the end of their string if they are in an
%           interior column and a \\ at the end of their string if they are 
%           in an end column
%
if NumExp == 0
    if EndCol == 0
        Num = ['\(',num2str(Num),'\) & '];
    else
        Num = ['\(',num2str(Num),'\) \\ '];
    end
else
    if EndCol == 0
        Num = ['\(',num2str(Num),' \times 10^{',num2str(NumExp),'}\) & '];
    else
        Num = ['\(',num2str(Num),' \times 10^{',num2str(NumExp),'}\) \\ '];
    end
end

