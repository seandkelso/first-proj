%Sean Kelso
%DNA_RNAseq Project

%DNA has base pairs Cytosine (C), Guanine (G), Thymine (T), and Adenine(A).
%RNA has base pairs Guanine (G), Cytosine (C), Adenine (A), and Uracil (U).
%DNA is converted to RNA in a biological process called Transcription:
% C -> G
% G -> C
% T -> A
% A -> U

%GOALS OF DNA_RNAseq.m: 
% 1) read in a text file (only with base pairs) to convert from DNA to RNA, using their base pairs
% 2) calculate the RNA base pair percentages: ie. 30% A, 30% U, 20%C, 20% G
% 3) searches for RNA sequence that the user inputs: ie. AUG
%if present, displays location of it in the RNA file, highlights it RED in an outputted .html file 

clear; clc; 
dnaFile = 0;
while dnaFile < 1
   filename = input('Open file: ', 's'); %prompt, asking for a file to open
   [dnaFile, message] = fopen(filename, 'r'); %opens filename for reading
   if dnaFile == -1
     disp(message) %displays error message if the file does not work
   end
end
inputBase = input('Enter RNA sequence of interest: ', 's'); %user inputs a sequence of RNA base pairs to search for

if length(filename) > 4 && strcmp(filename(end-3 : end), '.dna') %lines 31-35: adapted code from previous coursework
    outputFile = [filename(1:end-4) '.html'] %renames the end of output file to .html
else 
    outputFile = [ 'rna.html'] %renames the output file to "rna.html"
end

[rnaFile, message] = fopen(outputFile, 'w+'); %opens rnaFile for reading AND writing
[base, num] = fread(dnaFile, 1, 'char'); %reads through dnaFile 1 character at-a-time
countG = 0; %intializes G count to 0
countC = 0; %intializes C count to 0
countA = 0; %intializes A count to 0
countU = 0; %intializes U count to 0
baseCount = 0; %initializes total count to 0

while num > 0 
 baseCount = baseCount + 1; %sums the total number of base pairs in the given file
 
    if base == 'C' %C(DNA) --> G(RNA)
        out = 'G';
        countG = countG + 1; %adds 1 to the Guanine (G) base pair count
    elseif base == 'G' %G(DNA) --> C(RNA)
        out = 'C';
        countC = countC + 1; %adds 1 to the Cytosine (C) base pair count
    elseif base == 'T' %T(DNA) --> A(RNA)
        out = 'A';
        countA = countA + 1; %adds 1 to the Adenine (A) base pair count
    elseif base == 'A' %A(DNA) --> U(RNA)
        out = 'U';
        countU = countU + 1; %adds 1 to the Uracil (U) base pair count
    else
        out = '_'; %if the given input is not one of the 4 RNA base pairs, outputs a blank line to indicate not being a part of RNA sequence
    end

[base, num] = fread(dnaFile, 1, 'char'); %reads through 1 character at-a-time
text(baseCount) = out; %writes the corresponding RNA nucleotides, saves them in 'text'
end

freqG = countG ./ baseCount * 100; %frequency of Guanine (percentage)
freqC = countC ./ baseCount * 100; %frequency of Cytosine (percentage)
freqA = countA ./ baseCount * 100; %frequency of Adenine (percentage)
freqU = countU ./ baseCount * 100; %frequency of Uracil (percentage)

location = strfind(text, inputBase) %location(s) of left-most occurrence of user's desired RNA sequence
patternLength = length(inputBase); 
lineLength = 72; %used later for modulus and formatting sequence
fprintf(rnaFile, '<html><head></head><body>\n'); %opens html and body (opens and closes head)
for i = 1:length(text)
   inMatch = false;
   
   for j = 1:length(location)
      if  ( (i >= location(j)) && (i < (location(j)+patternLength)) )
          inMatch = true;
      end
   end
   
   if inMatch == true
       fprintf(rnaFile, '<font color="red">%c</font>', text(i)); %colors the desired sequences RED
   else
      fprintf(rnaFile, '<font color="blue">%c</font>', text(i)); %colors rest of sequence BLUE
   end
   
   if (mod(i, lineLength) == 0)
       fprintf(rnaFile, '\n'); %uses modulus to format the html file, prints a new line every 'line length' amount of characters, in this case every 72 characters, it prints a new line
   end
end

fprintf(rnaFile, '<p><u><font size="4" color="LimeGreen">RNA base pair frequencies:</font></u></p>'); %This line is underlined, lime green, and in larger font size (4)
fprintf(rnaFile, '<ul>'); %creates an unordered list
fprintf(rnaFile, '<li><font color="GoldenRod">G: %.4f%%\n</font>', freqG); %G frequency = goldenrod
fprintf(rnaFile, '<li><font color="GoldenRod">C: %.4f%%\n</font>', freqC); %C frequency = goldenrod
fprintf(rnaFile, '<li><font color="GoldenRod">A: %.4f%%\n</font>', freqA); %A frequency = goldenrod
fprintf(rnaFile, '<li><font color="GoldenRod">U: %.4f%%\n</font>', freqU); %U frequency = goldenrod
fprintf(rnaFile, '</ul>'); %closes unordered list
fprintf(rnaFile, '</body></html>\n'); %closes body & html

fclose(dnaFile); %closes DNA file
fclose(rnaFile); %closes RNA file
